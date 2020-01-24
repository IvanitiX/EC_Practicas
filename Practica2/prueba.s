 .section .data
  formato: 	.asciz	"suma = %ld = 0x%16x hex\n"
  resultado:	.quad   0

.section .text
 main: .global  main

	call trabajar	# subrutina de usuario
	call imprim_C	# printf()  de libC
	call acabar_C	# exit()    de libC
	ret

trabajar: xor %rcx,%rcx
          #mov $-1, %rcx
          #sar $3, %ecx
		  xor $0x0000, %rcx
          mov %rcx, %rax
          mov %rcx, resultado
          ret



imprim_C:			# requiere libC
	mov   $formato, %rdi
	mov   %rax, %rsi
	mov   %rax, %rdx
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);
	ret

acabar_C:			# requiere libC
	mov  resultado, %edi
	call _exit		# ==  exit(resultado)
	ret
