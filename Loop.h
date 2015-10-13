/*
 * Loop.h
 *
 *  Created on: Sep 24, 2015
 *      Author: ben
 */

#ifndef LOOP_H_
#define LOOP_H_

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

extern "C" void* loop_malloc( unsigned n);
extern "C" void loop_free( void *p);

extern "C" void GENDATA( void *p);
template<class O> __global__ void loop_helper( O op, void* arg, unsigned arg_bytes);


#endif /* LOOP_H_ */
