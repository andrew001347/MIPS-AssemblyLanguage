######################################################################### 
# Program: Combinatorial Calculator with recursion   Programmer: Andrew Kim
# Due Date: Oct 21, 2021    Course: CS2640
######################################################################
# Overall Program Functional Description:
# For this project we are tasked to make a combinatorial calculator.
# The task is to ask for user to input two values. The n value must be n >= r
# and the r value must be r >= 0. If the user does not follow these rules,
# display a prompt that asks the user to try again.
# This program does not follow the combinatorial formula. Instead we
# will be using a recursive function that computes Comb(n,r) 
# Comb(n, r) = 1 if n == r or r == 0
# Comb(n, r) = Comb(n - 1, r) + Comb(n - 1, r - 1)
######################################################################
# Pseudocode Description:
# 1.We will first ask the user to enter values for n and r
# 2. We will then check these values if they are n >= r and r >= 0.
# 3. If they do not follow these parameters, we will ask the user to input the values again. 
# 4. We will then make room in the stack. 
# 5. Since we know that if n==r and r==0 will result in 1, make a parameter that allows that to happen
# 5.5. If the user has given n==r and r==0 skip the whole n-1 and r-1.
# 6. If the users are not n==r and r==0 we will begin by subtracting one from n. amd then storing it into the stack.
# 7. Then using recursion, we will check when n==r. Once that is true, add one.
# 8. Since we only care if r >= 0, make a sort of like a counter as to when r hits zero. Once it is zero, add 1.
# 9. Since we were changing the value given to us by the user, make sure we restore it.
# 10. Print the added numbers and end the program.
######################################################################
.data

	message: .asciiz "Please enter values for n and r. N must be greater than or equal to r and r must be greater than or equal to 0.\n\n"
	inValid: .asciiz "Invalid input, try again. \n"
	
	messageN: .asciiz "Value for n:\n"
	messageR: .asciiz "Value for r:\n"
	
	result: .asciiz "The result is: "
.globl main

.text
main:
	#printing prompt
	li $v0, 4
    	la $a0, message
    	syscall  

while:
	#getting n value.
	li $v0, 4
    	la $a0, messageN
    	syscall
    	
	li $v0,5
    	syscall
	move $t0, $v0
	
	#getting r value.
	li $v0, 4
    	la $a0, messageR
    	syscall
    	
	li $v0, 5
    	syscall
	move $t1, $v0 #getting user input and storing it to t1
	
bgt $t1, $t0, badINT #if the r($t1) value is bigger than the n($t0) value, branch to badINT.
blt $t1, $zero, badINT	#checks if $t0 will be a negative number.

jal Comb # calling the recursive subroutine. 
j end # jumping to end to skip badINT, cant use comb because it is a subroutine.

badINT: 
	li $v0, 4
    	la $a0, inValid
    	syscall
    	j while
   
###########################################################################
# Function Name: comb
###########################################################################
# Register Usage:
# $t0 will hold value of n
# $t1 will hold value of r
# $t3 will hold return value and sum
##########################################################################
# Pseudocode Description:
# 1.Subtract 12 to make stack space
# 2. Check if n(t0)==r(t1), add 1 if it is and return 
# 3 Check if r ==0, add 1 if it is and return 
# 4. Add 12 to because we are done with the stack
##########################################################################   	  					
Comb: 
	addiu $sp, $sp, -12 #making stack space
	sw $ra, 0($sp) #return address. 
	sw $t0, 4($sp) #value of n stored here
	sw $t1, 8($sp) #value of r stored here
	
loop:
	beq $t0, $t1, adding # if n = r, go to adding
	beqz  $t1, adding # if r = 0, go to adding
	
	# Comb(n - 1, r)
	addi $t0, $t0, -1 #subtracting n by 1
	sw $t0, 4($sp)
	jal Comb
	lw $t0, 4($sp) # coming back from the subroutine, we want to reload the original value from the stack. 
	lw $t1, 8($sp) #the reason why we are reloading the value is because we have previously been messing with it
			# we are essesntially restoring the value, because going into the subroutine.
	
	# Comb(n - 1, r - 1)
	addi $t1, $t1, -1 #subtracting the r value by 1.
	beqz  $t1, adding #if r = 0, go to adding
	sw $t1, 8($sp) # this is to retore the number. we were previously subtracting from recursion. 
	j loop #loop back since we still have values of n and r not equal to each other or r has not yet reached 0.
	
# Here t3 is going to hold the sum of all the 1s being added only when n==r and r==0
adding:
	addi $t3, $t3, 1 #adding 1 because conditions were met.
	lw $ra 0($sp) #loading in the return address from the stack.
	addiu $sp, $sp, 12 #clear stacks.
	jr $ra
end:
	li $v0, 4
    	la $a0, result
    	syscall
    	
    	li $v0, 1 #printing the total.
    	move $a0, $t3
    	syscall 
    	
	li $v0, 10
	syscall
