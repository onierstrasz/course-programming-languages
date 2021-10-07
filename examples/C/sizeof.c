/*
	Check sizeof various things.
*/

#include <stdio.h>

int main(void)
{
	char ca[] = "abcd";
	char *cp = ca;
	char ch = 'a';
	int n = 0;
	int (*fp) (void);
	
	fp = &main;

	printf("sizeof(\"abcd\") = %d\n", sizeof("abcd"));
	printf("sizeof((char*)\"abcd\") = %d\n", sizeof((char*)"abcd"));
	printf("sizeof(cp) = %d\n", sizeof(cp));
	printf("sizeof(ca) = %d\n", sizeof(ca));

	printf("sizeof(ch) = %d\n", sizeof(ch));
	printf("sizeof(&ch) = %d\n", sizeof(&ch));

	printf("sizeof(n) = %d\n", sizeof(n));
	printf("sizeof((char)n) = %d\n", sizeof((char)n));
	printf("sizeof(&n) = %d\n", sizeof(&n));

	printf("sizeof(fp) = %d\n", sizeof(fp));
	printf("sizeof(main) = %d\n", sizeof(main)); /* ?! */
	printf("sizeof(&main) = %d\n", sizeof(&main));
	return 0;
}