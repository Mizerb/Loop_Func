#include "Loop.h"
#include <stdio.h>



extern "C" void loop_free(void *p)
{
	printf("Yes");
}
