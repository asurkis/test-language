	li x1, l_stack_begin
	jal x2, p_main
	ebreak
p_print:
	addi x1, x1, 12
	addi x3, x1, -11
	addi x4, x1, -13
	lw x4, x4, 0
	li x5, 0
	slt x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -13
	lw x3, x3, 0
	li x4, 0
	slt x3, x3, x4
	beq x0, x3, if_0_false
	addi x3, x1, -13
	addi x4, x1, -13
	lw x4, x4, 0
	sub x4, x0, x4
	sw x3, 0, x4
if_0_false:
if_0_end:
	addi x3, x1, -13
	lw x3, x3, 0
	li x4, 0
	seq x3, x3, x4
	beq x0, x3, if_1_false
	li x3, 48
	ewrite x3
	jal x0, if_1_end
if_1_false:
	addi x3, x1, -12
	li x4, 10
	sw x3, 0, x4
while_2_begin:
	addi x3, x1, -13
	lw x3, x3, 0
	beq x0, x3, while_2_end
	addi x3, x1, -12
	addi x4, x1, -12
	lw x4, x4, 0
	li x5, 1
	sub x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -10
	addi x4, x1, -12
	lw x4, x4, 0
	add x3, x3, x4
	li x4, 48
	addi x5, x1, -13
	lw x5, x5, 0
	li x6, 10
	rem x5, x5, x6
	add x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -13
	addi x4, x1, -13
	lw x4, x4, 0
	li x5, 10
	div x4, x4, x5
	sw x3, 0, x4
	jal x0, while_2_begin
while_2_end:
	addi x3, x1, -11
	lw x3, x3, 0
	beq x0, x3, if_3_false
	li x3, 45
	ewrite x3
if_3_false:
if_3_end:
while_4_begin:
	addi x3, x1, -12
	lw x3, x3, 0
	li x4, 10
	slt x3, x3, x4
	beq x0, x3, while_4_end
	addi x3, x1, -10
	addi x4, x1, -12
	lw x4, x4, 0
	add x3, x3, x4
	lw x3, x3, 0
	ewrite x3
	addi x3, x1, -12
	addi x4, x1, -12
	lw x4, x4, 0
	li x5, 1
	add x4, x4, x5
	sw x3, 0, x4
	jal x0, while_4_begin
while_4_end:
if_1_end:
	addi x1, x1, -12
	jalr x0, x2, 0
p_scan:
	addi x1, x1, 2
	addi x3, x1, -2
	eread x4
	sw x3, 0, x4
while_5_begin:
	addi x3, x1, -2
	lw x3, x3, 0
	li x4, 0
	sne x3, x3, x4
	addi x4, x1, -2
	lw x4, x4, 0
	li x5, 45
	sne x4, x4, x5
	and x3, x3, x4
	addi x4, x1, -2
	lw x4, x4, 0
	li x5, 48
	slt x4, x4, x5
	addi x5, x1, -2
	lw x5, x5, 0
	li x6, 57
	slt x5, x6, x5
	or x4, x4, x5
	and x3, x3, x4
	beq x0, x3, while_5_end
	addi x3, x1, -2
	eread x4
	sw x3, 0, x4
	jal x0, while_5_begin
while_5_end:
	addi x3, x1, -2
	lw x3, x3, 0
	li x4, 0
	sne x3, x3, x4
	beq x0, x3, if_6_false
	addi x3, x1, -1
	addi x4, x1, -2
	lw x4, x4, 0
	li x5, 45
	seq x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -3
	lw x3, x3, 0
	addi x4, x1, -1
	lw x4, x4, 0
	li x5, 1
	xor x4, x4, x5
	addi x5, x1, -2
	lw x5, x5, 0
	li x6, 48
	sub x5, x5, x6
	mul x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -2
	eread x4
	sw x3, 0, x4
while_7_begin:
	li x3, 47
	addi x4, x1, -2
	lw x4, x4, 0
	slt x3, x3, x4
	addi x4, x1, -2
	lw x4, x4, 0
	li x5, 58
	slt x4, x4, x5
	and x3, x3, x4
	beq x0, x3, while_7_end
	addi x3, x1, -3
	lw x3, x3, 0
	addi x4, x1, -3
	lw x4, x4, 0
	lw x4, x4, 0
	li x5, 10
	mul x4, x4, x5
	addi x5, x1, -2
	lw x5, x5, 0
	add x4, x4, x5
	li x5, 48
	sub x4, x4, x5
	sw x3, 0, x4
	addi x3, x1, -2
	eread x4
	sw x3, 0, x4
	jal x0, while_7_begin
while_7_end:
	addi x3, x1, -3
	lw x3, x3, 0
	addi x4, x1, -3
	lw x4, x4, 0
	lw x4, x4, 0
	li x5, 1
	li x6, 2
	addi x7, x1, -1
	lw x7, x7, 0
	mul x6, x6, x7
	sub x5, x5, x6
	mul x4, x4, x5
	sw x3, 0, x4
	jal x0, if_6_end
if_6_false:
	addi x3, x1, -3
	lw x3, x3, 0
	li x4, 0
	sw x3, 0, x4
if_6_end:
	addi x1, x1, -2
	jalr x0, x2, 0
g_a:
	data 0 * 1
g_b:
	data 0 * 1
p_main:
	sw x1, 0, x2
	addi x1, x1, 1
	li x3, g_a
	sw x1, 0, x3
	addi x1, x1, 1
	jal x2, p_scan
	addi x1, x1, -1
	addi x1, x1, -1
	lw x2, x1, 0
	sw x1, 0, x2
	addi x1, x1, 1
	li x3, g_b
	sw x1, 0, x3
	addi x1, x1, 1
	jal x2, p_scan
	addi x1, x1, -1
	addi x1, x1, -1
	lw x2, x1, 0
	sw x1, 0, x2
	addi x1, x1, 1
	li x3, g_a
	lw x3, x3, 0
	li x4, g_b
	lw x4, x4, 0
	add x3, x3, x4
	sw x1, 0, x3
	addi x1, x1, 1
	jal x2, p_print
	addi x1, x1, -1
	addi x1, x1, -1
	lw x2, x1, 0
	li x3, 10
	ewrite x3
	jalr x0, x2, 0
l_stack_begin:
