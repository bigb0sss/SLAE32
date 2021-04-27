global _start

section .text

_start:
        xor eax, eax    ; Zeroing out EAX
        inc eax         ; Increase EAX by 0x1 = #define __NR_exit 1
        xor ebx, ebx    ; Zeroing out EBX ==> int status = 0x0
        int 0x80        ; Executing exit(0)