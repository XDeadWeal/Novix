BITS 64
section .text
global _start
_start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x90000
    extern kernel_main
    call kernel_main
    cli
    hlt
    jmp $