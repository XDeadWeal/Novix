; Novix OS - Bootloader (16-bit -> 32-bit -> 64-bit)
BITS 16
ORG 0x7C00

start:
    cli
    cld
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [boot_drive], dl

    ; Load kernel from disk to 0x10000
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 64
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13

    ; Enable A20
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load GDT
    lgdt [gdt_desc]

    ; Enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:pm_entry

boot_drive db 0

align 8
gdt_start:
    dq 0
    dw 0xFFFF, 0x0000, 0x9A00, 0x00CF
    dw 0xFFFF, 0x0000, 0x9200, 0x00CF
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF
gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

BITS 32
pm_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    ; Copy kernel 0x10000 -> 0x100000
    mov esi, 0x10000
    mov edi, 0x100000
    mov ecx, 16384
    rep movsd

    ; Page tables: identity map first 2MB
    mov edi, 0x70000
    mov ecx, 1024
    xor eax, eax
    rep stosd
    mov edi, 0x71000
    mov ecx, 1024
    xor eax, eax
    rep stosd
    mov edi, 0x72000
    mov ecx, 1024
    xor eax, eax
    rep stosd
    mov dword [0x70000], 0x71003
    mov dword [0x71000], 0x72003
    mov dword [0x72000], 0x00000083

    mov eax, 0x70000
    mov cr3, eax
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x100
    wrmsr
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    jmp 0x18:long_mode

BITS 64
long_mode:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x90000
    jmp 0x100000

times 510-($-$$) db 0
dw 0xAA55
