package main

import (
	"ciphered-chat/common"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"errors"
	"fmt"
	"log"
	"net"
	"os"
	"sync"
)

func main() {
	if len(os.Args) > 1 && (os.Args[1] == "help" || os.Args[1] == "--help" || os.Args[1] == "-h") {
		fmt.Println("Usage: ./server [host]")
	}

	host := "127.0.0.1:8080"
	if len(os.Args) > 1 {
		host = os.Args[1]
	}

	server, err := NewServer(host)
	if err != nil {
		log.Fatalf("Could not start server: %v", err)
	}
	defer server.Close()
	log.Printf("Listening at %v\n", server.Addr())

	server.Serve()
}

type Server struct {
	mu       sync.Mutex
	addr     string
	listener net.Listener
	clients  map[string]Client
	salt     []byte
}

type Client struct {
	conn     net.Conn
	ch       chan []byte
	aesBlock cipher.Block
}

func NewServer(host string) (*Server, error) {
	tcplistener, err := net.Listen("tcp", host)
	if err != nil {
		return nil, err
	}

	salt := make([]byte, 4096)
	rand.Read(salt)

	server := &Server{
		clients:  make(map[string]Client),
		addr:     tcplistener.Addr().String(),
		listener: tcplistener,
	}

	return server, nil
}

func (s *Server) Close() {
	s.listener.Close()
}

func (s *Server) Addr() string {
	return s.addr
}

func (s *Server) Serve() {
	for {
		conn, err := s.listener.Accept()
		if err != nil {
			log.Printf("Could not accept connection: %v", err)
			continue
		}

		go s.handleConnection(conn)
	}
}

func (s *Server) handleConnection(conn net.Conn) {
	defer func() {
		conn.Close()
		log.Printf("%v disconnected\n", conn.RemoteAddr())
	}()

	client, err := s.performHandshake(conn)
	if err != nil {
		log.Printf("Error performing handshake with %v: %v", conn.RemoteAddr(), err)
		return
	}

	addr := client.conn.RemoteAddr().String()
	log.Printf("%v connected\n", addr)
	s.mu.Lock()
	s.clients[addr] = client
	s.mu.Unlock()
	cSocket := make(chan []byte)
	cClose := make(chan bool)

	defer func() {
		s.mu.Lock()
		delete(s.clients, addr)
		s.mu.Unlock()
	}()

	go client.receiveMessages(cSocket, cClose)

	for {
		select {
		case msg := <-cSocket:
			s.mu.Lock()
			for key, cli := range s.clients {
				if key != addr {
					cli.ch <- msg
				}
			}
			s.mu.Unlock()

		case msg := <-client.ch:
			streamCipher := cipher.NewCTR(client.aesBlock, common.IV)
			streamCipher.XORKeyStream(msg, msg)
			err := common.WriteMessage(client.conn, msg)
			if err != nil {
				log.Printf("Could not write to %v: %v", addr, err)
				return
			}

		case _ = <-cClose:
			return
		}

	}
}

func (s *Server) performHandshake(conn net.Conn) (Client, error) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, common.RsaKeySize)
	privateKeyBytes := x509.MarshalPKCS1PublicKey(&privateKey.PublicKey)

	keyBlock := pem.Block{
		Type:  "RSA PUBLIC KEY",
		Bytes: privateKeyBytes,
	}

	keyBytes := pem.EncodeToMemory(&keyBlock)

	_, err := conn.Write(keyBytes)
	if err != nil {
		return Client{}, err
	}

	var encryptedSymmetricKey [512]byte
	n, err := conn.Read(encryptedSymmetricKey[:])
	if err != nil {
		return Client{}, err
	}
	if n == 0 {
		return Client{}, errors.New("unexpected EOF")
	}

	symmetricKey, err := rsa.DecryptOAEP(common.RsaHash, nil, privateKey, encryptedSymmetricKey[:], common.SymmetricKeyLabel)
	if err != nil {
		return Client{}, err
	}

	aesBlock, err := aes.NewCipher(symmetricKey[:])
	if err != nil {
		return Client{}, err
	}

	client := Client{
		conn:     conn,
		ch:       make(chan []byte),
		aesBlock: aesBlock,
	}

	return client, nil
}

func (client *Client) receiveMessages(cSocket chan []byte, cClose chan bool) {
	for {
		msg, err := common.ReadMessage(client.conn)
		if err != nil {
			log.Printf("Error receiving message from %v: %v\n", client.conn.RemoteAddr(), err)
			cClose <- false
		}

		streamCipher := cipher.NewCTR(client.aesBlock, common.IV)
		streamCipher.XORKeyStream(msg, msg)

		cSocket <- msg
	}
}
