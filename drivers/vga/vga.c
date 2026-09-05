#include <kernel/vga.h>
#include <stdint.h>

static uint8_t vga_color = 0x07;
static uint16_t vga_cursor_pos = 0;
static volatile struct vga_char* vga_buffer = (volatile struct vga_char*)VGA_MEMORY;

void vga_init() {
    vga_clear();
    vga_set_cursor(0);
}

void vga_set_color(uint8_t fg, uint8_t bg) {
    vga_color = (bg << 4) | (fg & 0x0F);
}

void vga_clear() {
    for (int i = 0; i < 80 * 25; i++) {
        vga_buffer[i].character = ' ';
        vga_buffer[i].color = vga_color;
    }
    vga_set_cursor(0);
}

void vga_put_char(char c) {
    uint16_t pos = vga_cursor_pos;
    switch (c) {
        case '\n': pos = (pos / 80 + 1) * 80; break;
        case '\r': pos = (pos / 80) * 80; break;
        case '\t':
            for (int i = 0; i < 4; i++) vga_put_char(' ');
            return;
        default:
            vga_buffer[pos].character = c;
            vga_buffer[pos].color = vga_color;
            pos++;
            break;
    }
    if (pos >= 80 * 25) {
        vga_clear();
        pos = 0;
    }
    vga_set_cursor(pos);
}

void vga_set_cursor(uint16_t position) {
    vga_cursor_pos = position;
    outb(VGA_CTRL_REGISTER, 0x0E);
    outb(VGA_DATA_REGISTER, (position >> 8) & 0xFF);
    outb(VGA_CTRL_REGISTER, 0x0F);
    outb(VGA_DATA_REGISTER, position & 0xFF);
}

void outb(uint16_t port, uint8_t value) {
    __asm__ __volatile__ ("outb %0, %1" : : "a"(value), "dN"(port));
}