.globl   main

.data

NUM: .word 0
Array: .word 0:30 #number zero 30 times
jump_table: .word add_number, REPLACE, DEL, Find, average, max, print_array, sort,END
msg1: .asciiz  "\n\nThe options are: \n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\n"
msg2: .asciiz "\nselect an option: "
msg3: .asciiz "\nThe array is full.\n"
msg4: .asciiz "\nWhat Number To Add? : "
msg5: .asciiz "\nThe new Number is now placed on index: " 
msg6: .asciiz "\nnumber was not found in the array, so it has been added\n" 
msg7: .asciiz "\nThe number is already exists in the array at index: " 
msg8: .asciiz "\nThe array is EMPTY - no number to replace\n "  
msg9: .asciiz "\nWhat number to replace?: " 
msg10: .asciiz "\nThe Number was NOT found in the array so it cant be replaced.\n"
msg11: .asciiz "\nReplace the number "
msg12: .asciiz " (in index"
msg13: .asciiz ") with what number ? : "
msg14: .asciiz "\nThe numbers have been replaced Succefuly\n"
msg15: .asciiz "\nWhat number to delete? : "
msg16: .asciiz "\nThe Number has been Deleted Successfuly\nThe hole hase been covered.\n"
msg17: .asciiz "\nwhat number to find? :"
msg18: .asciiz "\nthe number was not found\n"
msg19: .asciiz "\nThe number was found! index: "
msg20: .asciiz "\nthe sum of the Array in base 10: "
msg21: .asciiz "\nThe Average is in base 10: "
msg22: .asciiz ","
msg23: .asciiz "\nin which base to print the average (2-10) : "
msg24: .asciiz "\nThe Average in the new base : "
msg25: .asciiz "\nin which base to print the MAX value? (2-10) : "
msg26: .asciiz "\nThe MAX value in the new base : "
msg27: .asciiz " At Index: "
msg28: .asciiz "\nin which base to print the Array? (2-10) : "
msg29: .asciiz "\nThe Array in the new base : "
msg30: .asciiz "\nGood Bye!\n"
msg31: .asciiz "\nThe array is EMPTY - no number to show\n "  
msg32: .asciiz "\nI chose not to do this task\n"  
msg33: .asciiz "-"
.text
 
main:

li $v0,4
la $a0,msg1 # print the menu
syscall
li $v0,4
la $a0, msg2 #select an option:
syscall
li $v0,5     #get option number from user
syscall

la $a1,NUM
la $a2,Array
move $s3,$v0
addi $s3,$s3,-1
la $t4, jump_table #load jump table pointer into $t4
#load case location from jump table
sll $t1,$s3,2      #Calculate word address at K=4*K
add $t0,$t1,$t4    #$t0 = Jtable + 4*k
lw $t0, 0($t0)     #Load location of triggered Case
jalr $t0             #Jump into Case
j main
################################################################################
add_number: 
# $a1 = NUM address
lw $t0,0($a1) # $t0 is the value of Num

addi $sp,$sp,-4 #storing NUM address on stack
sw $a1,0($sp)

bne $t0,30,NotFull #if the array is full jump back to main with message
li $v0,4
la $a0,msg3 #The array is full
syscall
jr $ra

NotFull:           #if the array is not full- continiue
li $v0,4
la $a0,msg4 # What Number To Add? :
syscall

li $v0,5    #getting number to add to the array
syscall

move $a1,$t0  #moving the NUM value to $a1
move $a3,$v0  #moving number from user to $a3

addi $sp,$sp,-4 #store $ra on stack
sw $ra,0($sp)

jal check

lw $ra,0($sp)  #loading $ra
addi $sp,$sp,4

move $t1,$v0     # $t1 = index

bne $t1,-1,existsInArray
#come here if the number is not exists in Array ($t1 = -1)
li $v0,4
la $a0,msg6 #number was not found in the array
syscall
# adding the number to the array
mul $t2,$t0,4   # $t2 = index*4
add $t2,$t2,$a2 # $t2 = Array addrress + index*4
sw $a3,0($t2) #store the number in the new place in the array

