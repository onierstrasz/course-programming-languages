/*
	Tell us where parts of memory are located.
	(c) 2002 oscar.nierstrasz@acm.org
*/

#include <stdio.h>

static int stat=0;

void dummy() { }

int main(void)
{
	int local=1;
	int *dynamic = (int*) malloc(sizeof(int));
	printf("Text is here: %u\n", (unsigned) dummy);
	printf("Static is here: %u\n", (unsigned) &stat);
	printf("Heap is here: %u\n", (unsigned) dynamic);
	printf("Stack is here: %u\n", (unsigned) &local);
}
