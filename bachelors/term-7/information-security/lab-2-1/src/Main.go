package main

import (
	"fmt"
	"os"
	"strconv"
	"unicode"
)

var ALPHABET = []rune("АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ")

func main() {
	if len(os.Args) == 1 {
		printHelp()
		os.Exit(64)
	}

	subcommand := os.Args[1]
	if subcommand == "help" || subcommand == "--help" || subcommand == "-h" {
		printHelp()
		os.Exit(0)
	}

	if len(os.Args) != 4 {
		fmt.Println("Incorrect number of arguments")
		printHelp()
		os.Exit(64)
	}

	input := os.Args[2]
	key := os.Args[3]
	inputRunes := []rune(input)
	outputRunes := make([]rune, len(inputRunes))

	switch subcommand {
	case "replace":
		offset, err := strconv.ParseInt(key, 10, 32)
		if err != nil {
			fmt.Println("Replace key must be integer")
			os.Exit(64)
		}

		for i := range inputRunes {
			outputRunes[i] = replaceChar(inputRunes[i], int(offset))
		}

	case "permute":
		permutes := make([]int, len(key))
		for i, r := range key {
			if !unicode.IsDigit(r) {
				fmt.Println("Permute key must consist only of decimal digits")
				os.Exit(64)
			}

			permutes[i] = int(r) - '0'
		}

		blockSize := len(permutes)
		leftover := len(inputRunes) % blockSize
		if leftover != 0 {
			for ; leftover < blockSize; leftover += 1 {

				inputRunes = append(inputRunes, ' ')
				outputRunes = append(inputRunes, ' ')
			}
		}

		for i := 0; i < len(inputRunes); i += blockSize {
			for j := 0; j < blockSize; j += 1 {
				offset := permutes[j]
				outputRunes[i+offset] = inputRunes[i+j]
			}
		}

	case "gamming":
		gamma := []rune(key)
		gammaIndices := make([]int, len(gamma))
		for i := 0; i < len(gammaIndices); i += 1 {
			index, _ := alphabetIndex(gamma[i])
			gammaIndices[i] = index
		}

		for i := 0; i < len(inputRunes); i++ {
			gammaIndex := gammaIndices[rem(i, len(gammaIndices))]
			inputIndex, _ := alphabetIndex(inputRunes[i])
			if gammaIndex != -1 && inputIndex != -1 {
				newIndex := gammaIndex ^ inputIndex
				outputRunes[i] = ALPHABET[newIndex]
			} else {
				outputRunes[i] = inputRunes[i]
			}
		}

	default:
		fmt.Printf("Unknown cipher `%s`\n", subcommand)
		printHelp()
		os.Exit(64)
	}

	fmt.Println(string(outputRunes))
}

func printHelp() {
	fmt.Println("Usage: ./program <cipher> <input> <key>")
	fmt.Println("Possible ciphers:")
	fmt.Println("    - replace")
	fmt.Println("    - permute")
	fmt.Println("    - gamming")
}

func replaceChar(c rune, offset int) rune {
	index, ok := alphabetIndex(c)
	if !ok {
		return c
	}

	index = rem(index+offset, len(ALPHABET))
	return ALPHABET[index]
}

func alphabetIndex(c rune) (index int, ok bool) {
	for i, r := range ALPHABET {
		if r == c {
			return i, true
		}
	}

	return -1, false
}

func rem(a int, b int) int {
	rem := a % b
	if rem < 0 {
		rem += b
	}
	return rem
}
