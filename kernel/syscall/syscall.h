#ifndef SYSCALL_H
#define SYSCALL_H

#include <stdint.h>

#define SYSCALL_READ 0
#define SYSCALL_WRITE 1
#define SYSCALL_OPEN 2
#define SYSCALL_CLOSE 3
#define SYSCALL_EXIT 4
#define SYSCALL_MAX 64

typedef uint64_t (*syscall_handler_t)(uint64_t arg1, uint64_t arg2, uint64_t arg3);

void syscall_init();
void syscall_register(uint32_t num, syscall_handler_t handler);
uint64_t syscall_handle(uint32_t num, uint64_t arg1, uint64_t arg2, uint64_t arg3);

#endif