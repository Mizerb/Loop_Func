all: cuda


openmp: 
	g++ Loop.c main.c -fopenmp -o b.o

cuda: Loop.o 
	g++ Loop.o link.o main.c -L /usr/local/cuda/lib64 -lcudart -lcuda -o b.o
	
Loop.o :
	nvcc -arch=sm_20 -dc Loop.cu
	nvcc -arch=sm_20 -dlink Loop.o -o link.o
	

clean: 
	rm -rf *.o *.out *.exe program
