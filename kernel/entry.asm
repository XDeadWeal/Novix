BITS 64
section .text
global _start
_start:
    ; Debug: print K = kernel entry reached
    mov byte [0xB8008], 0x4B
    mov byte [0xB8009], 0x0F
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x90000
    extern kernel_main
    call kernel_main
    ; Debug: print R = kernel_main returned
    mov byte [0xB800A], 0x52
    mov byte [0xB800B], 0x0F
    cli
    hlt
    jmp $