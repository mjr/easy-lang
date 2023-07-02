all: compile

compile: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c ./lib/record.c -o compiler

lex.yy.c: lexicon.l
	lex lexicon.l

y.tab.c: syntactic.y
	yacc syntactic.y -d -v

clean:
	rm -rf lex.yy.c y.tab.* compiler output.txt y.output
