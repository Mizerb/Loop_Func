/*
 * Loop.h
 *
 *  Created on: Sep 24, 2015
 *      Author: ben
 */

#ifndef LOOP_H_
#define LOOP_H_

//void(*f)(int*,int) CUDA DON"T LIKE
typedef void (*loop_kernal)(void* , unsigned);
extern "C" void loop_exec( void (*loop_kernal)(void*,unsigned),
				void* arg, unsigned arg_bytes,
				unsigned n);

extern "C" void* loop_malloc( unsigned n);
extern "C" void loop_free( void *p);



#endif /* LOOP_H_ */
