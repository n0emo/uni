package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/des"
	"crypto/rand"
	"crypto/rc4"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"math"
	"os"
	"strconv"
	"time"

	"github.com/resaec/go-rc5"
	"github.com/zmap/rc2"
)

var IvSource = []byte("47NpeJQkhyKOx8zcVur0PQljGgh1k927ThPSNIkvFJaZphiPO3ZXqpAfYsqUzj352eyOEYbZkaKNCFJObJcFwux8HALI4Lc44BaVHGaVVNAYtBFM39OvOsT26IuY6Sob")

type Flags struct {
	algorithm      string
	key            string
	printDecrypted bool
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

		case "-p":
			fallthrough
		case "--print-encrypted":
			var err error
			flags.printDecrypted, err = strconv.ParseBool(value)
			if err != nil {
				fmt.Printf("Invalid value for flag %s: %s: %v\n", flag, value, err)
				os.Exit(64)
			}

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

		inputEntropy := computeEntropy(input)
		beginTime := time.Now()
		ciph.XORKeyStream(input, input)
		execTime := time.Since(beginTime)
		outputEntropy := computeEntropy(input)

		fmt.Printf("Open text entropy:      %v\n", inputEntropy)
		fmt.Printf("Encrypted text entropy: %v\n", outputEntropy)
		fmt.Printf("Encryption time:        %v\n", execTime)
		if flags.printDecrypted {
			fmt.Printf("Encrypted text:         ")
			encoder := base64.NewEncoder(base64.URLEncoding, os.Stdout)
			encoder.Write(input)
			fmt.Println()
		}
	}
}

func printUsage() {
	fmt.Println("Usage: ./program <subcommand> [OPTIONS]")
	fmt.Println()
	fmt.Println("Subcommands:")
	fmt.Println("  help                             print this message")
	fmt.Println("  encrypt                          encrypt input from stdin")
	fmt.Println("  decrypt                          decrypt input from stdin")
	fmt.Println("  stats                            compute some statistics about cipher using input from stdin")
	fmt.Println()
	fmt.Println("Options:")
	fmt.Println("  -a, --alg <algorithm>            algorithm to use [aes|des|tdes]")
	fmt.Println("  -k, --key <key>                  provide your own key")
	fmt.Println("  -p, --print-encrypted <boolean>  when computing statd, print encrypted text?")
}

func getCipher(name string, key string) (cipher.Stream, error) {
	var keyHash [32]byte
	if len(key) == 0 {
		rand.Read(keyHash[:])
	} else {
		keyHash = sha256.Sum256([]byte(key))
	}

	var stream cipher.Stream
	switch name {

	case "aes":
		block, err := aes.NewCipher(keyHash[:aes.BlockSize])
		if err != nil {
			return nil, err
		}
		iv := IvSource[:aes.BlockSize]
		stream = cipher.NewCTR(block, iv)

	case "des":
		block, err := des.NewCipher(keyHash[:des.BlockSize])
		if err != nil {
			return nil, err
		}
		iv := IvSource[:des.BlockSize]
		stream = cipher.NewCTR(block, iv)

	case "tdes":
		block, err := des.NewTripleDESCipher(keyHash[:des.BlockSize*3])
		if err != nil {
			return nil, err
		}
		iv := IvSource[:des.BlockSize]
		stream = cipher.NewCTR(block, iv)

	case "rc2":
		block, err := rc2.NewCipher(keyHash[:])
		if err != nil {
			return nil, err
		}
		iv := IvSource[:block.BlockSize()]
		stream = cipher.NewCTR(block, iv)

	case "rc4":
		block, err := rc4.NewCipher(keyHash[:])
		if err != nil {
			return nil, err
		}
		stream = block

	case "rc5":
		block, err := rc5.NewCipher64(keyHash[:], 12)
		if err != nil {
			return nil, err
		}
		iv := IvSource[:block.BlockSize()]
		stream = cipher.NewCTR(block, iv)

	default:
		return nil, errors.New("unknown algorithm")
	}

	return stream, nil
}

func computeEntropy(bytes []byte) float64 {
	counts := [256]int{}
	for _, b := range bytes {
		counts[b] += 1
	}

	sum := float64(0)
	for i := range counts {
		p := float64(counts[i]) / float64(len(bytes))
		if p == 0 {
			continue
		}

		sum += p * math.Log2(p)
	}

	return -sum
}
