.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# ============= ==========================================
dot:
    li t0, 1
    blt a2, t0, invalid_length
    blt a3, t0, invalid_stride
    blt a4, t0, invalid_stride
    # Prologue
    addi sp, sp -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    li s0, 0
    li s1, 0
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    
loop_start:
    bge t0, a2, loop_end
    mul t1, t0, a3
    slli t1, t1, 2
    add t2, t1, a0
    lw t1, 0(t2)
    mul t3, t0, a4
    slli t3, t3, 2
    add t2, t3, a1
    lw t3, 0(t2)
    mul t1, t1, t3
    add s0, s0, t1
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    ret

invalid_length:
    li a0, 75
    jal exit2
   
invalid_stride:
    li a0, 76
    jal exit2
