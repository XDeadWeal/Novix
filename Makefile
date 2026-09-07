AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy
QEMU = qemu-system-x86_64

CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra -nostdlib -Iinclude -I.
LDFLAGS = -m elf_x86_64 -nostdlib -T boot/link.ld

BUILD_DIR = build
BIN_DIR = bin
KERNEL_BIN = $(BIN_DIR)/novix.bin
BOOT_BIN = $(BUILD_DIR)/boot.bin

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

ENTRY_OBJ = $(BUILD_DIR)/entry.o
C_OBJECTS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
ALL_OBJS = $(ENTRY_OBJ) $(C_OBJECTS)

all: $(KERNEL_BIN)

$(BOOT_BIN): boot/boot.asm
	mkdir -p $(@D)
	$(AS) -f bin -o $@ $<

$(ENTRY_OBJ): kernel/entry.asm
	mkdir -p $(@D)
	$(AS) -f elf64 -o $@ $<

$(BUILD_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/kernel.elf: $(ALL_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(ALL_OBJS)

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.elf
	$(OBJCOPY) -O binary $< $@

$(KERNEL_BIN): $(BOOT_BIN) $(BUILD_DIR)/kernel.bin
	mkdir -p $(@D)
	cat $(BOOT_BIN) $(BUILD_DIR)/kernel.bin > $@

run: $(KERNEL_BIN)
	$(QEMU) -drive format=raw,file=$< -m 512M -serial stdio -no-reboot

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean run
