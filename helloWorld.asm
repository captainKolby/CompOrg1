	#PROGRAM: Hello, World!

	.data
	prompt1: .asciiz "\nEnter a string of up to 8 characters!\n"	

	in_string: .space 20

	endline: .asciiz "\n"

	.text
main:

	#prompt for a string
	li $v0, 4
	la $a0, prompt1
	syscall

	#read in the string
	li $v0, 8
	la $a0, in_string
	li $a1, 9
	syscall

	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	#output the new string
	li $v0, 4
	la $a0, in_string
	syscall

	li $v0, 10
	syscall