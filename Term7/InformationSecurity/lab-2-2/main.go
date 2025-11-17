package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"os"
)

var IvSource = []byte("47NpeJQkhyKOx8zcVur0PQljGgh1k927ThPSNIkvFJaZphiPO3ZXqpAfYsqUzj352eyOEYbZkaKNCFJObJcFwux8HALI4Lc44BaVHGaVVNAYtBFM39OvOsT26IuY6Sob")

type Flags struct {
	algorithm string
	key       string
}

func main() {
	if len(os.Args) == 1 {
		printUsage()
		os.Exit(0)
	}

	subcommand := os.Args[1]
	flags := Flags{}
	for i := 2; i < len(os.Args); i += 2 {
		if i+1 >= len(os.Args) {
			printUsage()
			os.Exit(64)
		}

		flag := os.Args[i]
		value := os.Args[i+1]

		switch flag {
		case "-a":
			fallthrough
		case "--alg":
			flags.algorithm = value

		case "-k":
			fallthrough
		case "--key":
			flags.key = value

		default:
			fmt.Printf("unknown flag %s\n", flag)
			os.Exit(64)
		}
	}

	switch subcommand {
	case "help":
		fallthrough
	case "--help":
		fallthrough
	case "-h":
		printUsage()
		os.Exit(0)
	case "encrypt":
		ciph, err := getCipher(flags.algorithm, flags.key)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		input, err := io.ReadAll(os.Stdin)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		ciph.XORKeyStream(input, input)

		encoder := base64.NewEncoder(base64.URLEncoding, os.Stdout)
		encoder.Write(input)

	case "decrypt":
		ciph, err := getCipher(flags.algorithm, flags.key)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		decoder := base64.NewDecoder(base64.URLEncoding, os.Stdin)
		input, err := io.ReadAll(decoder)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		ciph.XORKeyStream(input, input)

		fmt.Println(string(input))

	case "stats":
		break
	}
}

func printUsage() {
	fmt.Println("Usage: ./program <subcommand> [OPTIONS]")
	fmt.Println()
	fmt.Println("Subcommands:")
	fmt.Println("  help                   print this message")
	fmt.Println("  encrypt                encrypt input from stdin")
	fmt.Println("  decrypt                decrypt input from stdin")
	fmt.Println("  stats                  compute some statistics about cipher using input from stdin")
	fmt.Println()
	fmt.Println("Options:")
	fmt.Println("  -a, --alg <algorithm>  algorithm to use [aes|des|tdes]")
	fmt.Println("  -k, --key <key>        provide your own key")
}

func getCipher(name string, key string) (cipher.Stream, error) {
	var keyHash [32]byte
	if len(key) == 0 {
		rand.Read(keyHash[:])
	} else {
		keyHash = sha256.Sum256([]byte(key))
	}
	var block cipher.Block
	var iv []byte
	switch name {
	case "aes":
		aesBlock, err := aes.NewCipher(keyHash[:aes.BlockSize])
		if err != nil {
			return nil, err
		}
		block = aesBlock
		iv = IvSource[:aes.BlockSize]

	case "des":
		desBlock, err := des.NewCipher(keyHash[:des.BlockSize])
		if err != nil {
			return nil, err
		}
		block = desBlock
		iv = IvSource[:des.BlockSize]

	case "tdes":
		tdesBlock, err := des.NewTripleDESCipher(keyHash[:des.BlockSize])
		if err != nil {
			return nil, err
		}
		block = tdesBlock
		iv = IvSource[:des.BlockSize]

	default:
		return nil, errors.New("unknown algorithm")
	}

	stream := cipher.NewCTR(block, iv)

	return stream, nil
}
