package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/binary"
	"encoding/pem"
	"errors"
	"fmt"
	"log"
	"net"
	"os"

	"ciphered-chat/common"
)

func main() {
	if len(os.Args) > 1 && (os.Args[1] == "help" || os.Args[1] == "--help" || os.Args[1] == "-h") {
		fmt.Println("Usage: ./server <host>")
	}

	if len(os.Args) != 2 {
		fmt.Println("Usage: ./server <host>")
		os.Exit(64)
	}

	host := os.Args[1]

	conn, err := net.Dial("tcp", host)
	if err != nil {
		fmt.Printf("Could not connect to server: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close()

	fmt.Printf("Established connection to %v\n", conn.RemoteAddr())

	key, err := performHandshake(conn)
	if err != nil {
		log.Fatalf("Error performing handshake with server: %v\n", err)
	}
	fmt.Println("Performed handshake with server")

	aesBlock, err := aes.NewCipher(key[:])
	if err != nil {
		log.Fatalf("Could not create cipher: %v\n", err)
	}

	cReadline := make(chan string)
	cReceive := make(chan []byte)
	cClose := make(chan string)

	go handleConn(conn, cReceive, cClose)
	go handleConsole(cReadline, cClose)

	for {
		select {
		case toSend := <-cReadline:
			msg := []byte(toSend)
			streamCipher := cipher.NewCTR(aesBlock, common.IV)
			streamCipher.XORKeyStream(msg, msg)

			common.WriteMessage(conn, msg)

		case msg := <-cReceive:
			streamCipher := cipher.NewCTR(aesBlock, common.IV)
			streamCipher.XORKeyStream(msg, msg)
			fmt.Print(string(msg))

		case closeMsg := <-cClose:
			fmt.Println(closeMsg)
			os.Exit(0)
		}
	}
}

func handleConn(conn net.Conn, ch chan []byte, cClose chan string) {
	for {
		msg, err := common.ReadMessage(conn)
		if err != nil {
			cClose <- err.Error()
			return
		}

		ch <- msg
	}
}

func handleConsole(ch chan string, cClose chan string) {
	reader := bufio.NewReader(os.Stdin)
	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			cClose <- "Could not read from stdin"
		}
		ch <- text
	}
}

func performHandshake(conn net.Conn) (key [32]byte, error error) {
	buf := make([]byte, 1024)
	n, err := conn.Read(buf)
	if err != nil {
		return [32]byte{}, err
	}
	if n == 0 {
		return [32]byte{}, errors.New("Could not perform handshake: unexpected EOF")
	}

	keyBlock, _ := pem.Decode(buf)
	if keyBlock == nil {
		return [32]byte{}, errors.New("Could not perform handshake: error parsing public key block")
	}

	publicKey, err := x509.ParsePKCS1PublicKey(keyBlock.Bytes)
	if err != nil {
		return [32]byte{}, err
	}

	var symmetricKey [32]byte
	rand.Read(symmetricKey[:])

	encryptedKey, err := rsa.EncryptOAEP(common.RsaHash, rand.Reader, publicKey, symmetricKey[:], common.SymmetricKeyLabel)
	if err != nil {
		return [32]byte{}, err
	}

	err = binary.Write(conn, common.ByteOrder, encryptedKey)
	if err != nil {
		return [32]byte{}, err
	}

	return symmetricKey, nil
}
