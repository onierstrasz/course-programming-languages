/*
	Demo function pointers.
	(c) 2002 oscar.nierstrasz@acm.org
*/

#include <stdio.h>

int ascii(char c)
{
	return((int) c);
}

void applyEach(char *s, int (*fptr) (char)) {
	char *cp;
	for (cp = s; *cp; cp++) {
		printf("%c -> %d\n", *cp, fptr(*cp));
	}
}

int main(int argc, char *argv[])
{
	int i;
	for (i=1;i<argc;i++) {
		applyEach(argv[i], ascii);
	}
	return 0;
}
