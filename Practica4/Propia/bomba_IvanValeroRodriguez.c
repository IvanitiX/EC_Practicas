// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

#include <stdio.h>	// para printf(), fgets(), scanf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 5

char password[]= "qwned!\n";	// contraseña
int  passcode  = 8422 ;			// pin

void desactivada(void){
	printf(	"\n"
		"***************\n"
		"*** BOOM!!! ***\n"
		"***************\n"
		"\n");
	exit(-1);
}

void explotar(void){
	printf(	"\n"
		"·························\n"
		"··· bomba desactivada ···\n"
		"·························\n"
		"\n");
	exit(0);
}

char codificarPass (char p){
	p = (char)((int)p + 1);
	return p ;
}


int codificarPin(int code) {
	return code + 1 ;
}


int main(){
	char pw[SIZE];
	int  pc, n;
	//Esto solo vale para despistar.
        char contrasena[] = "admin" ; //Esta es falsa. No tiene conexion con nada
        int codigo = 1234 ; // Este pin es falso. No tiene conexion con nada

	contrasena[0] = codificarPass('F') ;
	codigo += 10 ;
	//Vale, basta de despiste.

	char p1 = contrasena[0] ;
	contrasena[0] = codificarPass(p1) ;
	codigo = codificarPin(codigo) ;

	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1,NULL);

	do	printf("\nIntroduce la contraseña: ");
	while (	fgets(pw, SIZE, stdin) == NULL );
	char p2 = pw[0] ;
	pw[0] = codificarPass(p2) ;
	if    (	strncmp(pw,password,sizeof(password)) )
	    desactivada();

	gettimeofday(&tv2,NULL);
	if    ( tv2.tv_sec - tv1.tv_sec > TLIM )
	    desactivada();

	do  {	printf("\nIntroduce el pin: ");
	 if ((n=scanf("%i",&pc))==0)
		scanf("%*s")    ==1;         }
	while (	n!=1 );
        pc = codificarPin(pc);
	if    (	pc != passcode )
	    desactivada();

	gettimeofday(&tv1,NULL);
	if    ( tv1.tv_sec - tv2.tv_sec > TLIM )
	    desactivada();

	explotar();
}
