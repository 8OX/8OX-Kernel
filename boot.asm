; first need to specify the assembly origin so the  
ORG 0x7c00 ; ideally the origin should be 0
BITS 16 

start: 
    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb ; load the char that si holds and loads it into al and increments si
    cmp al, 0 
    je .done ; jumps to done when lodsb increments al to 0 
    call print_char
    jmp .loop ; makes sure we done reach done
.done:
    ret

print_char:
    mov ah, 0eh ; writes al to screen
    int 0x10 ; calling the bios
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0 ; fill remaining 500 bytes with 0s so our boot signature will in the correct spot
dw 0xAA55 ; little endian

; nasm -f bin boot.asm -o boot.bin
; qemu-system-x86_64 -hda boot.bin