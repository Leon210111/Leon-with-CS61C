.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the number of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    
    li, t0, 1
    blt a1, t0, invalid_length
    
loop_start: beq, a1, zero  loop_end
            lw t0, 0(a0)
            bge t0, zero, loop_continue
            sw zero, 0(a0)

loop_continue:  addi a0, a0, 4
                addi a1, a1, -1
                j loop_start
                


loop_end:

    # Epilogue
    
	ret
    
invalid_length:
    li a0, 78      
    jal exit2
    