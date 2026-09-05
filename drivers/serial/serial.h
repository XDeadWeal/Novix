#ifndef SERIAL_H
#define SERIAL_H

#include <stdint.h>

void serial_init();
void serial_put_char(char c);
char serial_get_char();
void serial_put_string(const char* str);

#endif