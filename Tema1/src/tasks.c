#include "functional.h"
#include "tasks.h"
#include "tests.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void print_int(void *elem) {
	// int *x = (int *)elem;
	printf("%d ", *(int *)elem);
}

void rotate(void *acc, void *elem) {
	array_t *acum = (array_t *)acc;
	if (acum->data) {
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

boolean are_nota_trecere(void *x) {
	student_t *stud = (student_t *)x;
	return stud->grade > 5.0;
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
	printf("Rip?: %s\n", *(char **)data);
}

array_t get_passing_students_names(array_t list) {
	array_t filtered = filter(are_nota_trecere, list);
	return map(stud_to_str, sizeof(char *), char_destructor, filtered);
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

typedef struct {
	int indice;
	array_t list;
} stringurile_vietii;

void copy_even_str(void *acc, void *elem) {
	stringurile_vietii *x = (stringurile_vietii *)acc;
	if (x->indice % 2 == 0) {
		x->list.len++;
		// printf("cica trb sa te adaug..\n");
		char *s = *(char **)elem;
		// printf("%s\n", s);
		if (!x->list.data)
			x->list.data = malloc(sizeof(char *));
		else
			x->list.data = realloc(x->list.data, sizeof(char *) * x->list.len);
		// Copiem strigu ca sa dam free la lista mai tarziu
		// Nu vrem sa modificam elementemete in reduce
		char *s_aloc = malloc(strlen(s) + 1);
		strcpy(s_aloc, s);
		memcpy(x->list.data + (x->list.len - 1) * sizeof(char *),
			   &s_aloc, sizeof(s_aloc));
	}
	x->indice = x->indice + 1;
}

array_t get_even_indexed_strings(array_t list) {
	//array_t nrIndex = aloc(NULL, list.len, sizeof(int));
	stringurile_vietii meh;
	meh.indice = 0;
	meh.list.data = NULL;
	meh.list.elem_size = sizeof(char *);
	meh.list.len = 0;
	meh.list.destructor = char_destructor;
	// for_each(print_str, list);
	reduce(copy_even_str, &meh, list);
	for_each(list.destructor, list);
	free(list.data);
	// printf("Numar stringuri:%d\n", list.len);
	// for_each(print_str, meh.list);
	// array_t filtrat = filter(conditie, list);
	return meh.list;
}

void gen_line(void *data, void *elem) {
	//printf("Ati ajuns la dst");
	int *x = (int *)elem;
	int *nr = (int *)data;
	*x = *nr;
	//printf("%d ", *x);
	*nr = *nr + 1;
}

void gen_data(void *acc, void *elem) {
	array_t *x = (array_t *)elem;
	int n = *(int *)acc;
	//printf("Len array: %d\n", x->len);
	//printf("N este: %d\n", n);
	reduce(gen_line, acc, *x);
	//printf("Linie not init:\n");
	//for_each(print_int, *x);
	//printf("\nAsta a fost o linie\n");
	*(int *)acc = n + 1;
}

void aloc_line(void *acc, void *elem) {
	array_t *line = (array_t *)elem;
    //*line = malloc(sizeof(array_t));
	(line)->data = malloc(sizeof(int) * *(int *)acc);
	(line)->len = *(int *)acc;
	(line)->elem_size = sizeof(int);
	(line)->destructor = NULL;
}

void print_len(void *elem) {
	array_t *x = (array_t *)elem;
	printf("Len: %d\n", x->len);
}

void destructor_list(void *elem) {
	array_t *x = (array_t *)elem;
	free(x->data);
}

void print_lst(void *elem) {
	array_t *x = (array_t *)elem;
	for_each(print_int, *x);
	printf("\n");
}

array_t generate_square_matrix(int n) {
	array_t matrix;
	matrix.data = malloc(n * sizeof(array_t));
	matrix.destructor = destructor_list;
	matrix.elem_size = sizeof(array_t);
	matrix.len = n;
	reduce(aloc_line, &n, matrix);
	n = 1;
	//for_each(print_len, matrix);
	reduce(gen_data, &n, matrix);
	//for_each(print_lst, matrix);
	return matrix;
}
