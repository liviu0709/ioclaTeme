#include <stdio.h>
#include <stdlib.h>

#include "file.h"

/* TODO a: Find `compute` parameters so that calling `compute`
 * function will return 0.
 */
void todo_a()
{
	int res;

	res = compute(5, 0, 0);
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
	int n, i;
	int *vec;

	scanf("%d", &n);
	vec = malloc(n * sizeof(*vec));
	if (!vec) {
		fprintf(stderr, "todo_b() error allocating memory\n");
		return;
	}
    /*
    4
    1 1 1 3
    */
	for (i = 0; i < n; i++)
		scanf("%d", &vec[i]);

	res = check_array(vec, n);
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
