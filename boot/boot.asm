; Novix OS - Bootloader (16-bit Real Mode)
BITS 16

KERNEL_LOAD_ADDR equ 0x100000

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [boot_drive], dl
