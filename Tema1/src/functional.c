#include "functional.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>

array_t aloc(void (*destruct)(void *), int len, int size) {
	array_t list;
	list.destructor = destruct;
	list.elem_size = size;
	list.len = len;
	list.data = malloc(len * size);
	return list;
}

void dezaloc(array_t list) {
	if (list.destructor)
		for_each(list.destructor, list);
	free(list.data);
}

void for_each(void (*func)(void *), array_t list)
{
	for (int i = 0 ; i < list.len ; i++)
		func(list.data + i * list.elem_size);
}

array_t map(void (*func)(void *, void *),
			int new_list_elem_size,
			void (*new_list_destructor)(void *),
			array_t list)
{
	array_t new_list = aloc(new_list_destructor, list.len, new_list_elem_size);
	for (int i = 0 ; i < new_list.len ; i++) {
		func(new_list.data + i * new_list.elem_size,
			 list.data + i * list.elem_size);
		if (list.destructor)
			list.destructor(list.data + i * list.elem_size);
	}
	free(list.data);
	return new_list;
}

array_t filter(boolean(*func)(void *), array_t list)
{
	array_t new_list = aloc(list.destructor, 1, list.elem_size);
	int nr_elem = 0;
	for (int i = 0 ; i < list.len ; i++) {
		if (func(list.data + i * list.elem_size) == true) {
			nr_elem++;
			if (nr_elem > 1)
				new_list.data = realloc(new_list.data,
										list.elem_size * nr_elem);
			memcpy(new_list.data + new_list.elem_size * (nr_elem - 1),
				   list.data + i * list.elem_size, list.elem_size);
		}
		if (list.destructor)
			list.destructor(list.data + i * list.elem_size);
	}
	new_list.len = nr_elem;
	free(list.data);
	return new_list;
}

void *reduce(void (*func)(void *, void *), void *acc, array_t list)
{
	for (int i = 0 ; i < list.len ; i++)
		func(acc, list.data + i * list.elem_size);
	return acc;
}

void for_each_multiple(void(*func)(void **), int varg_c, ...)
{
	va_list liste_in;
	array_t *list = malloc(sizeof(array_t) * varg_c);
	int minim = -1;
	va_start(liste_in, varg_c);
	for (int i = 0 ; i < varg_c ; i++) {
		list[i] = va_arg(liste_in, array_t);
		if (minim == -1)
			minim = list[i].len;
		if (minim > list[i].len)
			minim = list[i].len;
	}
	va_end(liste_in);
	for (int i = 0 ; i < minim ; i++) {
		void **vector = malloc(sizeof(void *) * varg_c);
		for (int j = 0 ; j < varg_c ; j++)
			vector[j] = list[j].data + i * list[j].elem_size;
		func(vector);
		free(vector);
	}
	free(list);
}

array_t map_multiple(void (*func)(void *, void **),
					 int new_list_elem_size,
					 void (*new_list_destructor)(void *),
					 int varg_c, ...)
{
	va_list liste_in;
	array_t *list;
	if (varg_c > 0)
		list = (array_t *)malloc(sizeof(array_t) * varg_c);
	int minim = -1;
	va_start(liste_in, varg_c);
	for (int i = 0 ; i < varg_c ; i++) {
		list[i] = va_arg(liste_in, array_t);
		if (minim == -1)
			minim = list[i].len;
		if (minim > list[i].len)
			minim = list[i].len;
	}
	va_end(liste_in);
	array_t new_list = aloc(new_list_destructor, minim, new_list_elem_size);
	for (int i = 0 ; i < minim ; i++) {
		void **vector = malloc(sizeof(void *) * varg_c);
		for (int j = 0 ; j < varg_c ; j++)
			vector[j] = list[j].data + i * list[j].elem_size;
		func(new_list.data + i * new_list.elem_size, vector);
		free(vector);
	}
	for (int i = 0 ; i < varg_c ; i++)
		dezaloc(list[i]);
	free(list);
	return new_list;
}

void *reduce_multiple(void(*func)(void *, void **), void *acc, int varg_c, ...)
{
	(void)func;
	(void)acc;
	(void)varg_c;
	return NULL;
}
