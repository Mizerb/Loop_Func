/*
 * Loop.h
 *
 *  Created on: Sep 24, 2015
 *      Author: ben
 */

#ifndef LOOP_H_
#define LOOP_H_

/*
typedef void (*loop_kernal)(void* , unsigned);
inline void loop_exec(loop_kernel kernel,
				void* arg, unsigned arg_bytes,
				unsigned n);
*/
inline void* loop_malloc( unsigned n);
extern "C" void loop_free( void *p);



#endif /* LOOP_H_ */
