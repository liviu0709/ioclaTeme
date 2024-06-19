#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void joey(unsigned int a);
size_t chandler(unsigned int a, unsigned int b);
void ross(unsigned int a, unsigned int b, unsigned int *out, const unsigned char *msg);

// static unsigned const char message[30];

int main(void)
{
	unsigned int out[7];
  size_t ret;
	joey(2);
	ret = chandler(1362, -1100);
	printf("ret: %zu\n", ret);
	ross(2, 1, out, "Unagi is a state of awareness");

	return 0;
}
