
/*
	Reverse lines of a file.
	(c) 2002 oscar.nierstrasz@acm.org
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h> /* for fopen */
#include <sys/types.h> /* for stat */
#include <sys/stat.h>

void lrev(char*);

int main (int argc, char* argv[])
{
	int i;
	if (argc<1) {
		fprintf(stderr, "Usage: lrev <file> ...\n");
		exit(-1);
	}
	for (i=1;i<argc;i++) {
		lrev(argv[i]);
	}
	return 0;
}

/*
	return pointer to file contents or NULL (error code)
	set bytes to file size
*/
char* loadFile(char *path, int *bytes)
{
	FILE *input;
	struct stat fileStat;
	char *buf;

	*bytes = 0; /* default return val */
	if (stat(path, &fileStat) < 0) { /* POSIX std */
		fprintf(stderr, "Can't stat %s\n", path);
		return NULL;
	} else {
		*bytes = (int) fileStat.st_size;
		buf = (char*) malloc(sizeof(char) * ((*bytes)+1));
		if (buf == NULL) { /* if malloc fails */
			fprintf(stderr, "Can't malloc(%d)\n", *bytes);
			return NULL;
		}
		input = fopen(path, "r");
		if (input == NULL) {
			fprintf(stderr, "Can't open %s\n", path);
			free(buf);
			return NULL;
		} else {
			int n = fread(buf, sizeof(char), *bytes, input);
			if (n != *bytes) {
				fprintf(stderr, "Read only %d of %d bytes\n",
					n, *bytes);
			}
			buf[*bytes] = '\0'; /* terminate buffer */
			fclose(input);
		}
	}
	return buf;
}

/*
	print lines of arg file in reverse order
*/
void lrev(char *path)
{
	char *buf, *end;
	int bytes;

	buf = loadFile(path, &bytes);
	if (buf == NULL) {
		fprintf(stderr, "Can't reverse %s\n", path);
		return;
	}

	end = buf + bytes - 1; /* last byte of buffer */
	if ((*end == '\n') && (end >= buf)) {
		*end = '\0';
	} else {
		fprintf(stderr, "%s: missing final <cr>\n", path);
	}
	/* walk backwards, converting lines to strings */
	while (end >= buf) {
		while ((*end != '\n') && (end >= buf)) {
			end--;
		}
		if ((*end == '\n') && (end >= buf)) {
			*end = '\0';
		}
		puts(end+1);
	}
	free(buf);
}
