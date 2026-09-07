; Novix OS - Bootloader (16-bit -> 32-bit -> 64-bit)
BITS 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [boot_drive], dl

    ; Load kernel from disk to 0x10000 (segment 0x1000:0x0000)
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02        ; Read sectors function
    mov al, 64          ; 64 sectors = 32KB (enough for kernel)
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Start at sector 2
    mov dh, 0           ; Head 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    ; Debug: print '1' = disk read OK
    mov al, '1'
    mov ah, 0x0E
    int 0x10

    ; Enable A20 line via fast A20
    in al, 0x92
    or al, 2
    and al, 0xFE        ; Do not reset!
    out 0x92, al

    ; Debug: print '2' = A20 enabled
    mov al, '2'
    mov ah, 0x0E
    int 0x10

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enter protected mode
    mov eax, cr0
    or eax, 1           ; Set PE bit
    mov cr0, eax

    ; Debug: print '3' = PE enabled
    mov al, '3'
    mov ah, 0x0E
    int 0x10

    ; Far jump to 32-bit code segment (flush pipeline)
    jmp 0x08:protected_mode

disk_error:
    mov si, msg_err
.print:
    lodsb
    or al, al
    jz .halt
    mov ah, 0x0E
    int 0x10
    jmp .print
.halt:
    hlt
    jmp .halt

; ===== 32-bit Protected Mode =====
BITS 32
protected_mode:
    mov ax, 0x10        ; 32-bit data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    ; Debug: print '4' = in 32-bit mode
    mov byte [0xB8000], '4'
    mov byte [0xB8001], 0x0F

    ; Copy kernel from 0x10000 to 0x100000 (1MB)
    mov esi, 0x10000
    mov edi, 0x100000
    mov ecx, 16384      ; 64KB / 4 bytes
    rep movsd

    ; Debug: print '5' = kernel copied
    mov byte [0xB8002], '5'
    mov byte [0xB8003], 0x0F

    ; ===== Set up paging for long mode =====
    ; Identity map first 2MB using 2MB pages
    ; PML4 at 0x80000, PDPT at 0x81000, PD at 0x82000

    ; Clear page table memory (3 pages = 12KB)
    mov edi, 0x80000
    xor eax, eax
    mov ecx, 3072        ; 12KB / 4 bytes
    rep stosd

    ; PML4[0] -> PDPT at 0x81000
    mov dword [0x80000], 0x81000 | 3    ; Present + Writable

    ; PDPT[0] -> PD at 0x82000
    mov dword [0x81000], 0x82000 | 3    ; Present + Writable

    ; PD[0] -> 2MB page at physical 0 (identity map)
    mov dword [0x82000], 0x000000 | 0x83  ; Present + Writable + 2MB

    ; Load CR3
    mov eax, 0x80000
    mov cr3, eax

    ; Enable PAE (CR4.PAE = 1)
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax

    ; Enable long mode (EFER.LME = 1)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x100
    wrmsr

    ; Enable paging (CR0.PG = 1) - activates long mode
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    ; Debug: print '6' = paging enabled
    mov byte [0xB8004], '6'
    mov byte [0xB8005], 0x0F

    ; Far jump to 64-bit code segment
    jmp 0x18:long_mode

; ===== 64-bit Long Mode =====
BITS 64
long_mode:
    mov ax, 0x20        ; 64-bit data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x90000

    ; Debug: print '7' = in 64-bit mode
    mov byte [0xB8006], '7'
    mov byte [0xB8007], 0x0F

    ; Jump to kernel entry at 1MB
    jmp 0x100000

; ===== GDT =====
gdt:
    ; Null descriptor
    dq 0
    ; 32-bit code segment (selector 0x08)
    dw 0xFFFF, 0x0000
    db 0x00, 0x9A, 0xCF, 0x00
    ; 32-bit data segment (selector 0x10)
    dw 0xFFFF, 0x0000
    db 0x00, 0x92, 0xCF, 0x00
    ; 64-bit code segment (selector 0x18)
    dw 0x0000, 0x0000
    db 0x00, 0x9A, 0xAF, 0x00
    ; 64-bit data segment (selector 0x20)
    dw 0x0000, 0x0000
    db 0x00, 0x92, 0xCF, 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1
    dd gdt

; ===== Data =====
boot_drive db 0
msg_err db 'Disk error', 0

; Boot signature
times 510-($-$$) db 0
dw 0xAA55