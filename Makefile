build: lexer parser ast.c ast.h
	$(CC) *.c -lfl -lm -o main

clean:
	rm -f main lex.yy.c lex.yy.h parser.tab.c parser.tab.h

lexer: lexer.l parser
	flex --header-file=lex.yy.h lexer.l

parser: parser.y
	bison -d -Wcounterexamples parser.y
