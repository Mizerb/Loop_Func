#include "Loop.h"
#include "omp.h"
#include <stdio.h>
#include <stdlib.h>

void loop_free( void *p)
{
	free(p);
}

void* loop_malloc( unsigned n)
{
	void *i = malloc( sizeof(int) * n );
	return i;
}


void loop_exec( void(*loop_kernal)(void* , unsigned, unsigned),
		void* arg, unsigned arg_bytes,
		unsigned n)
{
	#pragma omp parrallel shared( arg )
	{
		#pragma omp for
		for( unsigned i = 0 ; i<n ; i++)
		{
			(*loop_kernal)(arg, arg_bytes, i); //Problem of how do I know where I am???
		}
	}
}
