#include <stdio.h>

extern char **environ;
int main(int argc, char* argv[]){
	char **p;
	int i = 0;
	for (p = environ; *p != NULL; p++) i += 1;
	printf("Number of environment variables: %d\n", i);
	printf("Number of arguments: %d\n", argc -1);
}
