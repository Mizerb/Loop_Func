#include <stdio.h>
#include "Loop.h"




int main()
{
	int * a;
	int b = 5;
	a = &b;

	loop_free(a);

	printf("yes\n");
	return 0;
}
