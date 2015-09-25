#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "Loop.h"



#include <stdio.h>

__global__ void Run_Me( int* The_Array , int size)
{
	int ID = blockIdx.x;
	if(ID < 4)
	The_Array[ID] = The_Array[ID] * The_Array[ID];

}



void Test( thrust::device_vector<int> &A , void(*f)(int*,int) )
{
	int * GG = thrust::raw_pointer_cast(&A[0]);

	std::cout<<"Stalling"<<std::endl;

	dim3 Block ( 4 ,  1);
	(*f)<<<Block,1>>>(GG, 4);

	std::cout<<"this is the silliest thing, I have every done"<<std::endl;
}


/*
int main()
{
	thrust::host_vector<int> C(4);

	C[0] = 1;
	C[1] = 2;
	C[2] = 3;
	C[3] = 4;

	/*
	std::cout<<"RUnning"<<std::endl;
	thrust::device_vector<int> A = C;

	Test(A, Run_Me);

	for(int i = 0 ; i< 4 ;i++)
	{
		std::cout << A[i] <<std::endl;
	}
	char wait;

	int *x; int a = 0;
	x = &a;

	loop_free( x);
	int wait;
	std::cin >> wait;

}
*/
