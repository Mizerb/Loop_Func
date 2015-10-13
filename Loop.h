/*
 * Loop.h
 *
 *  Created on: Sep 24, 2015
 *      Author: ben
 */



#ifndef LOOP_H_
#define LOOP_H_
#include "mycuda.cuh"
//void(*f)(int*,int) CUDA DON"T LIKE

struct arg{
	unsigned int* a;
	unsigned int* b;
	unsigned int* c;
};


typedef void (*loop_kernal)(void* , unsigned, unsigned);
template<class O>
void loop_exec( O op,
				void* arg, unsigned arg_bytes,
				unsigned n);

void* loop_malloc( unsigned n);
void loop_free( void *p);

void GENDATA( void *p);

template<class O> __global__
void loop_helper( O op,
				void* arg, unsigned arg_bytes)
{
	 unsigned i = CUDAINDEX;

	 op( arg , arg_bytes, i);

}

#endif /* LOOP_H_ */
