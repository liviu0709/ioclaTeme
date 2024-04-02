#include "functional.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>

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
	array_t new_list;
	new_list.len = list.len;
	new_list.destructor = new_list_destructor;
	new_list.elem_size = new_list_elem_size;
	new_list.data = malloc(new_list.elem_size * new_list.len);
	for (int i = 0 ; i < new_list.len ; i++) {
		func(new_list.data + i * new_list.elem_size,
		list.data + i * list.elem_size);
		if (list.destructor != NULL)
			list.destructor(list.data + i * list.elem_size);
	}
	free(list.data);
	return new_list;
}

array_t filter(boolean(*func)(void *), array_t list)
{
	array_t new_list;
	new_list.destructor = list.destructor;
	new_list.elem_size = list.elem_size;
	new_list.data = malloc(list.elem_size);
	int nrElem = 0;
	for (int i = 0 ; i < list.len ; i++) {
		if (func(list.data + i * list.elem_size) == true) {
			nrElem++;
			if (nrElem > 1)
				new_list.data = realloc(new_list.data, list.elem_size * nrElem);
			memcpy(new_list.data + new_list.elem_size * (nrElem - 1), list.data + i * list.elem_size, list.elem_size);
		}
		if (list.destructor != NULL)
			list.destructor(list.data + i * list.elem_size);
	}
	new_list.len = nrElem;
	// if ( nrElem < list.len )
		// free(new_list.data + new_list.elem_size * nrElem);
	free(list.data);
	return new_list;
}

void *reduce(void (*func)(void *, void *), void *acc, array_t list)
{
	(void)func;
	(void)acc;
	(void)list;
	return NULL;
}

void for_each_multiple(void(*func)(void **), int varg_c, ...)
{
	(void)func;
	(void)varg_c;
}

array_t map_multiple(void (*func)(void *, void **),
					 int new_list_elem_size,
					 void (*new_list_destructor)(void *),
					 int varg_c, ...)
{
	(void)func;
	(void)new_list_elem_size;
	(void)new_list_destructor;
	(void)varg_c;
	return (array_t){0};
}

void *reduce_multiple(void(*func)(void *, void **), void *acc, int varg_c, ...)
{
	(void)func;
	(void)acc;
	(void)varg_c;
	return NULL;
}
