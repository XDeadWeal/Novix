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
    
    // Direct VGA output to bypass potential printf issues
    const char* banner1 = "
========================================
";
    const char* banner2 = "  Novix OS v0.1 - 64-bit Kernel
";
    const char* banner3 = "========================================

";
    const char* banner4 = "System initialized.
";
    const char* banner5 = "Memory: PMM & VMM ready
";
    const char* banner6 = "Scheduler: Ready
";
    const char* banner7 = "Syscalls: Ready
";
    const char* banner8 = "Serial: Ready

";
    const char* banner9 = "Type to test keyboard input.

> ";
    
    for (int i = 0; banner1[i]; i++) vga_put_char(banner1[i]);
    for (int i = 0; banner2[i]; i++) vga_put_char(banner2[i]);
    for (int i = 0; banner3[i]; i++) vga_put_char(banner3[i]);
    for (int i = 0; banner4[i]; i++) vga_put_char(banner4[i]);
    for (int i = 0; banner5[i]; i++) vga_put_char(banner5[i]);
    for (int i = 0; banner6[i]; i++) vga_put_char(banner6[i]);
    for (int i = 0; banner7[i]; i++) vga_put_char(banner7[i]);
    for (int i = 0; banner8[i]; i++) vga_put_char(banner8[i]);
    for (int i = 0; banner9[i]; i++) vga_put_char(banner9[i]);

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