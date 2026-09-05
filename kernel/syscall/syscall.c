#include <kernel/syscall/syscall.h>
#include <kernel/vga.h>
#include <kernel/keyboard.h>

static syscall_handler_t syscall_handlers[SYSCALL_MAX];

void syscall_init() {
    for (int i = 0; i < SYSCALL_MAX; i++) syscall_handlers[i] = 0;
    syscall_register(SYSCALL_WRITE, syscall_write);
    syscall_register(SYSCALL_READ, syscall_read);
}

void syscall_register(uint32_t num, syscall_handler_t handler) {
    if (num < SYSCALL_MAX) syscall_handlers[num] = handler;
}

uint64_t syscall_handle(uint32_t num, uint64_t arg1, uint64_t arg2, uint64_t arg3) {
    if (num < SYSCALL_MAX && syscall_handlers[num]) {
        return syscall_handlers[num](arg1, arg2, arg3);
    }
    return -1;
}

uint64_t syscall_write(uint64_t fd, uint64_t buf, uint64_t count) {
    char* buffer = (char*)buf;
    for (uint64_t i = 0; i < count; i++) vga_put_char(buffer[i]);
    return count;
}

uint64_t syscall_read(uint64_t fd, uint64_t buf, uint64_t count) {
    char* buffer = (char*)buf;
    for (uint64_t i = 0; i < count; i++) {
        char c = keyboard_get_char();
        if (c == 0) break;
        buffer[i] = c;
    }
    return count;
}