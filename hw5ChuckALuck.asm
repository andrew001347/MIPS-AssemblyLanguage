######################################################################### 
# Program: Number Entry and Display)    Programmer: Andrew Kim
# Due Date: Nov. 9, 2021    Course: CS2640
######################################################################
# Overall Program Functional Descriptio:
# This program is to play Chuck-A-Luck. You will be asked enter a seed number to play. 
# You will also be asked to wager a number between your total amount and to pick a number 1 to 6.
# Enter zero to stop playing. Three dice numbers will appear using the seedrand and rand function. Match the dice numbers and win money.
######################################################################
# Pseudocode Description:
# 1. I will first start by initializing the starting value of 500 to s3 (forgot that we were already using t0 for rand.)
# 2. I thought about this later when I was writing my code, but I also initalized t3 as 6 and t8 as 1 to act as limits for a dice pick.(1-6)
# 3. The only way the code ends is if the wager is $0 or if user inputs 0 for their wager. Make a loop that ends if either condition is met. 
# 4. We will first display what we are playing, how much we are starting with, and ask the user to input a seed value. If the seed
#    is 0 make sure to account for this error and make the seed equal to a preset value.
# 5. We will now make a loop where it finishes only when the conditions are met as stated above.
# 6. In this loop we will ask user to input a wager and die number. We have to make sure wager is not negative and it is not higher than the wager.
#    We also need to acount for the die number to be between 1-6.
# 7. If user inputs an invalid response, ask the user to try again.
# 8. Set up a counter to check how many times the die matched with the number die user selected. 
# 9. Based on how many matched, display the results and loop back again.
# 10. In the end we will display the amount you won and end the program.
######################################################################
.data
	message: .asciiz "Now playing Chuck-A-Luck. You will start with $500.\n"
	rng: .asciiz "Enter a seed number: "
	currentValue: .asciiz"You currently have $"
	
	newLine: .asciiz"\n"
	space: .asciiz"   "
	wager: .asciiz"How much would you like to wager? "
	betOn: .asciiz "\nWhat number die do you want to bet on? "
	threeNums: .asciiz "Your lucky numbers are: "
	
	winNone: .asciiz "None of the numbers matched, you lost money.\n"
	winOne: .asciiz "You matched once! You won your wager! \n"
	winTwo: .asciiz "You matched twice! You won your twice your wager! \n"
	winThree: .asciiz "You matched three times! You won three times your wager! \n"
	
	invalid: .asciiz "Invalid wager. Try again! \n"
	dieError: .asciiz "Invalid die number. Pick 1-6. \n"
	end: .asciiz " Thanks for playing."
	
seed: .word 31415

.globl main
.text
main:
	li $s3, 500 #saving the initial starting value of 500 to s3. It was originally t0, but t0 is being used to get the random numbers.
	li $t3, 6# t3 will be used as the max limit for the die
	li $t8, 1#t8 will be used as the min limit for the die.
	
	li $v0, 4
    	la $a0, message 
    	syscall  #Displays the what we are playing and how much we are starting with.
    	
    	li $v0, 4
    	la $a0, rng
    	syscall  #Asks the user to input a value for random number generator.
    	
    	li $v0,5
    	syscall #Gets the user input for random number generator.

    	beqz $v0, seedError #this subroutine will trigger if the user inputted zero for their seed value. The preset value of 31415 will be used instead.
    	
seedReturn: #This is used to comeback if user input was 0 for seed.
    	move $a0, $v0 # now saving the seed value into a0 to be used in the rand function.
    	jal seedrand #Storing the seed to be used in the rand function.
    	
loop: #start of loop to get wager and die number.
	beqz $s3, done # current balance zero? End game if so.
		  	
    	li $v0, 4
    	la $a0, currentValue
    	syscall
    	
    	li $v0, 1
    	move $a0, $s3
    	syscall    #Displays our current balance.
    	
  	li $v0, 4
    	la $a0, newLine
    	syscall
    		
    	li $v0, 4
    	la $a0, wager
    	syscall  #Asks user for how much to bet.
    	
    	li $v0, 5
    	syscall
    	move $t1, $v0#Storing user wager to t1.
    	
	beqz $t1 done
	bltz $t1, numError #checks for non-negative numbers.
	bgt $t1, $s3 , numError #user input will not be bigger than balance.

