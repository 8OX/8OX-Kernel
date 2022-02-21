; first need to specify the assembly origin so the  
ORG 0x7c00 ; ideally the origin should be 0
BITS 16 

; www.ctyme.com/intr/rb-0106.htm

; calling the bios to use ah to display a char 'A' using al

section .start:
    mov ah, 0eh 
    mov al, 'A'
    mov bx, 0
    int 0x10 ; calling the bios

    jmp $ ; infinite loop to stop code below from looping

times 510-($ - $$) db 0 ; fill remaining 500 bytes with 0s so our boot signature will in the correct spot
dw 0xAA55 ; little endian
