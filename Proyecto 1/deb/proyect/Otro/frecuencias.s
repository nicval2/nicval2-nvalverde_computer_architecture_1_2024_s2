	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"frecuencias.c"
	.text
	.align	2
	.global	find_word
	.arch armv4t
	.syntax unified
	.arm
	.fpu softvfp
	.type	find_word, %function
find_word:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L5:
	ldr	r2, [fp, #-8]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #3
	mov	r2, r3
	ldr	r3, [fp, #-16]
	add	r3, r3, r2
	ldr	r1, [fp, #-24]
	mov	r0, r3
	bl	strcmp
	mov	r3, r0
	cmp	r3, #0
	bne	.L3
	ldr	r3, [fp, #-8]
	b	.L4
.L3:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-20]
	cmp	r2, r3
	blt	.L5
	mvn	r3, #0
.L4:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
	.size	find_word, .-find_word
	.align	2
	.global	compare
	.syntax unified
	.arm
	.fpu softvfp
	.type	compare, %function
compare:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r3, [fp, #-16]
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-20]
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-12]
	ldr	r2, [r3, #100]
	ldr	r3, [fp, #-8]
	ldr	r3, [r3, #100]
	sub	r3, r2, r3
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	compare, .-compare
	.section	.rodata
	.align	2
.LC0:
	.ascii	"r\000"
	.align	2
.LC1:
	.ascii	"text.txt\000"
	.align	2
.LC2:
	.ascii	"Error al abrir el archivo de entrada\000"
	.align	2
.LC3:
	.ascii	"\012\000"
	.align	2
.LC4:
	.ascii	"w\000"
	.align	2
.LC5:
	.ascii	"output.txt\000"
	.align	2
.LC6:
	.ascii	"Error al abrir el archivo de salida\000"
	.align	2
.LC7:
	.ascii	"%s: %d\012\000"
	.align	2
.LC8:
	.ascii	"Las 10 palabras m\303\241s frecuentes se han escrit"
	.ascii	"o en output.txt\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 1040128
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #1036288
	sub	sp, sp, #3840
	ldr	r1, .L18
	ldr	r0, .L18+4
	bl	fopen
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bne	.L9
	ldr	r0, .L18+8
	bl	perror
	mov	r3, #1
	b	.L17
.L9:
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L11
.L13:
	ldr	r3, .L18+12
	sub	r2, fp, #4
	add	r3, r2, r3
	ldr	r1, .L18+16
	mov	r0, r3
	bl	strcspn
	mov	r3, r0
	sub	r2, fp, #1036288
	sub	r2, r2, #4
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3, #-3836]
	ldr	r2, .L18+12
	sub	r3, fp, #4
	add	r2, r3, r2
	ldr	r3, .L18+20
	sub	r1, fp, #4
	add	r3, r1, r3
	ldr	r1, [fp, #-8]
	mov	r0, r3
	bl	find_word
	str	r0, [fp, #-28]
	ldr	r3, [fp, #-28]
	cmn	r3, #1
	beq	.L12
	sub	r3, fp, #1036288
	sub	r3, r3, #4
	mov	r1, r3
	ldr	r2, [fp, #-28]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r3, r1, r3
	sub	r3, r3, #3632
	sub	r3, r3, #4
	ldr	r3, [r3]
	add	r1, r3, #1
	sub	r3, fp, #1036288
	sub	r3, r3, #4
	mov	r0, r3
	ldr	r2, [fp, #-28]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r3, r0, r3
	sub	r3, r3, #3632
	sub	r3, r3, #4
	str	r1, [r3]
	b	.L11
.L12:
	ldr	r2, .L18+20
	sub	r3, fp, #4
	add	r2, r3, r2
	ldr	r1, [fp, #-8]
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r3, r1
	lsl	r3, r3, #3
	add	r2, r2, r3
	ldr	r3, .L18+12
	sub	r1, fp, #4
	add	r3, r1, r3
	mov	r1, r3
	mov	r0, r2
	bl	strcpy
	sub	r3, fp, #1036288
	sub	r3, r3, #4
	mov	r1, r3
	ldr	r2, [fp, #-8]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r3, r1, r3
	sub	r3, r3, #3632
	sub	r3, r3, #4
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L11:
	ldr	r3, .L18+12
	sub	r2, fp, #4
	add	r3, r2, r3
	ldr	r2, [fp, #-16]
	mov	r1, #100
	mov	r0, r3
	bl	fgets
	mov	r3, r0
	cmp	r3, #0
	bne	.L13
	ldr	r0, [fp, #-16]
	bl	fclose
	ldr	r1, [fp, #-8]
	ldr	r0, .L18+20
	sub	r3, fp, #4
	add	r0, r3, r0
	ldr	r3, .L18+24
	mov	r2, #104
	bl	qsort
	ldr	r1, .L18+28
	ldr	r0, .L18+32
	bl	fopen
	str	r0, [fp, #-20]
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L14
	ldr	r0, .L18+36
	bl	perror
	mov	r3, #1
	b	.L17
.L14:
	ldr	r3, [fp, #-8]
	cmp	r3, #10
	movlt	r3, r3
	movge	r3, #10
	str	r3, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L15
.L16:
	ldr	r2, .L18+20
	sub	r3, fp, #4
	add	r2, r3, r2
	ldr	r1, [fp, #-12]
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r3, r1
	lsl	r3, r3, #3
	add	r1, r2, r3
	sub	r3, fp, #1036288
	sub	r3, r3, #4
	mov	r0, r3
	ldr	r2, [fp, #-12]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r3, r0, r3
	sub	r3, r3, #3632
	sub	r3, r3, #4
	ldr	r3, [r3]
	mov	r2, r1
	ldr	r1, .L18+40
	ldr	r0, [fp, #-20]
	bl	fprintf
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L15:
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-24]
	cmp	r2, r3
	blt	.L16
	ldr	r0, [fp, #-20]
	bl	fclose
	ldr	r0, .L18+44
	bl	puts
	mov	r3, #0
.L17:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
.L19:
	.align	2
.L18:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	-1040124
	.word	.LC3
	.word	-1040024
	.word	compare
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.size	main, .-main
	.ident	"GCC: (15:9-2019-q4-0ubuntu1) 9.2.1 20191025 (release) [ARM/arm-9-branch revision 277599]"
