.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks   

    blez a1, invalid_size_m0
    blez a2, invalid_size_m0
    blez a4, invalid_size_m1
    blez a5, invalid_size_m1
    bne a2, a4, mismatch_size
    
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    
    li t0, 0 # count rows of m0
    li t1, 0 # count cols of m1
    mv s0, a0 #store the start of m0
    mv s1, a1 #store the rows 0f the m0
    mv s2, a2 # store the cols of the m0
    mv s3, a3 # store the start of m1
    mv s4, a5 # store the cols of m1
    mv s5, a6 # store the start of the result

outer_loop_start:
    beq t0, s1 outer_loop_end

inner_loop_start:
    beq t1, s4 inner_loop_end
    #set a0
    mul t2, t0, s2
    slli t2, t2, 2
    add a0, s0, t2
    # set a1
    slli a1, t1, 2
    add a1, a1, s3
    # set a2
    mv a2, s2
    # set a3
    li a3, 1
    # set a4
    mv a4, s4
    
    # save
    addi sp, sp ,-16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)
    
    jal dot
    
    #restore
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    
    #store into d
    mul t3, t0, s4
    add t3, t3, t1
    slli t3, t3, 2
    add t3, t3, s5
    sw a0, 0(t3)
    addi t1, t1, 1
    j inner_loop_start
    
inner_loop_end:
    addi t1, zero, 0
    addi t0, t0, 1
    j outer_loop_start
    

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp sp 28
    ret
    
invalid_size_m0:
    li a1, 72
    jal exit2
    
invalid_size_m1:
    li a1, 73
    jal exit2

mismatch_size:
    li a1, 74
    jal exit2
