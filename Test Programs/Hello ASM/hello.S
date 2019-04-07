	.section	.text
	.align 1
	.globl main
main:
	addi sp,sp,-16	#prepare space for callers frame pointer, and return address; riscv wants 16byte aligned stack
	sd   ra,8(sp)	#store return address
	sd   s0,0(sp)   #save pointer to old stack frame, serves as a good base for new stack
	addi s0,sp,16   #setup frame pointer for current stack, points to "top" of stack
	
	#compensate for gdb's inability to load registers before hand	
	lui	a0,%hi(print_t)		#lets get input using scanf this time
	addi	a0,a0,%lo(print_t)
	call	scanf
	
	#LETS DO I/O THE NASTY WAY FIRST
	li a0, 1		   #set up args for syscall, first a0 = stdout = 1
	lui a1, %hi(print_s3)
	addi a1, a1, %lo(print_s3) #instruction size too small so need to load string like this
	li a2, 24		   #string length
	li a3, 0		   #unused parameter for syscall
	li a7, 64		   #triggers sys_write
	ecall			   #trap it up yo
	
	#user input the nasty way
	li a0, 0		   #set up args for syscall, first a0 = stdin = 0
	lui a1, %hi(name_s)
	addi a1, a1, %lo(name_s)   #instruction size too small so need to load string like this
	li a2, 16		   #string length
	li a3, 0		   #unused parameter for syscall
	li a7, 63		   #triggers sys_read
	ecall			   #trap it up yo

	#LETS DO I/O THE "EASY" WAY
	lui	a0,%hi(print_s1)	#set output of printf
	addi	a0,a0,%lo(print_s1)
	call	printf
	
	lui	a0,%hi(print_t)		#lets setup printf to print our name
	addi	a0,a0,%lo(print_t)
	lui	a1,%hi(name_s)
	addi	a1,a1,%lo(name_s)
	call	printf
	
	lui	a0,%hi(print_s2)	#insted of printf lets use puts,it always gives a newline
	addi	a0,a0,%lo(print_s2)
	call	puts

	#lets prepare user for another input
	lui	a0,%hi(print_s4)
	addi	a0,a0,%lo(print_s4)
	call	puts

	lui	a0,%hi(print_t)		#lets get input using scanf this time
	addi	a0,a0,%lo(print_t)
	call	scanf

	li	t1, 5			#setup number of times to loop
loop:
	lui	a0,%hi(print_t)		#lets setup printf to print our name
	addi	a0,a0,%lo(print_t)
	lui	a1,%hi(name_s)
	addi	a1,a1,%lo(name_s)
	call	printf
	li	t3, 1
	sub	t1, t1, t3
	#addi	t1, t1, -1		#this line is interesting. ARM Compiler might optomize to subi if using -O3
	bne	zero, t1, loop		#keep looping if t1 is not 0

end:	
	li	a5,0			#setup return args in a0
	mv	a0,a5
	ld	ra,8(sp)		#reload return address and old frame pointer
	ld	s0,0(sp)
	addi	sp,sp,16		#roll back stack pointer
	jr	ra			#go back to kernel (i think risc-v pk uses _start and then calls exit
	

	
	#I probably don't need to be so explicit with align for every address	
	.section .rodata
	.align 3	#RISCV64 likes 8 byte alignment for data
print_t:
	.string "%s"
	
print_s1:
	.string "Hello "

print_s2:
	.string "Welcome to RISCV"
	
print_s3:
	.string "Please Enter Your Name: "

print_s4:
	.string "Enter Anytthing To See How Excited I Am!"

	.section .data
name_s:
	.string "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"	#please don't have a name longer than 16 letters lol
