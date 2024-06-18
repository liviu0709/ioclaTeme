#include <stdio.h>
#include <stdlib.h>

void todo_a(void);
void todo_b(void);
void todo_c(void);

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "Please run ./main {a|b|c}\n");
		return -1;
	}
	switch(argv[1][0]) {
		case 'a':
			todo_a();
			break;
		case 'b':
			todo_b();
			break;
		case 'c':
			todo_c();
			break;
		default:
			fprintf(stderr, "Please run ./main {a|b|c}\n");
			return -1;
	}

	return 0;
}