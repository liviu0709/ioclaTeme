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

void rotate(void *acc, void *elem) {
	array_t *acum = (array_t *)acc;
	if ( acum->data ) {
		int old_size = acum->len * acum->elem_size;
		void *aux = malloc(old_size);
		memcpy(aux, acum->data, old_size);
		acum->data = realloc(acum->data, acum->elem_size + old_size);
		memcpy(acum->data + acum->elem_size, aux, old_size);
		acum->len++;
		free(aux);
	} else {
		acum->data = malloc(acum->elem_size);
		acum->len = 1;
	}
	// Smth going on over here
	// *((int *)acum->data) = *(int *)elem;
	memcpy(acum->data, elem, sizeof(int));
}

array_t reverse(array_t list) {
	array_t sol;
	// for_each(print_int, list);
	// printf("----\n");
	sol.data = NULL;
	sol.elem_size = list.elem_size;
	reduce(rotate, (void *)&sol, list);
	sol.len = list.len;
	sol.destructor = list.destructor;
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
	return map_multiple(map_number_t, sizeof(student_t),
						destructor_number_t, 2, integer_part, fractional_part);
}

// void destructor_student(void *x) {
// 	student_t *rip = (student_t *)x;
// 	free(rip->name);
// }

boolean are_nota_trecere(void *x) {
	student_t *stud = (student_t *)x;
	return stud->grade > 5.0;
}

void print_stud(void *elem) {
	student_t *x = (student_t *)elem;
	printf("Nota:%s\n", x->name);
}

void char_destructor(void *elem) {
	free(*(char **)elem);
}

void stud_to_str(void *new, void *old) {
	student_t *old_data = (student_t *)old;
	//printf("Rip\n");
	char *data = malloc(sizeof(char) * (strlen(old_data->name) + 1));
	strcpy(data, old_data->name);
	//printf("Nume: %s\n", data);
	// Copy the pointer of the name...
	memcpy(new, &data, sizeof(data));
	//*(char **)new = data;
}

void print_str(void *data) {
	printf("Rip?: %s\n", *(char**)data);
}

array_t get_passing_students_names(array_t list) {
	// for_each(print_stud, list);
	array_t filtered = filter(are_nota_trecere, list);
	//for_each(print_stud, filtered);
	array_t sol = map(stud_to_str, sizeof(char*), char_destructor, filtered);
	//for_each(print_str, sol);
	return sol;
}

void adding_up(void *sum, void *elem) {
	int *s = (int *)sum;
	int *element = (int *)elem;
	*s = *s + *element;
	// printf("Suma este %d\n", *s);
}

void count(void *new, void *old) {
	array_t *list = (array_t *)old;
	//printf("Lista:\n");
	//for_each(print_int, *list);
	//printf("\n");
	int *x = (int *)new;
	*x = 0;
	reduce(adding_up, new, *list);
	//printf("Val new: %d\n", *(int *)new);
}

void map_sum(void *new, void **data) {
	int *sum_found = (int *)data[0];
	int *sum_expected = (int *)data[1];
	boolean *este_ok  = (boolean *)new;
	if (*sum_found >= *sum_expected)
		*este_ok = true;
	else
		*este_ok = false;
}

array_t check_bigger_sum(array_t list_list, array_t int_list) {
	array_t sums = map(count, sizeof(int), NULL, list_list);
	return map_multiple(map_sum, sizeof(boolean), NULL, 2, sums, int_list);
}

array_t get_even_indexed_strings(array_t list) {
	(void)list;
	return (array_t){0};
}

array_t generate_square_matrix(int n) {
	(void)n;
	return (array_t){0};
}
