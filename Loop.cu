#include "Loop.h"
#include <stdio.h>
#include "mycuda.cuh"
#include <iostream>



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

typedef void (*loop_kernal_func)(void*,unsigned,unsigned) ;

__global__ void loop_helper( loop_kernal_func* f,
				void* arg, unsigned arg_bytes)
{
	 unsigned i = CUDAINDEX;

	 (*f)( arg , arg_bytes, i);

}



extern "C" void loop_exec( void (*loop_kernal)(void*,unsigned,unsigned),
				void* arg, unsigned arg_bytes,
				unsigned n)
{
	loop_kernal_func *h_f , *d_f;
	//this should be constant memory.
	h_f = (loop_kernal_func*)malloc(sizeof(loop_kernal_func));
	h_f[0] = loop_kernal;
	CUDACALL(cudaMalloc((void**)&d_f,sizeof(loop_kernal_func)));

	std::cout<< "Here1"<<std::endl;
	CUDACALL(cudaMemcpy( d_f , h_f , sizeof(loop_kernal_func) ,cudaMemcpyHostToDevice ));
	std::cout<< "Here2"<<std::endl;
	CUDALAUNCH( loop_helper , n , (d_f,arg, arg_bytes));
	std::cout<< "Here3"<<std::endl;
	//CUDALAUNCH( (*loop_kernal) , n , (arg, arg_bytes,-1));
	//not sure what else to put. I really would like to work in a class for this part
	// Going to have to talk it out via email... I guess
}








