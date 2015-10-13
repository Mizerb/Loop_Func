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

template<class O> __global__
void loop_helper( O op,
				void* arg, unsigned arg_bytes)
{
	 unsigned i = CUDAINDEX;

	 op( arg , arg_bytes, i);

}



template<class O>  void loop_exec( O op,
				void* arg, unsigned arg_bytes,
				unsigned n)
{
	loop_kernal_func *h_f , *d_f;
	//this should be constant memory.

	/*
	h_f = (loop_kernal_func*)malloc(sizeof(loop_kernal_func));
	h_f[0] = loop_kernal;
	CUDACALL(cudaMalloc((void**)&d_f,sizeof(loop_kernal_func)));

	//std::cout<< "Here1"<<std::endl;
	CUDACALL(cudaMemcpy( d_f , h_f , sizeof(loop_kernal_func) ,cudaMemcpyHostToDevice ));
	//std::cout<< "Here2"<<std::endl;
	*/




	CUDACALL(cudaMallocManaged(&h_f , sizeof(loop_kernal_func)));
	//h_f[0] = loop_kernal;


	//CUDALAUNCH( loop_helper , n , (h_f,arg, arg_bytes));

	loop_helper<<< ceildiv((n), 256), 256 >>>(O(),arg, arg_bytes);

	//std::cout<< "Here3"<<std::endl;

	//CUDALAUNCH( (*loop_kernal) , n , (arg, arg_bytes,-1));
	//not sure what else to put. I really would like to work in a class for this part
	// Going to have to talk it out via email... I guess
}








