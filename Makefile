AS = nasm
CC = gcc
OBJCOPY = objcopy
QEMU = qemu-system-x86_64

CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra -nostdlib -Iinclude -I.
LDFLAGS = -m64 -ffreestanding -nostdlib -T boot/link.ld

BUILD_DIR = build
BIN_DIR = bin
KERNEL_BIN = $(BIN_DIR)/novix.bin
BOOT_BIN = $(BUILD_DIR)/boot.bin
KERNEL_ELF = $(BUILD_DIR)/kernel.elf
KERNEL_RAW = $(BUILD_DIR)/kernel.bin

# C sources
C_SOURCES = \
	kernel/kernel.c \
	drivers/vga/vga.c \
	drivers/keyboard/keyboard.c \
	drivers/serial/serial.c \
	kernel/memory/pmm.c \
	kernel/memory/vmm.c \
	kernel/process/scheduler.c \
	kernel/syscall/syscall.c \
	lib/stdio.c \
	lib/string.c \
	lib/stdlib.c

C_OBJECTS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
ASM_OBJECTS = $(BUILD_DIR)/kernel/entry.o
KERNEL_OBJS = $(ASM_OBJECTS) $(C_OBJECTS)

all: $(KERNEL_BIN)

# Bootloader - flat binary
$(BOOT_BIN): boot/boot.asm
	mkdir -p $(@D)
	$(AS) -f bin -o $@ $<

# Entry point - win64 object (MinGW-compatible)
$(BUILD_DIR)/kernel/entry.o: kernel/entry.asm
	mkdir -p $(@D)
	$(AS) -f win64 -o $@ $<

# Generic pattern rule for all C files
$(BUILD_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

# Link kernel using gcc (MinGW ld only supports PE, not ELF)
$(KERNEL_ELF): $(KERNEL_OBJS) boot/link.ld
	mkdir -p $(@D)
	$(CC) $(LDFLAGS) -o $@ $(KERNEL_OBJS)

# Convert to raw binary
$(KERNEL_RAW): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

# Combine boot + kernel into final binary
$(KERNEL_BIN): $(BOOT_BIN) $(KERNEL_RAW)
	mkdir -p $(@D)
	cat $(BOOT_BIN) $(KERNEL_RAW) > $@

# Run in QEMU
run: $(KERNEL_BIN)
	$(QEMU) -drive format=raw,file=$(KERNEL_BIN) -m 512M -serial stdio -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean run