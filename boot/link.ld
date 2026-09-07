ENTRY(_start)

BASE_ADDRESS = 0x100000;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : { *(.text) *(.rodata) *(.rdata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
    _end = .;
}