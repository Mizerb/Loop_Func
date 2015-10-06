#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "Loop.h"
#include "mycuda.cuh"


#include <stdio.h>

__device__ void Run_Me( void* INPUT, unsigned  n , unsigned size)
{
	struct arg * The_Array = (struct arg*) INPUT;

	int ID = size;
	if(ID < 2){
	The_Array->c[ID] = The_Array->a[ID] + The_Array->b[ID];
	}
}



void Test( thrust::device_vector<int> &A , void(*f)(int*,int) )
{
	int * GG = thrust::raw_pointer_cast(&A[0]);

	std::cout<<"Stalling"<<std::endl;

	dim3 Block ( 4 ,  1);
	(*f)<<<Block,1>>>(GG, 4);

	std::cout<<"this is the silliest thing, I have every done"<<std::endl;
}

template <typename T>
void * arg_pass( T &a )
{
	T *i;	// So Nasty
	CUDACALL(cudaMalloc( (void**)&i, sizeof(T) ));
	CUDACALL( cudaMemcpy(i , &a , sizeof(T) , cudaMemcpyHostToDevice));
	return i;
}

template <typename T>
void * Something( T &a)
{
	cudaMemcpyToSymbol( &a , sizeof(T));
}


int main()
{
	cudaDeviceReset();

	struct arg a;
	a.a  = (unsigned int*)loop_malloc( 2);
	a.b  = (unsigned int*)loop_malloc( 2);
	a.c =  (unsigned int*)loop_malloc(2);

	std::cout << a.a << std::endl;

	unsigned int *d = new unsigned int[2];

	std::cout<< "ARG is" <<&a <<std::endl;

	GENDATA(a.a);
	GENDATA(a.b);



	loop_exec( Run_Me , arg_pass(a) , 2 , 2);

	cudaDeviceSynchronize();

	std::cout << a.a << std::endl;

	CUDACALL( cudaMemcpy(d , a.c , 2*sizeof(unsigned) , cudaMemcpyDeviceToHost));

	cudaDeviceReset();

	printf( "%d , %d\n", d[0] , d[1]);



	return 0;

}

