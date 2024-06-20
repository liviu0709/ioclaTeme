ASM = nasm
CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration -g
LDFLAGS = -m32 -no-pie -g

.PHONY: all clean

all: main

main: main.o todo.o file.o

main.o: main.c
	$(CC) $(CFLAGS) -g -c -o $@ $<

todo.o: todo.c
	$(CC) $(CFLAGS) -g -c -o $@ $<

file.o: file.asm
	$(ASM) -f  elf32 -g -o $@ $<

clean:
	-rm -f *~
	-rm -f file.o main.o todo.o main
