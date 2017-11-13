	#PROGRAM: Hello, World!

	.data
	prompt1: .asciiz "\nEnter a string of up to 8 characters! 0-9, a-f, or A-F\n"
	errorPrompt: .asciiz "Invalid hexadecimal number.\n"	

	in_string: .space 20
	decimal: .space 1024
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

	
	la $t0, in_string

hextoDec:

	#look at a character
	lb $t1, 0($t0)


	li $t2, 0x30
	li $t3, 0x39

	andi $t2, $t2, 0x000000ff #makes into a word for comparison
	andi $t3, $t3, 0x000000ff

	bltu $t1, $t2, ERROR #error if lower than 0x30 (ascii) 
	bgt $t1, $t3, checkHex

	j isDigit

	



isDigit:

	#since character is between 0 and 9
	subu $t1, $t1, 0x30
	j finito


checkHex:

ERROR:

	li $v0, 4
	la $a0, errorPrompt
	syscall


finito:
	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	#output the new string
	li $v0, 4
	lb $a0, 1($t1)
	syscall

	li $v0, 10
	syscall