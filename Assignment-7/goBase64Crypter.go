package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"io"
	math "math/rand"
	"os"
	"time"
)

// Random Key Generator (128 bit)
var chars = []rune("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")

func randKeyGen(n int) string {
	charSet := make([]rune, n)
	for i := range charSet {
		charSet[i] = chars[math.Intn(len(chars))]
	}
	return string(charSet)
}

// Encrpyt: Original Text --> Add IV --> Encrypt with Key --> Base64 Encode
func Encrypt(key []byte, text []byte) string {
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}

	// Creating IV
	ciphertext := make([]byte, aes.BlockSize+len(text))
	iv := ciphertext[:aes.BlockSize]
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		panic(err)
	}

	// Encrpytion Process
	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(ciphertext[aes.BlockSize:], text)

	// Encode to Base64
	return base64.URLEncoding.EncodeToString(ciphertext)
}

// Decrypt: Encrypted Text --> Base64 Decode --> Decrypt with IV and Key
func Decrypt(key []byte, encryptedText string) string {
	ciphertext, _ := base64.URLEncoding.DecodeString(encryptedText)

	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}

	// Using IV
	iv := ciphertext[:aes.BlockSize]

	// Checking BlockSize = IV
	if len(iv) != aes.BlockSize {
		panic("[Error] Ciphertext is too short!")
	}

	ciphertext = ciphertext[aes.BlockSize:]

	// Decryption Process
	stream := cipher.NewCFBDecrypter(block, iv)
	stream.XORKeyStream(ciphertext, ciphertext)

	return string(ciphertext)
}

func main() {

	if len(os.Args) != 2 {
		fmt.Println("[INFO] Usage:", os.Args[0], "<Shellcode>")
		return
	}

	// Getting Original Shellcode as an Argument
	originalText := string(os.Args[1])
	fmt.Printf("[INFO] Original Text\t: %v\n", originalText)

	// Creating a Random Seed
	math.Seed(time.Now().UnixNano())

	// Generating a Random Key
	key := []byte(randKeyGen(32)) //Key Size: 16, 32
	fmt.Printf("[INFO] Random Key\t: %v\n", string(key))

	// Encrypt value to base64
	encryptedText := Encrypt(key, []byte(originalText))
	fmt.Printf("[INFO] Encrypted Base64\t: %v\n", encryptedText)

	// Decrypt base64 to original value
	text := Decrypt(key, encryptedText)
	fmt.Printf("[INFO] Decrypted Text\t: %v\n", text)
}
