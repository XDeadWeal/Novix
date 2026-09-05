#include <lib/stdlib.h>

#define HEAP_SIZE 4096
static char heap[HEAP_SIZE];
static size_t heap_ptr = 0;

void* malloc(size_t size) {
    if (heap_ptr + size > HEAP_SIZE) return 0;
    void* ptr = &heap[heap_ptr];
    heap_ptr += size;
    return ptr;
}

void free(void* ptr) {
    heap_ptr = 0;
}

int atoi(const char* str) {
    int num = 0;
    int sign = 1;
    int i = 0;
    if (str[i] == '-') { sign = -1; i++; }
    while (str[i] >= '0' && str[i] <= '9') {
        num = num * 10 + (str[i] - '0');
        i++;
    }
    return sign * num;
}