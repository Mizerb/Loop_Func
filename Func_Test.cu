#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "Loop.h"
#include "mycuda.cuh"


#include <stdio.h>



#define LOOP_EXEC(func,arg, arg_bytes,n) loop_helper<<<ceildiv(n,256),256>>>(func, arg, arg_bytes)




class Runme {
public:
	__device__ void operator() ( void* INPUT, unsigned n ,unsigned size)
	{
		struct arg * The_Array = (struct arg*) INPUT;

		int ID = size;
		if(ID < 2){
			The_Array->c[ID] = The_Array->a[ID] + The_Array->b[ID];
		}
	}
};



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



	std::cout << "HERE" <<std::endl;
	//loop_exec( Runme() , arg_pass(a) , 2 , 2);
	LOOP_EXEC(Runme(), arg_pass(a), 2 ,2);

	std::cout<< "WHAT THE" << std::endl;

	cudaDeviceSynchronize();

	std::cout << a.a << std::endl;

	CUDACALL( cudaMemcpy(d , a.c , 2*sizeof(unsigned) , cudaMemcpyDeviceToHost));



	//printf( "%d , %d\n", d[0] , d[1]);

	std::cout<< d[0] << " , " << d[1] <<std::endl;

	return 0;

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

