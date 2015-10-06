#include "Loop.h"
#include <stdio.h>
#include "mycuda.cuh"




extern "C" void loop_free(void *p)
{
	CUDACALL(cudaFree(p));
}

extern "C" void GENDATA( void *p){
	unsigned a[] = {1,1};

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
	(*loop_kernal)<<<ceildiv((n), BLOCK_SIZE),BLOCK_SIZE>>>(arg, arg_bytes , -1);
	//not sure what else to put. I really would like to work in a class for this part
	// Going to have to talk it out via email... I guess
}



__global__ void Run_Me( int* The_Array , int size)
{
	int ID = blockIdx.x;
	if(ID < 4)
	The_Array[ID] = The_Array[ID] * The_Array[ID];

}




