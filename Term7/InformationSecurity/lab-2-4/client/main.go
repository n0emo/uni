package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	"crypto/ed25519"
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

type State struct {
	conn       net.Conn
	aesBlock   cipher.Block
	signingKey ed25519.PublicKey
}

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

	state, err := performHandshake(conn)
	if err != nil {
		log.Fatalf("Error performing handshake with server: %v\n", err)
	}
	fmt.Println("Performed handshake with server")

	cReadline := make(chan string)
	cReceive := make(chan []byte)
	cClose := make(chan string)

	go handleConn(&state, cReceive, cClose)
	go handleConsole(cReadline, cClose)

	for {
		select {
		case toSend := <-cReadline:
			msg := []byte(toSend)
			streamCipher := cipher.NewCTR(state.aesBlock, common.IV)
			streamCipher.XORKeyStream(msg, msg)

			common.WriteMessage(conn, msg)

		case msg := <-cReceive:
			fmt.Print(string(msg))

		case closeMsg := <-cClose:
			fmt.Println(closeMsg)
			os.Exit(0)
		}
	}
}

func handleConn(state *State, ch chan []byte, cClose chan string) {
	for {
		msg, err := common.ReadMessage(state.conn)
		if err != nil {
			cClose <- err.Error()
			return
		}

		streamCipher := cipher.NewCTR(state.aesBlock, common.IV)
		streamCipher.XORKeyStream(msg, msg)

		sig, err := common.ReadMessage(state.conn)
		if err != nil {
			cClose <- err.Error()
			return
		}

		if !ed25519.Verify(state.signingKey, msg, sig) {
			cClose <- "Invalid digital signature"
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

func performHandshake(conn net.Conn) (s State, error error) {
	buf := make([]byte, 1024)
	n, err := conn.Read(buf)
	if err != nil {
		return State{}, err
	}
	if n == 0 {
		return State{}, errors.New("Could not perform handshake: unexpected EOF")
	}

	keyBlock, _ := pem.Decode(buf)
	if keyBlock == nil {
		return State{}, errors.New("Could not perform handshake: error parsing public key block")
	}

	publicKey, err := x509.ParsePKCS1PublicKey(keyBlock.Bytes)
	if err != nil {
		return State{}, err
	}

	var symmetricKey [32]byte
	rand.Read(symmetricKey[:])

	encryptedKey, err := rsa.EncryptOAEP(common.RsaHash, rand.Reader, publicKey, symmetricKey[:], common.SymmetricKeyLabel)
	if err != nil {
		return State{}, err
	}

	err = binary.Write(conn, common.ByteOrder, encryptedKey)
	if err != nil {
		return State{}, err
	}

	aesBlock, err := aes.NewCipher(symmetricKey[:])
	if err != nil {
		log.Fatalf("Could not create cipher: %v\n", err)
	}

	signingKeyBuf := make([]byte, ed25519.PublicKeySize)
	n, err = conn.Read(signingKeyBuf)
	if err != nil {
		return State{}, nil
	}
	if n != ed25519.PublicKeySize {
		return State{}, errors.New("Coul not get public signing key")
	}

	state := State{
		conn:       conn,
		aesBlock:   aesBlock,
		signingKey: signingKeyBuf,
	}

	return state, nil
}