li $v0,4
la $a0,msg5 #The new Number is now placed on index: 
syscall

li $v0,1    #printing the Index that the new number is stored 
move $a0,$t0
syscall

lw $a1,0($sp)  #loading NUM address from Stack
addi $sp,$sp,4

addi $t0,$t0,1
sw $t0,0($a1)

j EndProcedure

existsInArray:
li $v0,4
la $a0,msg7 #The number is already exists in the array at index: 
syscall

li $v0,1
move $a0,$t1  #printing the index
syscall

EndProcedure:
jr $ra

################################################################################
REPLACE:
# $a1 = NUM Address
# $a2 = Array pointer
lw $t0,0($a1)      # $t0 = NUM value
bne $t0,0,NotEmpty #if the array is Empty jump back to main with message
li $v0,4
la $a0,msg8 #The array is EMPTY
syscall
jr $ra

NotEmpty:
li $v0,4
la $a0,msg9 #What number to replace? 
syscall

li $v0,5    #getting number to replace
syscall

move $a1,$t0  #moving the NUM value to $a1
move $a3,$v0  #moving number from user to $a3

addi $sp,$sp,-4 #store $ra on stack
sw $ra,0($sp)

jal check

lw $ra,0($sp)  #loading $ra
addi $sp,$sp,4

# $v0=index of user number in the array

move $t1,$v0 # $t1 = index

bne $t1,-1,Found
#get here if the number was not found ($v0=-1)
li $v0,4
la $a0,msg10 #The Number was NOT found in the array so it cant be replaced
syscall
jr $ra

Found:
#get here if the number was found ($v0=index)
li $v0,4
la $a0,msg11 
syscall
li $v0,1
move $a0,$a3
syscall
li $v0,4
la $a0,msg12 
syscall                  # Replace the number x (in index y) with what number ? : 
li $v0,1
move $a0,$t1
syscall
li $v0,4
la $a0,msg13
syscall

li $v0,5    #getting number to replace from user
syscall

move $a3,$v0  #$a3 = number from user

addi $sp,$sp,-4 #store $ra on stack
sw $ra,0($sp)

jal check

lw $ra,0($sp)  #loading $ra
addi $sp,$sp,4

move $t2,$v0   #$t2 = newIndex
bne $t2,-1,DontReplace
#get here if you want to replce the numbers
mul $t6,$t1,4   #$t6= oldIndex*4

add $t6,$t6,$a2 #$t6 = NUM address + oldIndex*4
sw $a3 0($t6) #store the new num in the old index

li $v0,4
la $a0,msg14    #The numbers have been replaced Succefuly

jr $ra

DontReplace:
li $v0,4
la $a0,msg7    #The number is already exists in the array at index:
syscall
li $v0,1
move $a0,$t2   #printing the index
syscall

jr $ra
################################################################################
DEL:

bne $t0,0,NotEmpty2 #if the array is full jump back to main with message
li $v0,4
la $a0,msg8 #The array is EMPTY
syscall
jr $ra

NotEmpty2:
lw $t0,0($a1) # $t0 is the value of Num

addi $sp,$sp,-4 #store NUM address on stack
sw $a1,0($sp)

li $v0,4
la $a0,msg15 #What number to delete? 
syscall

li $v0,5    #getting number to delete
syscall

move $a1,$t0  #moving the NUM value to $a1
move $a3,$v0  #moving number from user to $a3

addi $sp,$sp,-4 #store $ra on stack
sw $ra,0($sp)

jal check

lw $ra,0($sp)  #loading $ra
addi $sp,$sp,4

# $v0=index of user number in the array

move $t1,$v0 # $t1 = index
bne $t1,-1,numExists
#get here if the number to delete was not found
li $v0,4
la $a0,msg6 #number was not found in the array
syscall

jr $ra

numExists:
#get here if you want to delete
bne $t1,29,Skip #edge case- if the index in the array is the last one- put zero and finish
mul $t6,$t1,4   
add $t6,$t6,$a2
sw $zero,0($t6)
j EndDelPro
Skip:
move $a3,$t1  #$a3=$t1=index to delete
addi $sp,$sp,-4
sw $ra,0($sp)

