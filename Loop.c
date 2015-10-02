#include "Loop.h"

#include <stdio.h>

void loop_free( void *p)
{
	free(p);
}

void* loop_malloc( unsigned n)
{
	unsigned *i = malloc( sizeof(int) *n );
	return i;
}


