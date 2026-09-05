#ifndef STDLIB_H
#define STDLIB_H

#include <stdint.h>

void* malloc(size_t size);
void free(void* ptr);
int atoi(const char* str);

#endif