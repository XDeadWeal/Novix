BITS 16
KERNEL_LOAD_SEGMENT equ 0x1000
start:
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
mov [boot_drive], dl
mov ax, KERNEL_LOAD_SEGMENT
mov es, ax
xor bx, bx
mov ah, 0x02
mov al, 64
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
mov dl, [boot_drive]
int 0x13
jnc .load_ok
jmp $
.load_ok:
in al, 0x92
or al, 2
out 0x92, al
jmp 0x0000:0x100000
boot_drive db 0
times 510-($-$$) db 0
dw 0xAA55