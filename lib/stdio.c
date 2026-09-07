#include <lib/stdio.h>
#include <kernel/vga.h>
#include <stdarg.h>

void putchar(char c) {
    vga_put_char(c);
}

void puts(const char* str) {
    while (*str) putchar(*str++);
}

void printf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    while (*format) {
        if (*format == '%') {
            format++;
            switch (*format) {
                case 'c': putchar((char)va_arg(args, int)); break;
                case 's': puts(va_arg(args, const char*)); break;
                case 'd': {
                    int n = va_arg(args, int);
                    char buf[16];
                    int i = 0;
                    if (n < 0) { putchar('-'); n = -n; }
                    if (n == 0) { putchar('0'); break; }
                    while (n > 0) { buf[i++] = '0' + (n % 10); n /= 10; }
                    while (i > 0) putchar(buf[--i]);
                    break;
                }
                case 'x': {
                    unsigned int n = va_arg(args, unsigned int);
                    char buf[16];
                    int i = 0;
                    if (n == 0) { putchar('0'); break; }
                    while (n > 0) {
                        unsigned int d = n & 0xF;
                        buf[i++] = d < 10 ? '0' + d : 'A' + d - 10;
                        n >>= 4;
                    }
                    while (i > 0) putchar(buf[--i]);
                    break;
                }
                default: putchar('%'); putchar(*format); break;
            }
            format++;
        } else {
            putchar(*format++);
        }
    }
    va_end(args);
}