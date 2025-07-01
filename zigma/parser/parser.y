%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

struct symbol {
    char *name;
    double value;
};

#define NHASH 9997
struct symbol symtab[NHASH];
struct symbol *lookup(char*);

void print_value(const char* name, double value) {
    if (value == (int)value) {
        printf("%s = %d (Big Numbers)\n", name, (int)value);
    } else {
        printf("%s = %.2f (lowkey)\n", name, value);
    }
}

%}

%union {
    int num;
    double fnum;
    char *id;
}

%token <num> INTEGER
%token <fnum> REAL
%token <id> ID
%token IF ELSE
%token EQ NE LT LE GT GE
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN LBRACE RBRACE
%token SEMICOLON ASSIGN

%type <fnum> expression condition

%nonassoc IF
%nonassoc ELSE
%left EQ NE LT LE GT GE
%left PLUS MINUS
%left TIMES DIVIDE

%%

program:
    /* empty */
    | program statement
    ;

statement:
    expression SEMICOLON { 
        printf("Expression result: ");
        if ($1 == (int)$1) {
            printf("%d (Big Numbers)\n", (int)$1);
        } else {
            printf("%.2f (lowkey)\n", $1);
        }
    }
    | if_statement
    | ID ASSIGN expression SEMICOLON { 
        lookup($1)->value = $3;
        printf("Assignment: ");
        print_value($1, $3);
    }
    ;

if_statement:
    IF LPAREN condition RPAREN statement %prec IF {
        printf("Checkin vibes...\n");
    }
    | IF LPAREN condition RPAREN statement ELSE statement {
        printf("If-else statement executed\n");
    }
    ;

condition:
    expression EQ expression { 
        $$ = ($1 == $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    | expression NE expression { 
        $$ = ($1 != $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    | expression LT expression { 
        $$ = ($1 < $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    | expression LE expression { 
        $$ = ($1 <= $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    | expression GT expression { 
        $$ = ($1 > $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    | expression GE expression { 
        $$ = ($1 >= $3);
        printf("Comparison: ");
        print_value("left", $1);
        print_value("right", $3);
        printf("Result: %s\n", $$ ? "true" : "false"); 
    }
    ;

expression:
    INTEGER { 
        $$ = $1;
        printf("Integer number : %d\n", $1); 
    }
    | REAL { 
        $$ = $1;
        printf("float number : %.2f\n", $1); 
    }
    | ID { 
        $$ = lookup($1)->value; 
        printf("Variable access: ");
        print_value($1, $$);
    }
    | LPAREN expression RPAREN { $$ = $2; }
    | expression PLUS expression { 
        $$ = $1 + $3;
        printf("Arithmetic operation: ");
        print_value("operand1", $1);
        print_value("operand2", $3);
        print_value("result", $$); 
    }
    | expression MINUS expression { 
        $$ = $1 - $3;
        printf("Arithmetic operation: ");
        print_value("operand1", $1);
        print_value("operand2", $3);
        print_value("result", $$); 
    }
    | expression TIMES expression { 
        $$ = $1 * $3;
        printf("Arithmetic operation: ");
        print_value("operand1", $1);
        print_value("operand2", $3);
        print_value("result", $$); 
    }
    | expression DIVIDE expression { 
        $$ = $1 / $3;
        printf("Arithmetic operation: ");
        print_value("operand1", $1);
        print_value("operand2", $3);
        print_value("result", $$); 
    }
    ;

%%

struct symbol *lookup(char *sym) {
    struct symbol *sp = &symtab[0];
    while (sp->name && strcmp(sp->name, sym)) sp++;
    if (!sp->name) {
        sp->name = strdup(sym);
        sp->value = 0;
    }
    return sp;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Compiling Aura...\n");
    int result = yyparse();
    printf("Parsing completed.\n");
    return result;
}