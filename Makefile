CROSS=aarch64-elf-
CC=$(CROSS)gcc
CFLAGS=-Wall -O -ffreestanding

HELLO_OBJS=crt0.o hello.o

all: hello.bin

hello.bin: hello.elf
	$(CROSS)objcopy -O binary $< $@

hello.elf: $(HELLO_OBJS) ram.ld
	$(CROSS)ld -o $@ $(HELLO_OBJS) -Tram.ld -Map hello.map

clean:
	rm -f $(HELLO_OBJS) *.bin *.elf *.map
