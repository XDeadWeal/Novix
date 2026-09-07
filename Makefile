AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy
QEMU = qemu-system-x86_64

CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra -nostdlib -Iinclude -I.
LDFLAGS = -m elf_x86_64 -nostdlib -T boot/link.ld -no-pie

BUILD_DIR = build
BIN_DIR = bin
KERNEL_BIN = $(BIN_DIR)/novix.bin
BOOT_BIN = $(BUILD_DIR)/boot.bin
ISO_IMAGE = $(BIN_DIR)/novix.iso

# Source files
BOOT_SRC = boot/boot.asm
ENTRY_SRC = kernel/entry.asm
KERNEL_SRC = kernel/kernel.c

# Driver sources
DRIVERS_SRC = \
	drivers/vga/vga.c \
	drivers/keyboard/keyboard.c \
	drivers/serial/serial.c

# Memory sources
MEMORY_SRC = \
	kernel/memory/pmm.c \
	kernel/memory/vmm.c

# Process sources
PROCESS_SRC = kernel/process/scheduler.c

# Syscall sources
SYSCALL_SRC = kernel/syscall/syscall.c

# Library sources
LIB_SRC = \
	lib/stdio.c \
	lib/string.c \
	lib/stdlib.c

# All C sources
ALL_C_SRC = $(KERNEL_SRC) $(DRIVERS_SRC) $(MEMORY_SRC) $(PROCESS_SRC) $(SYSCALL_SRC) $(LIB_SRC)

# Object files
ENTRY_OBJ = $(BUILD_DIR)/entry.o
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

ALL_OBJS = $(ENTRY_OBJ) $(ALL_C_SRC:$(BUILD_DIR)/%.o)

all: $(KERNEL_BIN) $(ISO_IMAGE)

# Bootloader - compile as flat binary
$(BOOT_BIN): $(BOOT_SRC)
	mkdir -p $(@D)
	$(AS) -f bin -o $@ $<

# Entry point (assembly)
$(BUILD_DIR)/entry.o: $(ENTRY_SRC)
	mkdir -p $(@D)
	$(AS) -f elf64 -o $@ $<

# Universal rule for ALL C files
$(BUILD_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

# Link kernel ELF
$(BUILD_DIR)/kernel.elf: $(ALL_OBJS)
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -o $@ $(ALL_OBJS)

# Combine boot.bin + kernel.elf into final binary
$(KERNEL_BIN): $(BOOT_BIN) $(BUILD_DIR)/kernel.elf
	mkdir -p $(@D)
	cat $(BOOT_BIN) $(BUILD_DIR)/kernel.elf > $@
	$(OBJCOPY) -O binary $@ $@

# Create ISO
$(ISO_IMAGE): $(KERNEL_BIN)
	mkdir -p $(@D)
	genisoimage -R -b $(KERNEL_BIN) -no-emul-boot -boot-load-size 4 -o $@ $(BIN_DIR)/

# Run in QEMU
run: $(ISO_IMAGE)
	$(QEMU) -cdrom $< -m 512M -serial stdio -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean run
