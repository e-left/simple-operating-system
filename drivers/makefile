C_SOURCES = $(wildcard *.c)
HEADERS = $(wildcard *.h)

OB_RESULTS = ${C_SOURCES:.c=.o}

all: ${OB_RESULTS}


%.o : %.c ${HEADERS}
	gcc -ffreestanding -fno-pie -c $< -o $@

