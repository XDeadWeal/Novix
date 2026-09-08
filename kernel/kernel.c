#include <kernel/vga.h>
#include <kernel/keyboard.h>
#include <kernel/serial/serial.h>
#include <kernel/memory/pmm.h>
#include <kernel/memory/vmm.h>
#include <kernel/process/scheduler.h>
#include <kernel/syscall/syscall.h>
#include <lib/stdio.h>

void kernel_main() {
    vga_init();
    keyboard_init();
    serial_init();
    pmm_init();
    vmm_init();
    scheduler_init();
    syscall_init();

    vga_set_color(0x0F, 0x01);
    
    /* Direct VGA output */
    const char banner[] = 
        "
"
        "========================================
"
        "  Novix OS v0.1 - 64-bit Kernel
"
        "========================================

"
        "System initialized.
"
        "Memory: PMM & VMM ready
"
        "Scheduler: Ready
"
        "Syscalls: Ready
"
        "Serial: Ready

"
        "> ";
    
    for (int i = 0; banner[i]; i++) {
        vga_put_char(banner[i]);
    }

    while (1) {
        char c = keyboard_get_char();
        if (c != 0) {
            vga_put_char(c);
            if (c == 13) {
                vga_put_char('\n');
                vga_put_char('>');
                vga_put_char(' ');
            }
        }
    }
}