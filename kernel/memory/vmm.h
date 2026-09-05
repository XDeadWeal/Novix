#ifndef VMM_H
#define VMM_H

#include <stdint.h>

#define VMM_PRESENT 0x01
#define VMM_WRITABLE 0x02
#define VMM_USER 0x04
#define VMM_PS 0x80

void vmm_init();
void vmm_map_page(uint64_t virt, uint64_t phys, uint64_t flags);
void vmm_unmap_page(uint64_t virt);

#endif