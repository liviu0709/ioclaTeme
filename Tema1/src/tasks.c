#include "functional.h"
#include "tasks.h"
#include "tests.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void swap_int(void *ceva, void *altceva) {
	int *x = (int *)ceva;
	int *y = (int *)altceva;
	int aux = *x;
	*x = *y;
	*y = aux;
}

void copy_int(void **dst) {
	int *x = (int *)dst[0];
	int *y = (int *)dst[1];
	*y = *x;
}

void print_int(void *elem) {
	int *x = (int *)elem;
	printf("%d ", *x);
}

array_t reverse(array_t list) {
	array_t sol = aloc(NULL, list.len, list.elem_size);
	// for_each(print_int, list);
	// printf("----\n");
	for_each_multiple(copy_int, 2, list, sol);
	for (int i = 0 ; i < sol.len / 2 ; i++)
		swap_int(sol.data + i * sol.elem_size,
				 sol.data + (sol.len - i - 1) * sol.elem_size);
	// printf("----\n");
	// for_each(print_int, list);
	// printf("----\n");
	return sol;
}

void map_number_t(void *new, void **data) {
	int nr_cif_max_int = 10;
	int *re = (int *)data[0];
	int *virg = (int *)data[1];
	number_t *nr = (number_t *)new;
	nr->integer_part = *re;
	nr->fractional_part = *virg;
	nr->string = malloc(nr_cif_max_int * 2 + 2);
	snprintf(nr->string, nr_cif_max_int * 2 + 2, "%d.%d", *re, *virg);
	nr->string[strlen(nr->string)] = '\0';
	nr->string = realloc(nr->string, strlen(nr->string) + 1);
}

void destructor_number_t(void *x) {
	number_t *rip = (number_t *)x;
	free(rip->string);
}

array_t create_number_array(array_t integer_part, array_t fractional_part) {
	array_t sol = map_multiple(map_number_t, 2 * sizeof(int) + sizeof(char *),
							   destructor_number_t, 2, integer_part,
							   fractional_part);
	return sol;
}

array_t get_passing_students_names(array_t list) {
	(void)list;
	return (array_t){0};
}

array_t check_bigger_sum(array_t list_list, array_t int_list) {
	(void)list_list;
	(void)int_list;
	return (array_t){0};
}

array_t get_even_indexed_strings(array_t list) {
	(void)list;
	return (array_t){0};
}

array_t generate_square_matrix(int n) {
	(void)n;
	return (array_t){0};
}
