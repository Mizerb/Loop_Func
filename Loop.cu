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

extern "C" void loop_exec( void (*loop_kernal)(void*,unsigned),
				void* arg, unsigned arg_bytes,
				unsigned n)
{
	dim3 Block ( 4 ,  1);


	(*loop_kernal)<<<n,BLOCK_SIZE>>>(arg, arg_bytes);



}
