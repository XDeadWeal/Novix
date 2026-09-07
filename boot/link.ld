ENTRY(_start)

BASE_ADDRESS = 0x100000;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *entry.o(.text)
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rdata)
    }
    .data : {
        *(.data)
        *(.data.*)
    }
    .bss : {
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
    /DISCARD/ : {
        *(.pdata)
        *(.xdata)
        *(.comment)
        *(.note.*)
        *(.eh_frame)
        *(.eh_frame_hdr)
    }
    _end = .;
}