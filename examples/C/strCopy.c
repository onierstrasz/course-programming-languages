
/*
	Copy string s1 to buffer s2:
*/
void strCopy(char s1[], char s2[])
{
	int i = 0;
	while (s1[i] != '\0') {		/* Assume s1 is NULL-terminated! */
		s2[i] = s1[i];			/* assume s2 is big enough! */
		i++;
	}
	s2[i] = '\0';
}

/*
	More idiomatically (!):
*/
void strCopy2(char *s1, char *s2)
{
	while (*s2++ = *s1++);		/* fails only when NULL is reached */
}


int main(void)
{
	char * s1 = "hello world!";
	char s2[20], s3[20];
	
	strCopy(s1, s2);
	strCopy2(s2, s3);
	puts(s1);
	puts(s2);
	puts(s3);
	
	return 0;
}
