%{
    #include <stdlib.h>
    #include <string.h>
    int total_keys = 0, total_id = 0, total_functions = 0, total_strings = 0, total_includes = 0, total_chars = 0;
%}

%option noyywrap
%x MLC

keyword                 yeet|big_numbers|lowkey|lil_fella|drip|fax|slide|orNah|fr?|ong|justlikethat?|rizz|empty_vibe|vibecheck|big_yikes|on_repeat|until_further_notice|cap|noCap|sus|glowup|stan|clout
function                yapp|grab|master_chief
digit                   [0-9]
string                  \"([^\\\"]|\\.)*\"
char                    '([^\\']|\\.)'
rel_op                  >=|<=|==|>|<
arithmetic_op           \+|\-|\*|\/|\%|\+\+|\-\-
assign_op               =|\+=|\-=|\*=|\/=|\%=
logical_op              \&\&|\|\||!
delimiter               \{|\}|\[|\]|\(|\)|;|,|'
id                      [_a-zA-Z][_a-zA-Z0-9]*

%%

\/\*                    { BEGIN(MLC); }  

<MLC>[^*]+              { printf("Multi-line Comment: %s\n", yytext); }

<MLC>\*+[^*\/]+         { printf("Multi-line Comment: %s\n", yytext); }

<MLC>\*+\/              { BEGIN(INITIAL); }  /* End comment */

\/\/.*                   { printf("Single-line Comment: %s\n", yytext); }

#include[ \t]*<([^>]+)> { printf("Library Included: %s\n", yytext + 9); 
                          total_includes++; }

\"[^\"]*$               { printf("Error: Unfinished string: %s\n", yytext); }

{keyword}               { printf("Keyword: %s\n", yytext); 
                          total_keys++; }

{function}              { printf("Function: %s\n", yytext); 
                          total_functions++; }

{string}                { printf("String: %s\n", yytext); 
                          total_strings++; }

{char}                  { printf("Character: %s\n", yytext); 
                          total_chars++; }

{id}[ \t]*\([^)]*\)     { printf("Function Call: %s\n", yytext); 
                          total_functions++; }

{id}                    { printf("Identifier: %s\n", yytext); 
                          total_id++; }           

[-]?{digit}+            { printf("Integer Number: %s\n", yytext); }

[-]?{digit}*[.]{digit}+ { printf("Float Number: %s\n", yytext); }

{rel_op}                { printf("Relational Operator: %s\n", yytext); }

{assign_op}             { printf("Assignment Operator: %s\n", yytext); }

{logical_op}            { printf("Logical Operator: %s\n", yytext); }

{arithmetic_op}         { printf("Arithmetic Operator: %s\n", yytext); }

{delimiter}             { printf("Delimiter: %s\n", yytext); }

[ \t\n\r]+              ;

.                       { printf("Error: Unexpected character '%s' (ASCII: %d)\n", yytext, yytext[0]); }

%%

int main(){
    FILE* fp = fopen("vibecheck.txt", "r");
    if (!fp) {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }

    yyin = fp;
    yylex();
    fclose(fp);

    printf("Total Keywords: %d\n", total_keys);
    printf("Total Identifiers: %d\n", total_id);
    printf("Total Functions: %d\n", total_functions);
    printf("Total Strings: %d\n", total_strings);
    printf("Total Characters: %d\n", total_chars);
    printf("Total Libraries: %d\n", total_includes);
    return 0;
}