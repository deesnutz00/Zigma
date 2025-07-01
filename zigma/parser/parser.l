%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);

%}

%option noyywrap

digit       [0-9]
letter      [a-zA-Z]
id          {letter}({letter}|{digit})*
integer     {digit}+
real        {digit}+\.{digit}+
whitespace  [ \t\n]

%%

"if"        { return IF; }
"else"      { return ELSE; }
"=="        { return EQ; }
"!="        { return NE; }
"<"         { return LT; }
"<="        { return LE; }
">"         { return GT; }
">="        { return GE; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
"="         { return ASSIGN; }

{integer}   { yylval.num = atoi(yytext); return INTEGER; }
{real}      { yylval.fnum = atof(yytext); return REAL; }
{id}        { yylval.id = strdup(yytext); return ID; }

{whitespace} { /* skip whitespace */ }
.           { yyerror("Invalid character"); }

%%