#include <kernel/memory/vmm.h>
#include <kernel/memory/pmm.h>
#include <stdint.h>

static uint64_t* pml4t = 0;

void vmm_init() {
    pml4t = (uint64_t*)pmm_alloc_page();
    memset(pml4t, 0, 0x1000);
    __asm__ __volatile__ ("mov %0, %%cr3" : : "r"(pml4t) : "memory");

    uint64_t* pdpt = (uint64_t*)pmm_alloc_page();
    memset(pdpt, 0, 0x1000);
    pml4t[0] = (uint64_t)pdpt | VMM_PRESENT | VMM_WRITABLE;

    uint64_t* pdt = (uint64_t*)pmm_alloc_page();
    memset(pdt, 0, 0x1000);
    pdpt[0] = (uint64_t)pdt | VMM_PRESENT | VMM_WRITABLE;

    pdt[0] = 0x00000000 | VMM_PRESENT | VMM_WRITABLE | VMM_PS;
    pdt[1] = 0x00200000 | VMM_PRESENT | VMM_WRITABLE | VMM_PS;
    pdt[2] = 0x00400000 | VMM_PRESENT | VMM_WRITABLE | VMM_PS;
    pdt[3] = 0x00600000 | VMM_PRESENT | VMM_WRITABLE | VMM_PS;
    pdt[4] = 0x00800000 | VMM_PRESENT | VMM_WRITABLE | VMM_PS;

    __asm__ __volatile__ ("mov %0, %%cr3" : : "r"(pml4t) : "memory");
}

void vmm_map_page(uint64_t virt, uint64_t phys, uint64_t flags) {
    uint32_t pml4_index = (virt >> 39) & 0x1FF;
    uint32_t pdpt_index = (virt >> 30) & 0x1FF;
    uint32_t pdt_index = (virt >> 21) & 0x1FF;
    uint32_t pt_index = (virt >> 12) & 0x1FF;

    if (!(pml4t[pml4_index] & VMM_PRESENT)) {
        uint64_t* new_pdpt = (uint64_t*)pmm_alloc_page();
        memset(new_pdpt, 0, 0x1000);
        pml4t[pml4_index] = (uint64_t)new_pdpt | VMM_PRESENT | VMM_WRITABLE;
    }

    uint64_t* pdpt = (uint64_t*)(pml4t[pml4_index] & ~0xFFF);
    if (!(pdpt[pdpt_index] & VMM_PRESENT)) {
        uint64_t* new_pdt = (uint64_t*)pmm_alloc_page();
        memset(new_pdt, 0, 0x1000);
        pdpt[pdpt_index] = (uint64_t)new_pdt | VMM_PRESENT | VMM_WRITABLE;
    }

    uint64_t* pdt = (uint64_t*)(pdpt[pdpt_index] & ~0xFFF);
    if (!(pdt[pdt_index] & VMM_PRESENT)) {
        uint64_t* new_pt = (uint64_t*)pmm_alloc_page();
        memset(new_pt, 0, 0x1000);
        pdt[pdt_index] = (uint64_t)new_pt | VMM_PRESENT | VMM_WRITABLE;
    }

    uint64_t* pt = (uint64_t*)(pdt[pdt_index] & ~0xFFF);
    pt[pt_index] = phys | flags;
    __asm__ __volatile__ ("invlpg (%0)" : : "r"(virt) : "memory");
}

void vmm_unmap_page(uint64_t virt) {
    uint32_t pml4_index = (virt >> 39) & 0x1FF;
    uint32_t pdpt_index = (virt >> 30) & 0x1FF;
    uint32_t pdt_index = (virt >> 21) & 0x1FF;
    uint32_t pt_index = (virt >> 12) & 0x1FF;

    uint64_t* pdpt = (uint64_t*)(pml4t[pml4_index] & ~0xFFF);
    uint64_t* pdt = (uint64_t*)(pdpt[pdpt_index] & ~0xFFF);
    uint64_t* pt = (uint64_t*)(pdt[pdt_index] & ~0xFFF);
    pt[pt_index] = 0;
    __asm__ __volatile__ ("invlpg (%0)" : : "r"(virt) : "memory");
}