#include <kernel/vga.h>
#include <kernel/keyboard.h>
#include <lib/stdio.h>

void kernel_main() {
    vga_init();
    keyboard_init();
    
    vga_set_color(0x0F, 0x01);
    printf("\n========================================\n");
    printf("  Novix OS v0.1 - 64-bit Kernel\n");
    printf("========================================\n\n");
    
    vga_set_color(0x07, 0x00);
    printf("Type to test keyboard input.\n\n> ");
    
    while (1) {
        char c = keyboard_get_char();
        if (c != 0) {
            putchar(c);
            if (c == '\n') {
                printf("\n> ");
            }
        }
    }
}