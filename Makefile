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

all: $(KERNEL_BIN) $(ISO_IMAGE)

$(BUILD_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: %.asm
	mkdir -p $(@D)
	$(AS) -f elf64 -o $@ $<

$(KERNEL_BIN): boot/boot.asm kernel/entry.asm kernel/kernel.c
	mkdir -p $(@D)
	$(AS) -f elf64 -o $(BUILD_DIR)/boot.o boot/boot.asm
	$(AS) -f elf64 -o $(BUILD_DIR)/entry.o kernel/entry.asm
	$(CC) $(CFLAGS) -c -o $(BUILD_DIR)/kernel.o kernel/kernel.c
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/kernel.elf $(BUILD_DIR)/boot.o $(BUILD_DIR)/entry.o $(BUILD_DIR)/kernel.o
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel.elf $@

$(ISO_IMAGE): $(KERNEL_BIN)
	mkdir -p $(@D)
	genisoimage -R -b $(KERNEL_BIN) -no-emul-boot -boot-load-size 4 -o $@ $(BIN_DIR)/

run: $(ISO_IMAGE)
	$(QEMU) -cdrom $< -m 512M -serial stdio

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)