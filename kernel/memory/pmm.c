#include <kernel/memory/pmm.h>
#include <stdint.h>
#include <lib/string.h>

#define PMM_MAX_PAGES 0x10000
static uint8_t pmm_bitmap[PMM_MAX_PAGES / 8];

void pmm_init() {
    memset(pmm_bitmap, 0, sizeof(pmm_bitmap));
    for (uint32_t i = 0; i < 256; i++) pmm_set_bit(i);
}

void pmm_set_bit(uint32_t page) {
    pmm_bitmap[page / 8] |= (1 << (page % 8));
}

void pmm_clear_bit(uint32_t page) {
    pmm_bitmap[page / 8] &= ~(1 << (page % 8));
}

int pmm_test_bit(uint32_t page) {
    return pmm_bitmap[page / 8] & (1 << (page % 8));
}

void* pmm_alloc_page() {
    for (uint32_t i = 0; i < PMM_MAX_PAGES; i++) {
        if (!pmm_test_bit(i)) {
            pmm_set_bit(i);
            return (void*)(i * 0x1000);
        }
    }
    return 0;
}

void pmm_free_page(void* addr) {
    uint32_t page = (uint32_t)addr / 0x1000;
    pmm_clear_bit(page);
}

void* pmm_alloc_pages(uint32_t count) {
    uint32_t start = 0;
    uint32_t free_count = 0;
    for (uint32_t i = 0; i < PMM_MAX_PAGES; i++) {
        if (!pmm_test_bit(i)) {
            free_count++;
            if (free_count == count) {
                for (uint32_t j = 0; j < count; j++) pmm_set_bit(start + j);
                return (void*)(start * 0x1000);
            }
        } else {
            free_count = 0;
            start = i + 1;
        }
    }
    return 0;
}

void pmm_free_pages(void* addr, uint32_t count) {
    uint32_t start = (uint32_t)addr / 0x1000;
    for (uint32_t i = 0; i < count; i++) pmm_clear_bit(start + i);
}