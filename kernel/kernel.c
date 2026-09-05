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
    printf("\n========================================\n");
    printf("  Novix OS v0.1 - 64-bit Kernel\n");
    printf("========================================\n\n");

    vga_set_color(0x07, 0x00);
    printf("System initialized.\n");
    printf("Memory: PMM & VMM ready\n");
    printf("Scheduler: Ready\n");
    printf("Syscalls: Ready\n");
    printf("Serial: Ready\n\n");
    printf("Type to test keyboard input.\n\n> ");

    while (1) {
        char c = keyboard_get_char();
        if (c != 0) {
            putchar(c);
            if (c == 13) printf("\n> ");
        }
    }
}