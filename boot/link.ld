OUTPUT_FORMAT("elf64-x86-64")
OUTPUT_ARCH(amd64)
ENTRY(_start)

BASE_ADDRESS = 0x100000;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : { *(.text) *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
    .boot : { *(.boot) }
    _end = .;
}