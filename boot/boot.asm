; Novix OS - Bootloader (16-bit Real Mode)
BITS 16
ORG 0x7C00

KERNEL_LOAD_ADDR equ 0x100000

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [boot_drive], dl
    mov si, boot_msg
    call print_string
    call load_kernel
    call enable_a20
    call check_long_mode
    jnc .no_long_mode
    call switch_to_long_mode
.no_long_mode:
    mov si, error_msg
    call print_string
    jmp $

print_string:
    pusha
    mov ah, 0x0E
.print_char:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .print_char
.done:
    popa
    ret

load_kernel:
    pusha
    mov si, loading_msg
    call print_string
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 64
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, [boot_drive]
    int 0x13
    jnc .load_success
    mov si, disk_error_msg
    call print_string
    jmp $
.load_success:
    mov si, loaded_msg
    call print_string
    popa
    ret

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

check_long_mode:
    pusha
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_long_mode
    stc
    jmp .done
.no_long_mode:
    clc
.done:
    popa
    ret

switch_to_long_mode:
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:.reload_cs
.reload_cs:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    mov eax, page_table_start
    mov cr3, eax
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    jmp 0x08:.reload_cs_64

BITS 64
.reload_cs_64:
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

boot_msg db "Novix Boot", 13, 10, 0
loading_msg db "Loading...", 13, 10, 0
loaded_msg db "Loaded!", 13, 10, 0
error_msg db "ERROR: No Long Mode!", 13, 10, 0
disk_error_msg db "Disk Error!", 13, 10, 0
boot_drive db 0

gdt_start:
    dq 0x0
    dw 0xFFFF, 0x0000, 0x00, 0x9A, 0xAF, 0x00
    dw 0xFFFF, 0x0000, 0x00, 0x92, 0xAF, 0x00
    dw 0xFFFF, 0x0000, 0x00, 0xFA, 0xAF, 0x00
    dw 0xFFFF, 0x0000, 0x00, 0xF2, 0xAF, 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dq gdt_start

section .bss
    resb 4096
page_table_start:
    resb 4096
    resb 4096
    resb 4096
    resb 4096

times 510-($-$$) db 0
dw 0xAA55