# $a1 = NUM value
# $a2 = Array address
# $a3 = index to delete
jal reduction

lw $ra, 0($sp)
addi $sp,$sp,4

lw $a1,0($sp)  #loading $ra
addi $sp,$sp,4

addi $t0,$t0,-1 #NUM value -1
sw $t0,0($a1)   #storing the new NUM value 


li $v0,4
la $a0,msg16 #The Number has been Deleted Successfuly\n The hole hase been covered.
syscall

EndDelPro:
jr $ra
################################################################################
Find:
lw $t2,0($a1) # $t2=NUM value
move $a1,$t2  # $a1=NUM value
li $v0,4
la $a0,msg17 #what  number to find?
syscall
li $v0,5 #$v0= num from user
syscall

move $a3,$v0  #$t0=num from user

addi $sp,$sp,-4 #store $ra on stack
sw $ra,0($sp)

jal check

lw $ra,0($sp)  #loading $ra
addi $sp,$sp,4

move $t1,$v0 #$t1=index

bne $t1,-1,NumFound
#get here if the number was not found
li $v0,4
la $a0,msg18 #the number was not found
syscall
jr $ra

NumFound:
li $v0,4
la $a0,msg19 #The number was found! index: 
syscall 
li $v0,1
move $a0,$t1 #printing the index
syscall
jr $ra
################################################################################
average:
lw $t0,0($a1) #$t0 = NUM value
li $t1,0      #loop counter
li $t2,0      #sum of Array
move $t3,$a2  #$t3=Arry address
sumLoop:
lw $t4,0($t3)
add $t2,$t2,$t4
addi $t1,$t1,1
addi $t3,$t3,4
bne $t1,$t0,sumLoop  

Stop:
div $t5,$t2,$t0 #div sum by NUM

li $v0,4
la $a0,msg23 #in which base you want to print? (2-10) :
syscall
li $v0,5     #getting base from user
syscall
move $t2,$v0
li $v0,4
la $a0,msg24 
syscall

addi $sp,$sp,-12 
sw $ra,0($sp)     #storing $ra address on stack
sw $a1,4($sp)     #storing NUM address on stack
sw $a2,8($sp)     #storing Array address on Stack 

move $a1,$t5    # $a1=$t5=Average
move $a2,$t2    # $a2=base

jal print_num

lw $ra,0($sp)     #loading $ra address on stack
lw $a1,4($sp)     #loading NUM address on stack
lw $a2,8($sp)     #loading Array address on Stack 
addi $sp,$sp,12 

jr $ra
#################################################################################
max:
# #a1 = NUM address
# $a2 = Array adderss pointer
li $t7,0      # $t7 = loop counter
lw $t1,0($a1) # $t1 = NUM value
move $t2,$a2  # $t2 = Array pointer
lw $t3,0($t2) # $t3 = max num in array (now its the first number in the array)
maxLoop:
lw $t4,0($t2) # $t4 = single number in array
blt $t4,$t3,noMax
#get here if you want to raplace the max
move $t3,$t4  #switch the max value
noMax:
addi $t2,$t2,4 #address+4
addi $t7,$t7,1 #counter++
bne $t1,$t7,maxLoop

addi $t7,$t7,-1 # $t7 = index of max number in Array

li $v0,4
la $a0,msg25 #in which base to print the the MAX value? (2-10) :
syscall
li $v0,5     #getting base from user
syscall
move $t2,$v0
li $v0,4
la $a0,msg26 #The MAX value in the new base :
syscall

addi $sp,$sp,-12 
sw $ra,0($sp)     #storing $ra address on stack
sw $a1,4($sp)     #storing NUM address on stack
sw $a2,8($sp)     #storing Array address on Stack 

move $a1,$t3    # $a1=$t5=max number
move $a2,$t2    # $a2=base

jal print_num

lw $ra,0($sp)     #loading $ra address on stack
lw $a1,4($sp)     #loading NUM address on stack
lw $a2,8($sp)     #loading Array address on Stack 
addi $sp,$sp,12 

li $v0,4
la $a0,msg27      #at index:
syscall
li $v0,1
move $a0,$t7
syscall

