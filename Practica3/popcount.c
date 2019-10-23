// 9.- gcc popcount.c -o popcount -O / -Og -g

#include <stdio.h>		// para printf()
#include <stdlib.h>		// para exit()
#include <sys/time.h>		// para gettimeofday(), struct timeval

#ifndef TEST 
#define TEST 1
#endif

#define WSIZE 8*(sizeof(unsigned))
#if TEST==0
    #define SIZE (1<<20)
    unsigned lista[SIZE] ;
#endif
#if TEST==1
    #define SIZE 4
    unsigned lista[SIZE]={0x80000000, 0x00400000, 0x00000200, 0x00000001}; 
#endif
#if TEST==2
    #define SIZE 8
    unsigned lista[SIZE]={0x7fffffff, 0xffbfffff, 0xfffffdff, 0xfffffffe,0x01000023, 0x00456700, 0x8900ab00, 0x00cd00ef};
#endif
#if TEST==3
    #define SIZE 8
    unsigned lista[SIZE]={0x0, 0x01020408, 0x35906a0c,0x70b0d0e0, 0xffffffff, 0x12345678, 0x9abcdef0, 0xdeadbeef};
#endif


int resultado=0;

int popcount1(int* array, int len) {  
   int result = 0;
   for (int j = 0 ; j < len ; j++){ 
       int x = array[j] ;
    for (int i = 0 ; i < WSIZE ; i++){
        result += x & 0x1;     
        x >>= 1;
    }
   } 
    return result;
}

int popcount2(int* array, int len) {  
   int result = 0;
   int i;
   for (int j = 0 ; j < len ; j++){ 
       int x = array[j] ;
       i = 0 ;
    while (i < WSIZE)
    {
        result += x & 0x1;     
        x >>= 1;
        i++ ;
    }
   } 
    return result;
}

int popcount3(int* array, int len) {  
   int result = 0;
   for (int j = 0 ; j < len ; j++){ 
       int x = array[j] ;

       asm ("\n"
        "ini3:     \n\t"
        "     shr %[x]  \n\t"
        "     adc $0,%[r]   \n\t"
        "     test %[x],%[x]    \n\t"
        "     jne ini3  \n\t"
        : [r] "+r" (result)
        : [x] "r" (x)
        );
   } 
    return result;
}

int popcount4(int* array, int len) {  
   int result = 0;
   for (int j = 0 ; j < len ; j++){ 
       int x = array[j] ;

       asm ("\n"
       "     clc  \n\t"
        "ini4:     \n\t"
        "     adc $0,%[r]   \n\t"
        "     shr %[x]  \n\t"
        "     jnz ini4  \n\t"
        "     adc $0,%[r]   \n\t"
        : [r] "+r" (result)
        : [x] "r" (x)
        );
   } 
    return result;
}

int popcount5(int* array, int len) {  
   int val = 0, result = 0;
   int i;
   for (int j = 0 ; j < len ; j++){ 
       int x = array[j] ;
       for (int i = 0 ; i < 8 ; i++){
        val += x & 0x01010101L;     
        x >>= 1;
    }
    val += (val >>=16);
    val += (val >>=8) ;
    result += val & 0xFF ;
   } 
    return result;
}


void crono(int (*func)(), char* msg){
    struct timeval tv1,tv2; 			// gettimeofday() secs-usecs
    long           tv_usecs;			// y sus cuentas

    gettimeofday(&tv1,NULL);
    resultado = func(lista, SIZE);
    gettimeofday(&tv2,NULL);

    tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
             (tv2.tv_usec-tv1.tv_usec);

    #if TEST == 0
        printf(    "%ld" "\n",      tv_usecs); 
    #else
        printf("resultado = %d\t", resultado);
        printf("%s:%9ld us\n", msg, tv_usecs);
    #endif
}

int main()
{
    #if TEST==0
        int i;					// inicializar array
        for (i=0; i<SIZE; i++)			// se queda en cache
	     lista[i]=i;
    #endif

    crono(popcount1, "popcount1 (C, bucle for ) ");
    crono(popcount2, "popcount2 (C, bucle while ) ");
    crono(popcount3, "popcount3 (ASM, bucle while de 4 instrucciones ) ");
    crono(popcount4, "popcount4 (ASM, bucle while de 5 instrucciones ) ");
    crono(popcount5, "popcount5 (CS:APP, filtros 0101) ");
    exit(0);
}
