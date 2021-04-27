global _start

section .text

_start:

	xor eax, eax    ; Zeroing out EAX
	mov al, 0x1     ; Moving 1 to A low in EAX = #define __NR_exit 1 in unistd_32.h --> void exit(int status);
	xor ebx, ebx    ; Zeroing out EBX ==> int status = 0x0
	int 0x80        ; Executing exit(0)