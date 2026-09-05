#include <kernel/process/scheduler.h>
#include <stdint.h>
#include <lib/string.h>

#define MAX_PROCESSES 64

struct process {
    uint64_t rsp;
    uint64_t rip;
    uint64_t cr3;
    uint8_t state;
    uint8_t priority;
    char name[32];
};

static struct process processes[MAX_PROCESSES];
static uint32_t process_count = 0;
static uint32_t current_process = 0;

void scheduler_init() {
    process_count = 0;
    current_process = 0;
    processes[0].rsp = 0;
    processes[0].rip = 0;
    processes[0].cr3 = 0;
    processes[0].state = 1;
    processes[0].priority = 0;
    strcpy(processes[0].name, "idle");
    process_count = 1;
}

uint32_t scheduler_create_process(uint64_t entry, uint64_t stack, const char* name, uint8_t priority) {
    if (process_count >= MAX_PROCESSES) return 0;
    uint32_t pid = process_count++;
    processes[pid].rsp = stack;
    processes[pid].rip = entry;
    processes[pid].cr3 = 0;
    processes[pid].state = 0;
    processes[pid].priority = priority;
    strcpy(processes[pid].name, name);
    return pid;
}

void scheduler_switch() {
    uint32_t next_process = (current_process + 1) % process_count;
    while (next_process != current_process) {
        if (processes[next_process].state == 0) break;
        next_process = (next_process + 1) % process_count;
    }
    if (next_process == current_process) return;
    current_process = next_process;
    processes[current_process].state = 1;
}

void scheduler_block_process(uint32_t pid) {
    if (pid < process_count) processes[pid].state = 2;
}

void scheduler_unblock_process(uint32_t pid) {
    if (pid < process_count) processes[pid].state = 0;
}