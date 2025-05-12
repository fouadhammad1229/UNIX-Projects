%{
#include <stdio.h>
#include <string.h>

/*
 Name: Fouad Hammad
 Assignment:  C Pretty Printer Lex Specification 
 Purpose: To create a lex specfication file to make C files look "pretty".
*/

// Reserved keywords list
char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue",
    "default", "do", "double", "else", "extern", "float",
    "for", "goto", "if", "int", "long", "register",
    "return", "short", "signed", "sizeof", "static",
    "struct", "switch", "typedef", "union", "unsigned",
    "void", "volatile", "while", NULL
};

// Check if a word is a C reserved keyword
int is_keyword(const char *word) {
    for (int i = 0; keywords[i]; i++) {
        if (strcmp(keywords[i], word) == 0)
            return 1;
    }
    return 0;
}


%}

%x COMMENT
%%

"/*"                { printf("\\f(CI%s", yytext); BEGIN(COMMENT); }
<COMMENT>"*/"       { printf("%s\\f(CR", yytext); BEGIN(INITIAL); }
<COMMENT>.|\n       { ECHO; }


"//".*              { printf("\\f(CI%s\\f(CR", yytext); }
\"([^\\\"]|\\.)*\"  { printf("\\fB%s\\f(CR", yytext); }
\'([^\\\']|\\.)*\'  { printf("\\fI%s\\f(CR", yytext); }
[0-9]+              { printf("\\f5%s\\f(CR", yytext); }


[a-zA-Z_][a-zA-Z0-9_]* {
    if (is_keyword(yytext)) {
        printf("\\f(CB%s\\f(CR", yytext);
    } else {
        printf("%s", yytext);
    }
}
\n                  { putchar('\n'); }
.                   { printf("%s", yytext); }


%%
int main() {
    // Initial font setup
    printf(".fp 5 CBI\n");
    printf(".ft CR\n");
    printf(".nf\n");
    yylex();
    return 0;
}
