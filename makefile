all: boot_sect.bin kernel.o kernel.bin kernel_entry.o os-image

boot_sect.bin: boot_sect.asm
	nasm $< -f bin -o $@

kernel.o: kernel.c
	gcc -ffreestanding -fno-pie -c $^ -o $@

kernel.bin: kernel_entry.o kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary 

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

os-image: boot_sect.bin kernel.bin 
	cat $^ > $@

clean:
	rm *.bin *.o

run: os-image
	qemu-system-i386 -fda $<
