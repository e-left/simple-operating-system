# Automatically generate lists of sources using wildcards .
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# Convert the *. c filenames to *. o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o}
# Defaul build target
all: os-image

run: all
	qemu-system-i386 -fda os-image
# This is the actual disk image that the computer loads
# which is the combination of our compiled bootsector and kernel
os-image: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > os-image
# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel

boot/boot_sect.bin: 
	$(MAKE) -C boot all

${OBJ}:
	$(MAKE) -C kernel all
	$(MAKE) -C drivers all

kernel/kernel_entry/kernel_entry.o:

	$(MAKE) -C kernel/kernel_entry all

kernel/kernel.bin: kernel/kernel_entry/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary


clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o kernel/kernel_entry/*.o kernel/*.bin boot/*.bin drivers/*.o

# Generic rule for compiling C code to an object file
# For simplicity , we C files depend on all header files .
#%.o: %.c ${HEADERS}
#	gcc -ffreestanding -fno-pie -c $^ -o $@
# Assemble the kernel_entry .
#%.o: %.asm
#	nasm $< -f elf -o $@
#%.bin: %.asm
#	nasm $< -f bin -o $@
