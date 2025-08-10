.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    
    # save the arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # open the file
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s0, a0
    
    # save rows
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal fread
    li a3, 4
    blt a0, a3, fread_error
    
    # save cols
    mv a1, s0
    mv a2, s2
    li a3, 4
    jal fread
    li a3, 4
    blt a0, a3, fread_error
    
    # malloc space
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a0, t0, t1
    slli a0, a0, 2
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw ra, 8(sp)
    jal malloc
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    beqz a0, malloc_error
    mv, a2, a0
    mv s1, a0
    
    # read the matrix
    mv, a1, s0
    mul, a3, t0, t1
    slli a3, a3, 2
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a3, 4(sp)
    jal fread
    lw ra, 0(sp)
    lw a3, 4(sp)
    addi sp, sp, 8
    bne a0, a3, fread_error      
    
    # close the file
    mv a1, s0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fclose
    lw ra, 0(sp)
    addi sp, sp, 4
    li t0, -1
    beq a0, t0, fclose_error
    mv s0, a0
    
    
    # Epilogue
    mv a0, s1
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
    
malloc_error:
    li a1, 88
    jal exit2

fopen_error:
    li a1, 90
    jal exit2

fread_error:
    li a1, 91
    jal exit2
    
fclose_error:
    li a1, 92
    jal exit2
