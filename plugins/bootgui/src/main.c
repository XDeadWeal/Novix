/* BootGUI - Novix OS GUI Plugin */
#include <stdio.h>
#include <stdint.h>

#define VGA_WIDTH 1024
#define VGA_HEIGHT 768

volatile uint32_t *vga = (volatile uint32_t *)0xFD000000;

#define COLOR_BLUE 0x0000FF
#define COLOR_GRAY 0xC0C0C0
#define COLOR_TEAL 0x008080
#define COLOR_WHITE 0xFFFFFF
#define COLOR_DARK 0x808080

void draw_rect(int x, int y, int w, int h, uint32_t c) {
    for (int py = y; py < y+h && py < VGA_HEIGHT; py++)
        for (int px = x; px < x+w && px < VGA_WIDTH; px++)
            vga[py * VGA_WIDTH + px] = c;
}

int main() {
    printf("BootGUI starting...\n");
    draw_rect(0, 0, VGA_WIDTH, VGA_HEIGHT, COLOR_TEAL);
    draw_rect(0, VGA_HEIGHT-32, VGA_WIDTH, 32, COLOR_DARK);
    draw_rect(0, VGA_HEIGHT-32, 80, 32, COLOR_GRAY);
    while(1) {}
    return 0;
}
