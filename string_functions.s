##############################################################################
#
#  KURS: 1DT016 2014.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#	by: Lovely Grace Arsolon & Icel Ann Rodriguez
#	date: 03.26.2018
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "?@ AB YZ [\\ _` ab yz {|"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	beq 	$t0, $a1 , end_for_all 	# Done if i == N
	sll 	$t4, $t0, 2 		# offset = 4*i, shift the index stored in $t0 by two bits to the left.
	add 	$t3, $a0, $t4 		# address = ARRAY + 4*i
	lw 	$t5, 0($t3)		# n = A[i]
       	add 	$v0, $v0, $t5 		# Sum = Sum + n
        addi 	$t0, $t0, 1		# i++ 
  	j 	for_all_in_array	# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	addi $s5, $zero, 0 		#store null (or 0) to $s5
	addi $v0, $zero, 0		#initialize $v0 to 0

loop:
	lb $t1, 0($a0)		# load the next character into t1
	beq 	$t1, $s5, exit 	# check for the null character
	addi 	$a0, $a0, 1 	# increment the string pointer
	addi 	$v0, $v0, 1 	# increment the count
	j 	loop 		# return to the top of the loop
exit:
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:
	addi $s5, $zero, 0 		# store null (0) to $s5
loop2:
	lb 	$s6, 0($a0)		# load the next character into t1
	beq 	$s6, $s5, exit2 	# check for the null character
	
	addi 	$sp, $sp, -4
	sw	$a0, 0($sp)	# save value of $a0
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)	# save return address before each subroutine call
	
	jalr 	$a1		# call callback subroutine
	
	lw	$ra, 0($sp)	# restore return address after each subroutine call
	addi 	$sp, $sp, 4
	lw	$a0, 0($sp)	# load old value of $a0
	addi 	$sp, $sp, 4
	addi 	$a0, $a0, 1 	# increment the string pointer
	j 	loop2 		# loop again
exit2:
	jr $ra			# return to caller

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
	#addi	$a0, $a0, -32 	#Unsa diay ni siya sir?
	addi	$v0, $zero, 0
	lb 	$a2, 0($a0)
	addi	$t2, $zero, 1			# store 1 to $t2, for comparison of $t1
	slti	$t1, $a2, 123			# set $t1 to 1 if char lesser than or equal to 'z'
	bne	$t2, $t1, return_to_caller	# if $t1 is 0, don't need to change special char
	addi	$a2, $a2, -32			# lower the case of a char
   	slti 	$t1, $a2, 65			# set $t1 to 1 if char - 32 is lesser than 65('A')
   	bne 	$t1, $t2, store_cap		# if $t1 is 0, meaning greater than 65, store and return capitalized char
   	addi 	$a2, $a2, 32			# if $t1 is 1, meaning lesser than 65,change char back to upper case
   	add	$v0, $a2, $zero			# copy value of $a2 to $v0 ($v0 & $v1 passes function results_)
   	sb 	$v0, 0($a0)			# store byte to $a0
   	j	return_to_caller
   store_cap:
   	add	$v0, $a2, $zero			# copy value of $a2 to $v0 ($v0 & $v1 passes function results_)
   	sb	$v0, 0($a0)			# store byte ro $a0
   return_to_caller:
	jr	$ra				# return to caller

##############################################################################
##############################################################################
##
##	  You don't have to change anyghing below this line.
##	
##############################################################################
##############################################################################

	
##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	# Print result
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string

	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text
	
	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
