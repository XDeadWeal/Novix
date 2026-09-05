#include <lib/stdio.h>
#include <kernel/vga.h>

void putchar(char c) {
    vga_put_char(c);
}

void puts(const char* str) {
    while (*str) putchar(*str++);
}

void printf(const char* format, ...) {
    char* arg = (char*)&format + sizeof(format);
    while (*format) {
        if (*format == '%') {
            format++;
            switch (*format) {
                case 'c': putchar(*(char*)arg); arg += sizeof(char); break;
                case 's': puts(*(char**)arg); arg += sizeof(char*); break;
                default: putchar('%'); putchar(*format); break;
            }
            format++;
        } else {
            putchar(*format++);
        }
    }
}