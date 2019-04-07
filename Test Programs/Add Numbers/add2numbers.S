	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32 	#make room for argc, argv, int x, int y
	sd	s0,24(sp) 	#save stack frame pointer in s0
	addi	s0,sp,32	#point to top of stack now
	sw	zero,-20(s0)	#prepare 0 to use for x and y
	lw	a5,-20(s0)	#set x = 0
	addiw	a5,a5,1		#set x = x + 1
	sw	a5,-20(s0)	#set new x in stack
	lw	a5,-20(s0)	#set x = 1
	addiw	a5,a5,1		#set x = x + 1
	sw	a5,-20(s0)	#set x = 2 in stack
	li	a5,0		#get ready to return 0
	mv	a0,a5		#put 0 in a0 to return according to ABI
	ld	s0,24(sp)	#load up previous stack frame
	addi	sp,sp,32	#reset stack pointer
	jr	ra		#return to callee
