	addi x1, x0, 0
	jal x2, p_main
	ebreak
p_print:
	addi x1, x1, 12
	addi x3, x1, -11
	addi x4, x1, -13
	lw x4, x4, 0
	addi x5, x0, 0
	slt x4, x4, x5
	sw x4, x3, 0
	addi x3, x1, -13
	lw x3, x3, 0
	addi x4, x0, 0
	slt x3, x3, x4
	beq x0, x3, if_0_false
	addi x3, x1, -13
	addi x4, x1, -13
	lw x4, x4, 0
	sub x4, x0, x4
	sw x4, x3, 0
if_0_false:
if_0_end:
	addi x3, x1, -13
	lw x3, x3, 0
	addi x4, x0, 0
	seq x3, x3, x4
	beq x0, x3, if_1_false
	addi x3, x0, 48
	addi x31, x3, 0
	ewrite
	jal x0, if_1_end
if_1_false:
	addi x3, x1, -12
	addi x4, x0, 10
	sw x4, x3, 0
while_2_begin:
	addi x3, x1, -13
	lw x3, x3, 0
	beq x0, x3, while_2_end
	addi x3, x1, -12
	addi x4, x1, -12
	lw x4, x4, 0
	addi x5, x0, 1
	sub x4, x4, x5
	sw x4, x3, 0
	addi x3, x1, -10
	addi x4, x1, -12
	lw x4, x4, 0
	add x3, x3, x4
	addi x4, x0, 48
	addi x5, x1, -13
	lw x5, x5, 0
	addi x6, x0, 10
	rem x5, x5, x6
	add x4, x4, x5
	sw x4, x3, 0
	addi x3, x1, -13
	addi x4, x1, -13
	lw x4, x4, 0
	addi x5, x0, 10
	div x4, x4, x5
	sw x4, x3, 0
	jal x0, while_2_begin
while_2_end:
	addi x3, x1, -11
	beq x0, x3, if_3_false
	addi x3, x0, 45
	addi x31, x3, 0
	ewrite
if_3_false:
if_3_end:
while_4_begin:
	addi x3, x1, -12
	lw x3, x3, 0
	addi x4, x0, 10
	slt x3, x3, x4
	beq x0, x3, while_4_end
	addi x3, x1, -10
	addi x4, x1, -12
	lw x4, x4, 0
	add x3, x3, x4
	lw x3, x3, 0
	addi x31, x3, 0
	ewrite
	addi x3, x1, -12
	addi x4, x1, -12
	lw x4, x4, 0
	addi x5, x0, 1
	add x4, x4, x5
	sw x4, x3, 0
	jal x0, while_4_begin
while_4_end:
if_1_end:
	addi x1, x1, -12
	jalr x0, x2, 0
p_main:
	sw x2, x1, 0
	addi x1, x1, 1
	addi x3, x0, 12345678
	sub x3, x0, x3
	sw x3, x1, 0
	addi x1, x1, 1
	jal x2, p_print
	addi x1, x1, -1
	addi x1, x1, -1
	lw x2, x1, 0
	addi x3, x0, 10
	addi x31, x3, 0
	ewrite
	jalr x0, x2, 0
l_stack_begin:
