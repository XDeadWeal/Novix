#ifndef PMM_H
#define PMM_H

#include <stdint.h>

void pmm_init();
void* pmm_alloc_page();
void pmm_free_page(void* addr);
void* pmm_alloc_pages(uint32_t count);
void pmm_free_pages(void* addr, uint32_t count);

#endif