#include <kernel/keyboard.h>
#include <kernel/io.h>
#include <stdint.h>

static unsigned char shift_pressed = 0;

void keyboard_init() {}

char keyboard_get_char() {
    unsigned char status = inb(KEYBOARD_STATUS_PORT);
    if (!(status & 1)) return 0;
    unsigned char sc = inb(KEYBOARD_DATA_PORT);
    if (sc & 0x80) return 0;
    if (sc == 0x2A || sc == 0x36) { shift_pressed = 1; return 0; }
    if (sc == 0xAA || sc == 0xB6) { shift_pressed = 0; return 0; }
    if (sc >= 0x1E && sc <= 0x26) {
        char c = sc - 0x1E + 97;
        if (shift_pressed) c -= 32;
        return c;
    }
    if (sc >= 0x2C && sc <= 0x32) {
        char c = sc - 0x2C + 122;
        if (shift_pressed) c -= 32;
        return c;
    }
    return 0;
}