jr $ra
#################################################################################
print_array:
# #a1 = NUM address
# $a2 = Array adderss pointer
li $t0,0      # $t7 = loop counter
lw $t5,0($a1) # $t5 = NUM value
move $t4,$a2  # $t4 = Array pointer
bne $t5,0,NotEmptyArray #if the array is Empty jump back to main with message
li $v0,4
la $a0,msg31 #The array is EMPTY
syscall
jr $ra

NotEmptyArray:
li $v0,4
la $a0,msg28 #in which base to print the Array? (2-10) :
syscall
li $v0,5     #getting base from user
syscall
move $t3,$v0 #$t3 = base
li $v0,4
la $a0,msg29 #The Array in the new base :
syscall

addi $sp,$sp,-12 
sw $ra,0($sp)     #storing $ra address on stack
sw $a1,4($sp)     #storing NUM address on stack
sw $a2,8($sp)     #storing Array address on Stack 


move $a2,$t3     # $a2=base
printArrayLoop:
lw $a1,0($t4)    # $a1=$t4=single number in Array
jal print_num
li $v0,4
la $a0,msg22     # ","
syscall
addi $t4,$t4,4
addi $t5,$t5,-1
bnez $t5,printArrayLoop

lw $ra,0($sp)     #loading $ra address on stack
lw $a1,4($sp)     #loading NUM address on stack
lw $a2,8($sp)     #loading Array address on Stack 
addi $sp,$sp,12 

jr $ra
###############################################################################
sort:
li $v0,4
la $a0,msg32 #I chose not to do this task
syscall
jr $ra
################################################################################
END:
li $v0,4
la $a0,msg30 #Good Bye!
syscall
li $v0,10    #Exit program          
syscall
################################################################################
check:
# $a1=NUM value
# $a2=address of Array
# $a3=number from user
#return index in $v0
li $t5,0 #array +4
li $t7,0 #array counter
move $t3,$a2
loop: 
lw $t6,0($t3) # $t6 is the one of the number in the array occurding to $t5
bne $t6,$a3,NotEqual #if one of the numbers in the array is equal to the searc number print msg 5 and return the index
move $v0,$t7 # returning the index in $a1
jr $ra
NotEqual:
addi $t3,$t3,4  #adding 4 to the pointer
addi $t7,$t7,1  #adding 1 to the index counter
beq $t7,30,returnMinusOne #if the counter is 30 return -1
j loop
returnMinusOne: #return -1
li $v0,-1
jr $ra

##################################################################################
reduction:
# $a1 = NUM value
# $a2 = Array address
# $a3 = index to delete

move $t7,$a2   # $t7 = Array pointer
mul $t6,$a3,4  # $t6 = index*4
add $t7,$t6,$t7 # $t7 = Array pointer + index*4
sub $t5,$a1,$a3 # loop length = NUM value - index
li $t4,0         #loop counter
reductionLoop:

lw $t3,4($t7)  # $t3= specific number in array
sw $t3,0($t7) # store the next value
addi $t4,$t4,1
addi $t7,$t7,4
beq $t4,$t5,ExitReductionLoop
j reductionLoop

ExitReductionLoop:
sw $zero,4($t7)

jr $ra
#################################################################################
print_num:
# $a1 = number to convert
# $a2 = base
li $t0,0      #loop counter
bgez $a1,convertionLoop
#get here if the number is Negetive
li $v0,4
la $a0,msg33  # "-"
syscall
mul $a1,$a1,-1

convertionLoop:
div $t1,$a1,$a2 # $t1 = num\base (without fruction)
mfhi $t2        # $t2 = num%base (modulu)
move $a1,$t1
add $sp,$sp,-4  
sw $t2,0($sp)   #storing $t2 on stack
addi $t0,$t0,1
beq $t1,0,secondLoop
j convertionLoop

secondLoop:   # $t0 = loop length
lw $t1,0($sp) # $t1 = one figure
addi $sp,$sp,4
addi $t0,$t0,-1
li $v0,1
move $a0,$t1
syscall
bne $zero,$t0,secondLoop

jr $ra
