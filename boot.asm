; first need to specify the assembly origin 
ORG 0
BITS 16 

_start:
    jmp short initalize     ; short jump to initalize
    ; BIOS parameter block (https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29)
    nop     ; no operation required for BIOs parameter block
    times 30 db 0 ; create 30 NULL bytes which adds to the 3 bytes from 'jump short initalize'

initalize:
    jmp 0x7c0:start     ; sets our code segment

start: 
    ; some BIOS tamper with the data if you boot from a USB
    ; manually sets the segment registers to override possible BIOS intialized segment registers
    cli     ; Clear interrupts, (disable them so hardware interrupts don't mess up this important code)
    mov ax, 0x7c0
    mov ds, ax      ; required to store 0x7c0 into ax to move it into these segments
    mov es, ax
    mov ax, 0x00
    mov ss, ax      ; setting the stack segment to be 0
    mov sp, 0x7c00  ; stack pointer to be 0x7c00
    sti     ; Enable interrupts

    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb   ; load the char that si holds and loads it into al and increments si
    cmp al, 0 
    je .done    ; jumps to done when lodsb increments al to 0 
    call print_char
    jmp .loop   ; makes sure we don't reach done prematurely
.done:
    ret

print_char:
    mov ah, 0eh     ; writes al to screen
    int 0x10    ; calling the bios
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0     ; fill remaining 500 bytes with 0s so our boot signature will in the correct spot
dw 0xAA55   ; little endian

; nasm -f bin boot.asm -o boot.bin
; qemu-system-x86_64 -hda boot.bin