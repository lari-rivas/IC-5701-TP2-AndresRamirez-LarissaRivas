parser:		lex.yy.o y.tab.o
			gcc -o parser lex.yy.o y.tab.o  -ly -ll

lex.yy.c:	parser.l y.tab.c
			flex parser.l

y.tab.c:	parser.y
			bison -vdty parser.y

clean:
	rm -f parser lex.yy.o y.tab.o y.tab.c y.tab.h lex.yy.c y.output