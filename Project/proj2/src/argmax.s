.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)
    
    li s0, 0
    li t1, 0
    lw s1, 0(a0)
    li t0, 1
    blt a1, t0, invalid_length
    
loop_start:bge t1, a1, loop_end
    lw t0, 0(a0)
    bge s1, t0, loop_continue 
    mv s1, t0
    mv s0, t1

loop_continue:
    addi t1, t1, 1
    addi a0, a0, 4
    j loop_start

loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp ,12
    ret

invalid_length:
    li a0 77
    jal exit2        
