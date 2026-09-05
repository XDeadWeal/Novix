#include <kernel/serial/serial.h>
#include <stdint.h>

#define SERIAL_PORT 0x3F8

void serial_init() {
    outb(SERIAL_PORT + 1, 0x00);
    outb(SERIAL_PORT + 3, 0x80);
    outb(SERIAL_PORT + 0, 0x01);
    outb(SERIAL_PORT + 1, 0x00);
    outb(SERIAL_PORT + 3, 0x03);
    outb(SERIAL_PORT + 2, 0xC7);
    outb(SERIAL_PORT + 4, 0x0B);
}

int serial_is_transmit_empty() {
    return inb(SERIAL_PORT + 5) & 0x20;
}

void serial_put_char(char c) {
    while (!serial_is_transmit_empty());
    outb(SERIAL_PORT, c);
}

char serial_get_char() {
    if (inb(SERIAL_PORT + 5) & 0x01) return inb(SERIAL_PORT);
    return 0;
}

void serial_put_string(const char* str) {
    while (*str) serial_put_char(*str++);
}

uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__ ("inb %%dx, %%al" : "=a"(ret) : "d"(port));
    return ret;
}

void outb(uint16_t port, uint8_t value) {
    __asm__ __volatile__ ("outb %%al, %%dx" : : "a"(value), "d"(port));
}