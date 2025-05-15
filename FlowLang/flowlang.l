%{
#include "flowlang.tab.h"
#include <string.h>
int line_num = 1;
%}
%%
"BEGIN"       { return BEGIN_PROGRAM; }
"CLOSE"       { return END_PROGRAM; }
"set"         { return SET; }
"let"         { return LET; }
"if"          { return IF; }
"then"        { return THEN; }
"else"        { return ELSE; }
"while"       { return WHILE; }
"do"          { return DO; }
"end"         { return END; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return TIMES; }
"/"           { return DIVIDE; }
"="           { return ASSIGN; }
"<"           { return LT; }
">"           { return GT; }
"=="          { return EQ; }
"!="          { return NE; }
"<="          { return LE; }
">="          { return GE; }
"{"           { return '{'; }
"}"           { return '}'; }
"("           { return '('; }
")"           { return ')'; }
[0-9]+        { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID; }
[ \t]         ;   // skip whitespace
\n            { line_num++; }  
.             { printf("Unknown character: %s\n", yytext); }
%%
int yywrap() {
    return 1;
}