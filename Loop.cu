#include "Loop.h"
#include <stdio.h>
#include "mycuda.cuh"




extern "C" void loop_free(void *p)
{
	CUDACALL(cudaFree(p));
}


extern "C" void* loop_malloc( unsigned n)
{
	unsigned *i;
	CUDACALL(cudaMalloc(&i, sizeof(int) * n));
	return i;
}

