.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    

    # check for arg numbers
    li t0, 5
    li t1, 6
    beq a0, t0, correct_args
    beq a0, t1, correct_args
    j incorrect_args

correct_args:
    # Prologue
    addi sp, sp, -64
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)
    
    # save the args
    lw s0, 4(a1)
    lw s1, 8(a1)
    lw s2, 12(a1)
    lw s3, 16(a1)
    mv s8, a2

	# =====================================
    # LOAD MATRICES
    # =====================================   

    # Load pretrained m0
    mv a0, s0
    addi a1, sp, 40
    addi a2, sp, 44
    jal read_matrix
    mv s0, a0

    # Load pretrained m1
    mv a0, s1
    addi a1, sp, 48
    addi a2, sp, 52
    jal read_matrix
    mv s1, a0

    # Load input matrix
    mv a0, s2
    addi a1, sp, 56
    addi a2, sp, 60
    jal read_matrix
    mv s2, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # First layer
    
    # set space for the hidden
    lw t0, 40(sp)
    lw t1, 60(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_fail
    mv a6, a0

    
    # calculate the first
    mv a0, s0
    lw a1, 40(sp)
    lw a2, 44(sp)
    mv a3, s2
    lw a4, 56(sp)
    lw a5, 60(sp)
    addi sp, sp, -4
    sw a6, 0(sp)
    jal matmul
    lw a6, 0(sp)
    addi sp, sp, 4
    mv s5, a6
    
    # calculate the second 
    mv a0, s5
    lw t0, 40(sp)
    lw t1, 60(sp)
    mul a1, t0, t1
    jal relu
    
    # set space for the result
    lw t0, 48(sp)
    lw t1, 60(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, malloc_fail
    mv a6, a0
    
    # calculate the third
    mv a0, s1
    lw a1, 48(sp)
    lw a2, 52(sp)
    mv a3, s5
    lw a4, 40(sp)
    lw a5, 60(sp)
    addi sp, sp, -4
    sw a6, 0(sp)
    jal matmul
    lw a6, 0(sp)
    addi sp, sp, 4
    mv s6, a6
    
    # free the hidden layer
    mv a0, s5
    jal free

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s6
    lw a2, 48(sp)
    lw a3, 60(sp)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s6
    lw t0, 48(sp)
    lw t1, 60(sp)
    mul a1, t0, t1
    jal argmax
    mv s7, a0
    
    # free the result
    mv a0, s6
    jal free

    # Print classification
    bne s8, x0, no_print
    mv a1, s7
    jal print_int

    # Print newline afterwards for clarity
    li a1, 13
    jal print_char

no_print:
    # Epilogue
    mv a0, s7
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 64 
    
    ret

incorrect_args:
    li a1, 89
    jal exit2

malloc_fail:
    li a1, 88
    jal exit2