dieNum: # setting up this subroutine so if there is a mistake, we only go back to here instead of all the way to the top.
    	li $v0, 4
    	la $a0, betOn
    	syscall  #Asks user what number to bet on.(Die number)

    	li $v0,5
    	syscall
    	move $t2, $v0 #Storing die number to t2.
    	
    	blt $t2, $t8, dieErr 
	bgt $t2, $t3 dieErr #These branches will ensure that user only inputs die numbers between 1-6.
	
    	jal rand 
    	move $t4, $v0 #Getting the first number and storing it to t4.
    	
    	jal rand
    	move $t5, $v0 #Getting the first number and storing it to t5.
    	
    	jal rand
    	move $t6, $v0 	#Getting the first number and storing it to t6.

    	li $v0, 4
    	la $a0, threeNums
    	syscall #Displays a message.
    	
	li $v0, 1
    	move $a0, $t4
    	syscall 
	li $v0, 4
    	la $a0, space
    	syscall
    	
    	li $v0, 1
    	move $a0, $t5
    	syscall 
    	li $v0, 4
    	la $a0, space
    	syscall
    	
    	li $v0, 1
    	move $a0, $t6
    	syscall   
    	
	li $v0, 4
    	la $a0, newLine
    	syscall    	  #Lines 122-146 will display what the all three die numbers were. 	
    	
    	li $t7, 0 #Making a counter to see how much you won.  
    	li $s0, 1 #Setting up a counter to branch if there is 1 match.
	li $s1, 2 #Setting up a counter to branch if there is 2 match.
	li $s2, 3 #Setting up a counter to branch if there is 3 match.
adding:       		  	  	  	
    	beq $t2, $t4, counter
match1:	  	  	  		  	  	  	
    	beq $t2, $t5, counter2
match2:  	  	  		  	  	  		  	  	  	
    	beq $t2, $t6, counter3
match3:    		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  	
    	beqz $t7, noWin #This means that there was no match found.
    	beq $t7, $s0, oneWin #One match found
    	beq $t7,$s1, twoWin #Two matches found.
    	beq $t7, $s2 , threeWin #Three matches found. 
    	
noWin:
    	li $v0, 4
    	la $a0, winNone
    	syscall	
	sub $s3, $s3, $t1 #subtract from the balance and wager.
	j loop

oneWin:    		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	    		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  		  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	li $v0, 4
    	la $a0, winOne
    	syscall	
	add $s3, $s3, $t1 #add from the balance and wager	
	j loop

twoWin:
    	li $v0, 4
    	la $a0, winTwo
    	syscall	
	mul $t1, $t1, $s1 #multiply the amount you wagered by 2 
	add $s3, $s3, $t1 #then add it to the total balance.
	j loop	
	
threeWin:
    	li $v0, 4
    	la $a0, winThree
    	syscall
	mul $t1, $t1 ,$s2 #multiply the amount you wagered by 3
	add $s3, $s3, $t1  #then add it to the total balance.  		  	  	
	j loop
	   	    	   	    	   	    	   	    	
rand: 
	lw $v0, seed #use the seed number either from user or the preset.
	sll $t0, $v0, 13
	xor $v0, $v0, $t0
	srl $t0, $v0, 17# Compute $v0 ^= $v0 >> 17
	xor $v0, $v0, $t0
	sll $t0, $v0, 5# Compute $v0 ^= $v0 << 5
	xor $v0, $v0, $t0 
	sw $v0, seed# Save result as next seed
	
	andi $v0, $v0, 0xFFFF
	li $t0, 6
	div $v0, $t0
	mfhi $v0 #take the remainder, then increment
	add $v0, $v0, 7#Adding 1 will make the results between 1-6. Previously it was 0-5.
	jr $ra
	
seedrand: 
	sw $a0, seed
	jr $ra

seedError:
	lw $v0, seed #preset value is now being used as the seed.
	j seedReturn
    	    	    	    	
numError: #used only if wager is negative or higher than current balance.
    	li $v0, 4
    	la $a0, invalid 
    	syscall
    	j loop	    	

dieErr: #Displays that user input a wrong die number.
    	li $v0, 4
    	la $a0, dieError
    	syscall
    	j dieNum	
    		    	
counter: #These counters are used to ensure that we are not continously looping in adding subroutine.
	add $t7, $t7, 1
	j match1 #Goes past the first number check between user input.

counter2:
	add $t7, $t7, 1
	j match2#Goes past the second number check between user input.
	
counter3:
	add $t7, $t7, 1
	j match3#Goes past the third number check between user input.
	
done:
    	li $v0, 4
    	la $a0, currentValue
    	syscall 
    	li $v0, 1
    	move $a0, $s3
    	syscall    #Displays current amount of money one last time.
    	
    	li $v0, 4
    	la $a0, space
    	syscall
    	
	li $v0, 4
    	la $a0, end
    	syscall  
    			
	li $v0, 10
	syscall #end.
	
