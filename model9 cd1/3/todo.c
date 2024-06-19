#include <stdio.h>
#include <stdlib.h>

#include "file.h"

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

/* TODO a: Find `compute` parameters so that calling `compute`
 * function will return 0.
 */
void todo_a()
{
	int res;
    // >4096
	res = compute(0xF00, 16846849);
	if (!res)
		printf("a) Perfect! Go on!\n");
	else
		printf("a) Wrong answer. Try again\n");
}


/* TODO b: Read `n` and `vec` from standard input so that
 * `check_array` function will return 0.
 */
void todo_b(void) {
	int res;
	int a[] = {11,11,11,11,11,11,11};
	int b[] = {121,121,121,121,121,121,121};
	res = check_arrays(a, ARRAY_SIZE(a), b, ARRAY_SIZE(b));
	if (!res)
		printf("b) Perfect! Go on!\n");
	else
		printf("b) Wrong answer. Try again!\n");
}


/* TODO c: Indirectly call `secret` function using `read_string` */
void todo_c()
{
	read_string();
}
