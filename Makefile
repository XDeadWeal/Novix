AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy
QEMU = qemu-system-x86_64

CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra -nostdlib -Iinclude
LDFLAGS = -m elf_x86_64 -nostdlib -T boot/link.ld -no-pie

BUILD_DIR = build
BIN_DIR = bin
KERNEL_BIN = $(BIN_DIR)/novix.bin
ISO_IMAGE = $(BIN_DIR)/novix.iso

BOOT_SRC = boot/boot.asm
ENTRY_SRC = kernel/entry.asm
KERNEL_SRC = kernel/kernel.c

DRIVERS_SRC = \
	drivers/vga/vga.c \
	drivers/keyboard/keyboard.c \
	drivers/serial/serial.c

MEMORY_SRC = \
	kernel/memory/pmm.c \
	kernel/memory/vmm.c

PROCESS_SRC = kernel/process/scheduler.c
SYSCALL_SRC = kernel/syscall/syscall.c

LIB_SRC = \
	lib/stdio.c \
	lib/string.c \
	lib/stdlib.c

BOOT_BIN = $(BUILD_DIR)/boot.bin
ENTRY_OBJ = $(BUILD_DIR)/entry.o
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

DRIVER_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(DRIVERS_SRC))
MEMORY_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(MEMORY_SRC))
PROCESS_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(PROCESS_SRC))
SYSCALL_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(SYSCALL_SRC))
LIB_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(LIB_SRC))

KERNEL_OBJS = $(ENTRY_OBJ) $(KERNEL_OBJ) $(DRIVER_OBJS) $(MEMORY_OBJS) $(PROCESS_OBJS) $(SYSCALL_OBJS) $(LIB_OBJS)

all: $(KERNEL_BIN) $(ISO_IMAGE)

$(BUILD_DIR)/boot.bin: $(BOOT_SRC)
	mkdir -p $(@D)
	$(AS) -f bin -o $@ $<

$(BUILD_DIR)/entry.o: $(ENTRY_SRC)
	mkdir -p $(@D)
	$(AS) -f elf64 -o $@ $<

$(BUILD_DIR)/kernel.o: $(KERNEL_SRC)
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: drivers/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: kernel/memory/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: kernel/process/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: kernel/syscall/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: lib/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/kernel.elf: $(KERNEL_OBJS)
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_OBJS)

$(KERNEL_BIN): $(BOOT_BIN) $(BUILD_DIR)/kernel.elf
	mkdir -p $(@D)
	cat $< $(BUILD_DIR)/kernel.elf > $(BUILD_DIR)/kernel_temp.bin
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel_temp.bin $@

$(ISO_IMAGE): $(KERNEL_BIN)
	mkdir -p $(@D)
	genisoimage -R -b $(KERNEL_BIN) -no-emul-boot -boot-load-size 4 -o $@ $(BIN_DIR)/

run: $(ISO_IMAGE)
	$(QEMU) -cdrom $< -m 512M -serial stdio -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all clean run