.section .data

#ifndef TEST
#define TEST 9
#endif
    .macro linea
#if TEST==1
    .int 1,1,1,1
#elif TEST==2
    .int 0x0fffffff,0x0fffffff,0x0fffffff,0x0fffffff
#elif TEST==3
    .int 0x10000000,0x10000000,0x10000000,0x10000000
#elif TEST==4
    .int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
#elif TEST==5
    .int -1,-1,-1,-1
#elif TEST==6
    .int 200000000,200000000,200000000,200000000
#elif TEST==7
    .int 300000000,300000000,300000000,300000000
#elif TEST==8
    .int 5000000000,5000000000,5000000000,5000000000
#else
    .error "Definir TEST entre 1..8"
#endif
    .endm
lista: .irpc i,1234
                    linea
    .endr
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
#lista:		.int 0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000
longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.asciz	"suma = %lu = 0x%lx hex\n"

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
	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov %edx, resultado+4
	mov  %eax, resultado
	ret

suma:
    push %rdi
	mov  $0, %eax
	mov  $0, %edx
    mov  $0, %rdi
bucle:
	add  (%rbx,%rdi,4), %eax
    adc   $0, %edx
	inc   %rdi
	cmp   %rdi,%rcx
	jne    bucle
    pop    %rdi
	ret


imprim_C:			# requiere libC
	mov   $formato, %rdi
	mov   resultado, %rsi
	mov   resultado, %rdx
	mov   resultado+4, %ecx
	mov   resultado, %r8d
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);
	ret

acabar_C:			# requiere libC
	mov  resultado, %edi
	call _exit		# ==  exit(resultado)
	ret