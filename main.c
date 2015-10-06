#include <stdio.h>
#include "Loop.h"


void add( void* darg ,unsigned n, unsigned pos)
{
    struct arg *ARG = (arg *)darg;
	ARG->a[pos] = ARG->a[pos] + ARG->b[pos];

}

/*
int main()
{

	unsigned *a = (unsigned*)loop_malloc(2);
	GENDATA(a);
	unsigned *b = (unsigned*)loop_malloc(2);
	GENDATA(b);

	struct arg Temp;

	unsigned int c[] = {1,1};
	unsigned int d[] = {1,1};

	Temp.a = c;
	Temp.b = d;



	loop_exec( add, &Temp, 1, 2);


	printf("yes\n");

	printf("%d",Temp.a[0]);

	return 0;
}
*/


