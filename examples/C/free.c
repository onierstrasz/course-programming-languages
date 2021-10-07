/*
	What happens?
*/

int main(void)
{
	free((char*)1);
	free("hello");
	return 0;
}