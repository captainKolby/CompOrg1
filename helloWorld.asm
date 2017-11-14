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


	beq $t1, 0, convert
	beq $t1, 10, convert

	slt $s0, $t1, 48 #check if less than 0
	sgt $s1, $t1, 57 #check if greater than 9

	beq $s0, 1, ERROR #Less than 1 means not hex
	beq $s1, 1, checkCHex #checks if the number is a-f or A-F


	#since character is between 0 and 9
	addi $t1, $t1, -30


	j incrementChar


#list of registers used for each index |0|1|2|3|4|5|6|7| is |$t3|$t4|$t5|$t6|$t7|$t8|$t9|$s2|


checkCHex:
	
	slt $s0, $t1, 65 #check if less than A
	sgt $s1, $t1, 70 #check if greater than F

	beq $s0, 1, ERROR #Not a hex digit
	beq $s1, 1, checkLHex #checks if the number is a-f

	addi $t1, $t1, -55

	j incrementChar


checkLHex:

	slt $s0, $t1, 97 #check if less than a
	sgt $s1, $t1, 102 #check if greater than f

	beq $s0, 1, ERROR #Not a hex digit
	beq $s1, 1, ERROR #not a hex digit

	addi $t1, $t1, -87
	j incrementChar

incrementChar:

	addi $t2, $t2, 1 #increments the counter, which is $t2
	beq $t2, 1, addReg1
	beq $t2, 2, addReg2
	beq $t2, 3, addReg3
	beq $t2, 4, addReg4
	beq $t2, 5, addReg5
	beq $t2, 6, addReg6
	beq $t2, 7, addReg7
	beq $t2, 8, addReg8
	addi $t0, $t0, 1 #moves up the address to a new character
	j hextoDec

addReg1:
	addi $t3, $t1
	j hextoDec

addReg2:
	addi $t4, $t1
	j hextoDec

addReg3:
	addi $t5, $t1
	j hextoDec

addReg4:
	addi $t6, $t1
	j hextoDec

addReg5:
	addi $t7, $t1
	j hextoDec

addReg6:
	addi $t8, $t1
	j hextoDec

addReg7:
	addi $t9, $t1
	j hextoDec

addReg8:
	addi $s2, $t1
	j hextoDec

ERROR:

	li $v0, 4
	la $a0, errorPrompt
	syscall

convert:
	beq $t2, 0, ERROR
	bgt $t2, 8, ERROR

	

endProc:
	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	#output the new string
	li $v0, 4
	la $a0, ($t0)
	syscall

	li $v0, 10
	syscall