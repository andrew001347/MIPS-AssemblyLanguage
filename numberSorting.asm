######################################################################### 
# Program: Number Entry and Display)    Programmer: Andrew Kim
# Due Date: Oct 7, 2021    Course: CS2640
######################################################################
# Overall Program Functional Descriptio:
# The task is to ask for user to input 20 integers.
# We then get the input and store it into an array. 
# With that array, we display it to the console
# 3 different ways. 1) Display each number in a individual line. 
# 2) Display each number all in the same line. 
# 3) Display in a in a row/column format by asking user how many to display 
# before jumping to a new line. 
######################################################################
# Pseudocode Description:
# Beginning: initialize t1 and array. 
# 1. Display and ask user to enter 20 integers into the array. 
# 2. Have a counter that know when we have hit 20.
# 3. We also need to increment array, so it can point to a new memory space. 
# 4. Once the counter (t1) hits 20 all the user input will be in the array and we will branch to a new set of codes. 
# 5. Make sure to reset the counter and the pointer to the array. That way we are not in counter 20 nor in the last element of the array.
# 6. Display the numbers accordingly. 
# 7. End the program.
######################################################################
.data
	array: .space 80
	message: .asciiz "Please enter 20 numbers: "
	
	format1: .asciiz "Numbers in a new line: \n "
	newLine: .asciiz "\n"
	
	format2: .asciiz "\nNumbers in a single line with spaces: \n"
	sameLine: .asciiz " "
	
	message2: .asciiz "\nEnter a number to sort the numbers up: \n"

.align 2	
.globl main
.text
main:
	# initializing the array and t1 as  zero.
	la $t0, array
	li $t1, 0
while: #inserting user input into an array
	beq $t1, 20, form1
	add $t1, $t1, 1  # counter to know when to stop and branch to new target.
	
	li $v0, 4
    	la $a0, message
    	syscall  
          
    	li $v0,5
    	syscall
	
    	sw $v0, ($t0)
    	add $t0, $t0, 4  #pointing to the next array space.
    
    	j while

form1: #printing numbers in a seperate line
    	li $v0, 4
    	la $a0, newLine
    	syscall
    	
    	li $v0, 4
    	la $a0, format1
    	syscall
    	# initializing the array and t1 as zero again to reset the pointer of the array and counter for t1
    	la $t0, array
	li $t1, 0
    	
loop:
    	beq $t1, 20, form2 
    	add $t1, $t1, 1 #increment counter
    	
    	lw $t6, ($t0) # getting the first element from the array and storing it to t6
    	add $t0, $t0, 4 #increment pointer to the next array space. 
    	
	li $v0, 1 #prints stuff from the array
	move $a0, $t6
	syscall
    	
    	li $v0, 4
    	la $a0, newLine 
    	syscall  
    	j loop

form2:#printing numbers in a same line
    	li $v0, 4
    	la $a0, format2
    	syscall
    	#resetting
    	la $t0, array
	li $t1, 0
loop2:
    	beq $t1, 20, form3
    	add $t1, $t1, 1 #increment counter
    	
    	lw $t6, ($t0)
    	add $t0, $t0, 4 #increment pointer
    	
	li $v0, 1 #prints stuff from the array
	move $a0, $t6
	syscall
    	
    	li $v0, 4
    	la $a0, sameLine 
    	syscall  
    	j loop2
    	
form3:
	li $v0, 4
    	la $a0, message2
    	syscall  
          
    	li $v0, 5
    	syscall
    	#store input value to t7 be our row counter 
    	move $t7, $v0
    	#saving user input twice to t3 to use again later.
    	move $t3, $v0
    	
    	#resetting again.
    	la $t0, array
	li $t1, 0	
    	
loop3:
    	beq $t1, 20, done
    	add $t1, $t1, 1 #increment counter
    	
    	lw $t6, ($t0)
    	add $t0, $t0, 4 #increment pointer
    	
	li $v0, 1
	move $a0, $t6 # displaying the values of the number. 
	syscall 
    	    	
    	add $t7, $t7, -1 #counter to know when to jump
    	beq $t7, $zero, jumpLine #indicates when user input decrements to zero, a new line will occur.
    	
    	li $v0, 4
    	la $a0, sameLine
    	syscall
	j loop3
jumpLine: 
	#resetting the value of user input. 
   	move $t7, $t3 # this is why we saved the value twice earlier. We are giving t7 user input again, because user input was zero before.  
   	li $v0, 4
    	la $a0, newLine
    	syscall
	j loop3     		
done:			
	li $v0, 10
	syscall






