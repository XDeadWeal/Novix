#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <stdint.h>

void scheduler_init();
uint32_t scheduler_create_process(uint64_t entry, uint64_t stack, const char* name, uint8_t priority);
void scheduler_switch();
void scheduler_block_process(uint32_t pid);
void scheduler_unblock_process(uint32_t pid);

#endif