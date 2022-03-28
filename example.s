	li x1 l_stack_begin
	li x2 p_main
	jal x2 x2
	ehlt
p_readval:
	li x3 1
	add x1 x1 x3
	li x3
	l x3 x3
	eread x4
	s x4 x3
while_0_begin:
	li x3
	l x3 x3
	l x3 x3
	li x4 48
	lt x3 x3 x4
	li x4 57
	li x5
	l x5 x5
	l x5 x5
	lt x4 x4 x5
	or x3 x3 x4
	li x4 while_0_end
	beq x0 x3 x4
	li x3
	l x3 x3
	eread x4
	s x4 x3
	li x3 while_0_begin
	jal x0
while_0_end:
	li x3
	l x3 x3
	li x4 0
	s x4 x3
while_1_begin:
	li x3 47
	li x4
	l x4 x4
	l x4 x4
	lt x3 x3 x4
	li x4
	l x4 x4
	l x4 x4
	li x5 58
	lt x4 x4 x5
	and x3 x3 x4
	li x4 while_1_end
	beq x0 x3 x4
	li x3
	l x3 x3
	li x4 10
	li x5
	l x5 x5
	l x5 x5
	mul x4 x4 x5
	li x5
	l x5 x5
	l x5 x5
	add x4 x4 x5
	s x4 x3
	li x3
	l x3 x3
	eread x4
	s x4 x3
	li x3 while_1_begin
	jal x0
while_1_end:
	jal x0 x2
p_writeval:
	li x3 12
	add x1 x1 x3
	li x3
	l x3 x3
	li x4
	l x4 x4
	l x4 x4
	li x5 0
	lt x4 x4 x5
	s x4 x3
	li x3
	l x3 x3
	l x3 x3
	li x4 0
	lt x3 x3 x4
	li x4 if_2_false
	beq x0 x3 x4
	li x3
	l x3 x3
	li x4
	l x4 x4
	l x4 x4
	sub x4 x0 x4
	s x4 x3
if_2_false:
if_2060314160_end:
	li x3
	l x3 x3
	l x3 x3
	li x4 0
	eq x3 x3 x4
	li x4 if_3_false
	beq x0 x3 x4
	li x3 48
	ewrite x3
	li x3 if_3_end
	jal x0 x3
if_3_false:
	li x3
	l x3 x3
	li x4 10
	s x4 x3
while_4_begin:
	li x3
	l x3 x3
	l x3 x3
	li x4 while_4_end
	beq x0 x3 x4
	li x3
	l x3 x3
	li x4
	l x4 x4
	li x5 1
	sub x4 x4 x5
	s x4 x3
	li x3
	l x3 x3
	li x4
	l x4 x4
	add x3 x3 x4
	li x4 48
	li x5
	l x5 x5
	l x5 x5
	li x6 10
	mod x5 x5 x6
	add x4 x4 x5
	s x4 x3
	li x3
	l x3 x3
	li x4
	l x4 x4
	l x4 x4
	li x5 10
	div x4 x4 x5
	s x4 x3
	li x3 while_4_begin
	jal x0
while_4_end:
	li x3
	l x3 x3
	li x4 if_5_false
	beq x0 x3 x4
	li x3 45
	ewrite x3
if_5_false:
if_2060314160_end:
while_6_begin:
	li x3
	l x3 x3
	l x3 x3
	li x4 10
	lt x3 x3 x4
	li x4 while_6_end
	beq x0 x3 x4
	li x3
	l x3 x3
	li x4
	l x4 x4
	add x3 x3 x4
	l x3 x3
	ewrite x3
	li x3
	l x3 x3
	li x4
	l x4 x4
	li x5 1
	add x4 x4 x5
	s x4 x3
	li x3 while_6_begin
	jal x0
while_6_end:
if_2060314160_end:
	jal x0 x2
p_main:
	li x3 2
	add x1 x1 x3
	s x2 x1
	li x3 1
	add x1 x1 x3
	li x3
	l x3 x3
	s x3 x1
	li x4 1
	add x1 x1 x4
	li x2 p_readval
	jal x2 x2
	li x3 0
	sub x1 x1 x3
	li x3 1
	sub x1 x1 x3
	l x2 x1
	s x2 x1
	li x3 1
	add x1 x1 x3
	li x3
	l x3 x3
	s x3 x1
	li x4 1
	add x1 x1 x4
	li x2 p_readval
	jal x2 x2
	li x3 0
	sub x1 x1 x3
	li x3 1
	sub x1 x1 x3
	l x2 x1
	s x2 x1
	li x3 1
	add x1 x1 x3
	li x3
	l x3 x3
	l x3 x3
	li x4
	l x4 x4
	l x4 x4
	add x3 x3 x4
	s x3 x1
	li x4 1
	add x1 x1 x4
	li x2 p_writeval
	jal x2 x2
	li x3 0
	sub x1 x1 x3
	li x3 1
	sub x1 x1 x3
	l x2 x1
	li x3 10
	ewrite x3
	jal x0 x2
l_stack_begin:
