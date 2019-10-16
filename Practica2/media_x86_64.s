.section .data
#ifndef TEST
#define TEST 20
#endif
.macro linea
    #if TEST==1
.int 1,2,1,2
    #elif TEST==2
.int -1,-2,-1,-2
    #elif TEST==3
.int 0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF
    #elif TEST==4
.int 0x80000000,0x80000000,0x80000000,0x80000000
    #elif TEST==5
.int 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF
    #elif TEST==6
.int 2000000000,2000000000,2000000000,2000000000
    #elif TEST==7
.int 3000000000,3000000000,3000000000,3000000000
    #elif TEST==8
.int -2000000000,-2000000000,-2000000000,-2000000000
    #elif TEST==9
.int -3000000000,-3000000000,-3000000000,-3000000000
    #elif TEST>=10 && TEST<=14
.int 1,1,1,1
    #elif TEST>=15 && TEST<=19
.int -1,-1,-1,-1
#else
    .error "Definir TEST entre 1...19"
#endif
.endm

.macro linea0
#if TEST>=1 && TEST<=9
linea
#elif TEST==10
    .int 0,2,1,1
#elif TEST==11
    .int 1,2,1,1
#elif TEST==12
    .int 8,2,1,1
#elif TEST==13
    .int 15,2,1,1
#elif TEST==14
    .int 16,2,1,1
#elif TEST==15
    .int 0,-2,-1,-1
#elif TEST==16
    .int -1,-2,-1,-1
#elif TEST==17
    .int -8,-2,-1,-1
#elif TEST==18
    .int -15,-2,-1,-1
#elif TEST==19
    .int -16,-2,-1,-1
#else
    .error "Definir TEST entre 1..19"
#endif
.endm
        linea0
lista: .irpc i,123
        linea
.endr


#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
#lista:      .int -1,-1,-1,-1
#lista:		.int 0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000
longlista:	.quad   (.-lista)/4
cociente: .quad 0
resto: .quad 0
  formato: 	.asciz	" Media = %11d = 0x%16x hex\n Resto = %11d = 0x%16x hex\n"

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

.section .text
 main: .global  main

	call trabajar	# subrutina de usuario
	call imprim_C	# printf()  de libC
	call acabar_C	# exit()    de libC
	ret

trabajar:
	mov     $lista, %ebx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
    mov  %eax, cociente
	mov  %edx, resto
	ret

suma:
    push %rdi
	mov  $0, %rax
	mov  $0, %rdx
    mov  $0, %rdi
    mov  $0, %rsi
bucle:
	mov  (%rbx,%rdi,4), %rax
    cdqe
    cmp   $0, %rax
    jl    negativo
positivo: 
    add   %rax, %rsi
    mov   %rsi, %rax
    adc   $0, %rdx
    jmp   continuar
negativo:
    add   %rax, %rsi
    mov   %rsi, %rax
    adc   $-1, %rdx
continuar:
	inc   %rdi
	cmp   %rdi,%rcx
	jne    bucle
media:
    idiv   %rcx

    pop    %rdi
    ret

imprim_C:			# requiere libC
	mov   $formato, %rdi
	mov   cociente, %rsi
	mov   cociente, %rdx
	mov   resto, %rcx
	mov   resto, %r8d
	mov          $0,%rax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);
	ret

acabar_C:			# requiere libC
	mov  cociente, %rdi
	call _exit		# ==  exit(resultado)
	ret