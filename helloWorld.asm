	#AUTHOR Kolby Lacy

	.data
	eightDigitConv: .space 32

	errorPrompt: .asciiz "Invalid hexadecimal number."	

	in_string: .space 20
	
	endline: .asciiz "\n"

	.text
main:

	#read in the string
	li $v0, 8
	la $a0, in_string
	li $a1, 9
	syscall


	la $a0, in_string

hextoDec:

	#look at a character
	lb $t1, 0($a0)


	beq $t1, 0, convert	#if null, done
	beq $t1, 10, convert #if endline, done

	slt $s0, $t1, 48 #check if less than 0
	sgt $s1, $t1, 57 #check if greater than 9

	beq $s0, 1, ERROR #Less than 1 means not hex
	beq $s1, 1, checkCHex #checks if the number is a-f or A-F


	#since character is between 0 and 9
	addi $t0, $t1, -48


	j incrementChar


#list of registers used for each index |0|1|2|3|4|5|6|7| is |$t3|$t4|$t5|$t6|$t7|$t8|$t9|$s2|


checkCHex:
	
	slt $s0, $t1, 65 #check if less than A
	sgt $s1, $t1, 70 #check if greater than F

	beq $s0, 1, ERROR #Not a hex digit
	beq $s1, 1, checkLHex #checks if the number is a-f

	addi $t0, $t1, -55

	j incrementChar


checkLHex:

	slt $s0, $t1, 97 #check if less than a
	sgt $s1, $t1, 102 #check if greater than f

	beq $s0, 1, ERROR #Not a hex digit
	beq $s1, 1, ERROR #not a hex digit

	addi $t0, $t1, -87
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
	j hextoDec

addReg1:
	addiu $t3, $t0, 0 #adds first read digit to $t3
	addi $a0, $a0, 1 #moves up the address to a new character
	j hextoDec

addReg2:
	addi $t4, $t0, 0 #adds second read digit to $t4
	addi $a0, $a0, 1 
	j hextoDec

addReg3:
	addi $t5, $t0, 0 #adds third read digit to $t5
	addi $a0, $a0, 1  
	j hextoDec

addReg4:
	addi $t6, $t0, 0 #adds fourth read digit to $t6
	addi $a0, $a0, 1  
	j hextoDec

addReg5:
	addi $t7, $t0, 0 #adds fifth read digit to $t7
	addi $a0, $a0, 1  
	j hextoDec

addReg6:
	addi $t8, $t0, 0 #adds sixth read digit to $t8
	addi $a0, $a0, 1  
	j hextoDec

addReg7:
	addi $t9, $t0, 0 #adds seventh read digit to $t9
	addi $a0, $a0, 1  
	j hextoDec

addReg8:
	addi $s2, $t0,  0 #adds eighth read digit to $s2
	addi $a0, $a0, 1  
	j hextoDec

ERROR:	#prints the error message
	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	li $v0, 4
	la $a0, errorPrompt
	syscall

	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	li $v0, 10
	syscall
	

convert:
	beq $t2, 0, ERROR
	bgt $t2, 8, ERROR

	beq $t2, 1, oneDigit		#conversion for a one digit input string 
	beq $t2, 2, twoDigits		#conversion for a two digit input string 
	beq $t2, 3, threeDigits 	#conversion for a three digit input string 
	beq $t2, 4, fourDigits  	#conversion for a four digit input string 
	beq $t2, 5, fiveDigits  	#conversion for a five digit input string 
	beq $t2, 6, sixDigits   	#conversion for a six digit input string 
	beq $t2, 7, sevenDigits 	#conversion for a seven digit input string 
	beq $t2, 8, eightDigits 	#conversion for an eight digit input string 


#Compute the sums based on the number of digits input

oneDigit: #puts the sum of the digit in $s4
	addi $s4, $t3, 0	#$s4 will hold the sum
	j endProc

twoDigits: #num1*16^1 + num2*16^0
	addi $s5, $s5, 16
	multu $t3, $s5
	mflo $s4

	addu $s4, $s4, $t4
	j endProc

threeDigits: #num1*16^2 +... + num3*16^0
	li $s5, 256
	multu $t3, $s5
	mflo $s4

	li $s5, 16
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $t5

	j endProc

fourDigits: #num1*16^3 +... + num4*16^0

	li $s5, 4096
	multu $t3, $s5
	mflo $s4

	li $s5, 256
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 16
	multu $t5, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $t6

	j endProc

fiveDigits: #num1*16^4 +... + num5*16^0
	li $s5, 65536
	multu $t3, $s5
	mflo $s4

	li $s5, 4096
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6


	li $s5, 256
	multu $t5, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 16
	multu $t6, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $t7

	j endProc

sixDigits: #num1*16^5 +... + num6*16^0
	li $s5, 1048576
	multu $t3, $s5
	mflo $s4

	li $s5, 65536
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 4096
	multu $t5, $s5
	mflo $s6
	addu $s4, $s4, $s6


	li $s5, 256
	multu $t6, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 16
	multu $t7, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $t8

	j endProc

sevenDigits: #num1*16^6 +... + num7*16^0
	li $s5, 16777216
	multu $t3, $s5
	mflo $s4

	li $s5, 1048576
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 65536
	multu $t5, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 4096
	multu $t6, $s5
	mflo $s6
	addu $s4, $s4, $s6


	li $s5, 256
	multu $t7, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 16
	multu $t8, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $t9

	j endProc

eightDigits: #num1*16^7 +... + num8*16^0

	li $s5, 268435456
	multu $t3, $s5 #puts a negative number in LO for some reason
	mflo $s4

	li $s5, 16777216
	multu $t4, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 1048576
	multu $t5, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 65536
	mult $t6, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 4096
	multu $t7, $s5
	mflo $s6
	addu $s4, $s4, $s6


	li $s5, 256
	multu $t8, $s5
	mflo $s6
	addu $s4, $s4, $s6

	li $s5, 16
	multu $t9, $s5
	mflo $s6
	addu $s4, $s4, $s6

	addu $s4, $s4, $s2


	j endProc
	
endProc:
	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	#output the new string
	li $v0, 1
	addu $a0, $s4, $zero
	syscall

	#endline
	li $v0, 4
	la $a0, endline	
	syscall

	li $v0, 10
	syscall