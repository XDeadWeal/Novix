#ifndef IO_H
#define IO_H
#include <stdint.h>

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ __volatile__ ("inb %%dx, %%al" : "=a"(ret) : "d"(port));
    return ret;
}

static inline void outb(uint16_t port, uint8_t value) {
    __asm__ __volatile__ ("outb %%al, %%dx" : : "a"(value), "d"(port));
}

#endif
