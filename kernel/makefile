SOURCES = $(wildcard *.c)
HEAD = $(wildcard *.h)

OB = ${SOURCES:.c=.o}

all: kernel_entry/kernel_entry.o ${OB}

kernel_entry/kernel_entry.o: 
	$(MAKE) -C kernel_entry all

%.o: %.c ${HEAD}
	gcc -ffreestanding -fno-pie -c $< -o $@

