%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int line_num;
void yyerror(const char *s);

// Function to generate new temporary variables
char* newTemp();

// Function to generate new labels
char* newLabel();

int tempCount = 1;  // Counter for temporary variables
int labelCount = 1; // Counter for labels

%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token BEGIN_PROGRAM END_PROGRAM SET LET IF THEN ELSE WHILE DO END
%token PLUS MINUS TIMES DIVIDE ASSIGN LT GT EQ NE LE GE

%type <str> expr term factor condition

/* Precedence rules to avoid shift/reduce conflicts */
%left PLUS MINUS
%left TIMES DIVIDE

%%

program
    : BEGIN_PROGRAM {
        fprintf(yyout, "BEGIN\n");
    } 
    statement_list END_PROGRAM {
        fprintf(yyout, "CLOSE\n");
    }
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : variable_decl
    | assignment_stmt
    | if_stmt
    | while_stmt
    ;

variable_decl
    : SET ID ASSIGN expr {
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    | LET ID ASSIGN expr {
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

assignment_stmt
    : ID ASSIGN expr {
        fprintf(yyout, "%s = %s\n", $1, $3);
    }
    ;

if_stmt
    : IF '(' condition ')' THEN '{' {
        char* true_label = newLabel();
        char* false_label = newLabel();
        char* end_label = newLabel();
        
        fprintf(yyout, "if %s goto %s\n", $3, true_label);
        fprintf(yyout, "goto %s\n", false_label);
        fprintf(yyout, "%s:\n", true_label);
    } 
    statement_list '}' ELSE '{' {
        char* end_label = newLabel();
        fprintf(yyout, "goto %s\n", end_label);
        fprintf(yyout, "L%d:\n", labelCount - 2); // false_label
    }
    statement_list '}' {
        fprintf(yyout, "L%d:\n", labelCount - 1); // end_label
    }
    ;

while_stmt
    : WHILE {
        char* loop_start = newLabel();
        fprintf(yyout, "%s:\n", loop_start);
    }
    condition DO {
        char* body_label = newLabel();
        char* end_label = newLabel();
        fprintf(yyout, "if %s goto %s\n", $3, body_label);
        fprintf(yyout, "goto %s\n", end_label);
        fprintf(yyout, "%s:\n", body_label);
    }
    statement_list END {
        fprintf(yyout, "goto L%d\n", labelCount - 3); // loop_start
        fprintf(yyout, "L%d:\n", labelCount - 1);    // end_label
    }
    ;

condition
    : expr LT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr GT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr EQ expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s == %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr NE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s != %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr LE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s <= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr GE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s >= %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

expr
    : expr PLUS term {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MINUS term {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | term {
        $$ = $1;
    }
    ;

term
    : term TIMES factor {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | term DIVIDE factor {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    | factor {
        $$ = $1;
    }
    ;

factor
    : ID {
        $$ = $1;
    }
    | NUMBER {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s\n", temp, $1);
        $$ = temp;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    ;

%%

char* newTemp() {
    char* buffer = malloc(10);
    sprintf(buffer, "t%d", tempCount++);
    return buffer;
}

char* newLabel() {
    char* buffer = malloc(10);
    sprintf(buffer, "L%d", labelCount++);
    return buffer;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    
    if (!yyin) {
        fprintf(stderr, "Could not open input.txt\n");
        return 1;
    }
    
    if (!yyout) {
        fprintf(stderr, "Could not create output.txt\n");
        return 1;
    }
    
    yyparse();
    
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}