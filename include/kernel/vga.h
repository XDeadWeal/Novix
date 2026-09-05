#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VGA_COLOR_BLACK 0
#define VGA_COLOR_BLUE 1
#define VGA_COLOR_GREEN 2
#define VGA_COLOR_CYAN 3
#define VGA_COLOR_RED 4
#define VGA_COLOR_MAGENTA 5
#define VGA_COLOR_BROWN 6
#define VGA_COLOR_LIGHT_GRAY 7
#define VGA_COLOR_DARK_GRAY 8
#define VGA_COLOR_LIGHT_BLUE 9
#define VGA_COLOR_LIGHT_GREEN 10
#define VGA_COLOR_LIGHT_CYAN 11
#define VGA_COLOR_LIGHT_RED 12
#define VGA_COLOR_LIGHT_MAGENTA 13
#define VGA_COLOR_YELLOW 14
#define VGA_COLOR_WHITE 15

#define VGA_CTRL_REGISTER 0x3D4
#define VGA_DATA_REGISTER 0x3D5
#define VGA_MEMORY 0xB8000

struct vga_char {
    uint8_t character;
    uint8_t color;
} __attribute__((packed));

void vga_init();
void vga_set_color(uint8_t fg, uint8_t bg);
void vga_clear();
void vga_put_char(char c);
void vga_set_cursor(uint16_t position);

#endif