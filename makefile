CC = gcc
CFLAGS =  -Wall -Wextra -Wcast-qual -Wcast-align -Wstrict-aliasing -Wpointer-arith -Winit-self -Wshadow -Wswitch-enum -Wstrict-prototypes -Wmissing-prototypes -Wredundant-decls -Wfloat-equal -Wundef -Wvla -Wc++-compat -m64 -g -ggdb3

all: main.o wykres.o
	$(CC) $(CFLAGS) -o wykres main.o wykres.o `allegro-config --shared`

wykres.o: wykres.s
	nasm -f elf64 -o wykres.o wykres.s

main.o: main.c wykres.h
	$(CC) $(CFLAGS) -c -o main.o main.c

clean:
	rm -f *.o

