#include "Loop.h"
#include <stdio.h>
#include "mycuda.cuh"




extern "C" void loop_free(void *p)
{
	CUDACALL(cudaFree(p));
}

extern "C" void GENDATA( void *p){
	unsigned a[2] = {1,1};

	CUDACALL( cudaMemcpy(p , a , 2*sizeof(unsigned) , cudaMemcpyHostToDevice));
}


extern "C" void* loop_malloc( unsigned n )
{
	unsigned *i;
	CUDACALL(cudaMalloc( (void**)&i, sizeof(int) * n));
	return i;
}

extern "C" void loop_exec( void (*loop_kernal)(void*,unsigned,unsigned),
				void* arg, unsigned arg_bytes,
				unsigned n)
{
	//(*loop_kernal)<<<2,1>>>(arg, arg_bytes , -1);
	CUDALAUNCH( (*loop_kernal) , n , (arg, arg_bytes, -1));
	//not sure what else to put. I really would like to work in a class for this part
	// Going to have to talk it out via email... I guess
}








