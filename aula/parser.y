%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern FILE * yyin, * yyout;
%}

//char * cat(char *, char *, char *, char *, char *);

//%}

%union {
    char * sValue;  /* string value */
    struct record * rec;
 };

%token <sValue> ID
%token <sValue> TYPE 
%token <sValue> NUMBER 
%token <sValue> STRING 
%token FUNC ENDFUNC WHILE ENDWHILE IF ELSE ENDIF ASSIGNMENT FOR ENDFOR EQUALS 
NOT_EQUALS GREATER_THAN LESS_THAN GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL OP_PLUS OP_MINUS 
OP_DIV OP_MULT LBRACKET RBRACKET DECREMENT INCREMENT SUBTRACTION_ASSIGNMENT ADITION_ASSIGNMENT LOGICAL_AND LOGICAL_OR PRINT

%type <rec> instructions
%type <rec> procedimento
%type <rec> funcao
%type <rec> subp expression
%type <rec> subps args args_aux var_declarations var_list variable conditional_if


%start programa

%%
programa : subps instructions {}
    ;

subps :             {} 
       | subp subps {}
      ;

subp : funcao       {}
     | procedimento {}
     ;

funcao : FUNC TYPE ID '(' args ')' instructions ENDFUNC  {}
       ;

procedimento : FUNC ID '(' args ')' instructions ENDFUNC {} 
             ;

args :             {}
        | args_aux {}
     ;

args_aux :    TYPE ID               {}
            | TYPE ID LBRACKET RBRACKET ',' args_aux  {}
            | TYPE ID ',' args_aux  {}
         ;


instructions:   {}
              | var_declarations instructions {}
              | direct_assignment instructions {}
              | unary_op instructions {}
              | conditional_if instructions {}
              | while_loop instructions {}
              | for_loop instructions {}
	      | print instructions {}
          ;

var_declarations : TYPE var_list {} ;

var_list : variable ',' var_list
          | variable
          ;

variable : ID                        {}
        | ID LBRACKET ID RBRACKET   {}
        | ID ASSIGNMENT expression  {}
        | ID LBRACKET ID RBRACKET ASSIGNMENT expression  {}
 ;

expression : ID {}
            | ID ASSIGNMENT expression  {}
            | ID OP_PLUS expression {}
            | ID OP_MINUS expression {}
            | ID OP_DIV expression {}
            | ID OP_MULT expression {}

            | ID LESS_THAN expression {}
            | ID GREATER_THAN expression {}
            | ID EQUALS expression {}
            | ID LESS_THAN_OR_EQUAL expression {}
            | ID GREATER_THAN_OR_EQUAL expression {}
            | ID NOT_EQUALS expression {}
            

            | ID LOGICAL_AND expression {}
            | ID LOGICAL_OR expression {}
            
            ;

direct_assignment : ID ASSIGNMENT expression {}
      ;

unary_op :  ID ADITION_ASSIGNMENT
          | ID INCREMENT
          | ID DECREMENT
          | ID SUBTRACTION_ASSIGNMENT
  ;


conditional_if : IF '(' expression ')' instructions ENDIF {}
                | IF '(' expression ')' instructions ELSE instructions ENDIF {}

while_loop : WHILE '(' expression ')' instructions ENDWHILE {};

for_loop : FOR '(' var_declarations ';' expression ';' unary_op ')' instructions ENDFOR; // validar o var_declarations com o professor

print : PRINT '(' texts ')' {} ;

texts :  text {}
      | text ',' texts {}
;
text :   {}
	| STRING {} 
	| ID {}     
;


%%

int main (void) {
  return yyparse();
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}
