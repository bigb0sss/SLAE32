global _start

section .text

_start:

	xor eax, eax			; Preparing Nulls in EAX register
	push eax			; Pushing the first Null DWORD
	
	; ////bin/bash (12 bytes) - "/" does not affect when running "/bin/bash" while being interpretated
	;
	; [Reverse order of ////bin/bash]
	; String length : 12
	; hsab : 68736162
	; /nib : 2f6e6962
	; //// : 2f2f2f2f
	
	push 0x68736162
	push 0x2f6e6962
	push 0x2f2f2f2f
	
	mov ebx, esp
	push eax
	mov edx, esp
	push ebx
	mov ecx, esp
	
	; syscall()
	mov al, 0xb
	int 0x80