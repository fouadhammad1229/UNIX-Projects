cpretty: lex.yy.c
	gcc -g -o cpretty lex.yy.c -lfl

lex.yy.c: cpretty.l
	lex cpretty.l

clean:
	rm -f cpretty lex.yy.c *.tr *.ps *.pdf

