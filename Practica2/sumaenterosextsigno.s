.section .data
#ifndef TEST
#define TEST 20
#endif
.macro linea
#if TEST==1
    .int -1,-1,-1,-1
#elif TEST==2
    .int 0x04000000,0x04000000,0x04000000,0x04000000
#elif TEST==3
    .int 0x08000000,0x08000000,0x08000000,0x08000000
#elif TEST==4
    .int 0x10000000,0x10000000,0x10000000,0x10000000
#elif TEST==5
    .int 0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF
#elif TEST==6
    .int 0x80000000,0x80000000,0x80000000,0x80000000
#elif TEST==7
    .int 0xF0000000,0xF0000000,0xF0000000,0xF0000000
#elif TEST==8
    .int 0xF8000000,0xF8000000,0xF8000000,0xF8000000
#elif TEST==9
    .int 0xF7FFFFFF,0xF7FFFFFF,0xF7FFFFFF,0xF7FFFFFF
#elif TEST==10
    .int 100000000,100000000,100000000,100000000
#elif TEST==11
    .int 200000000,200000000,200000000,200000000
#elif TEST==12
    .int 300000000,300000000,300000000,300000000
#elif TEST==13
    .int 2000000000,2000000000,2000000000,2000000000
#elif TEST==14
    .int 3000000000,3000000000,3000000000,3000000000
#elif TEST==15
    .int -100000000,-100000000,-100000000,-100000000
#elif TEST==16
    .int -200000000,-200000000,-200000000,-200000000
#elif TEST==17
    .int -300000000,-300000000,-300000000,-300000000
#elif TEST==18
    .int -2000000000,-2000000000,-2000000000,-2000000000
#elif TEST==19
    .int -3000000000,-3000000000,-3000000000,-3000000000
#else
    .error "Definir TEST entre 1..19"
#endif
.endm
lista: .irpc i,1234
        linea
.endr
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
#lista:      .int -1,-1,1,1
#lista:		.int 0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000
longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.asciz	"suma = %ld = 0x%lx hex\n"

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
    mov  $0, %ebp
    mov  $0, %esi
bucle:
	mov  (%rbx,%rdi,4), %eax
    cdq
    add   %eax, %ebp
    adc   %edx, %esi
    mov   %ebp, %eax
    mov   %esi, %edx
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