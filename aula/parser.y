%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
%}

//char * cat(char *, char *, char *, char *, char *);

//%}

%union {
    char * sValue;  /* string value */
    struct record * rec;
 };

%token <sValue> ID
%token <sValue> TYPE 
%token <iValue> NUMBER
%token FUNC ENDFUNC WHILE ENDWHILE IF ELSE ENDIF ASSIGNMENT FOR ENDFOR EQUALS 
NOT_EQUALS GREATER_THAN LESS_THAN GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL OP_PLUS OP_MINUS 
OP_DIV OP_MULT LBRACKET RBRACKET DECREMENT INCREMENT SUBTRACTION_ASSIGNMENT ADITION_ASSIGNMENT LOGICAL_AND LOGICAL_OR

%type <rec> instructions
%type <rec> procedimento
%type <rec> funcao
%type <rec> subp expression
%type <rec> subps args args_aux ids ids_aux var_declarations var_list variable


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

procedimento : FUNC ID '(' args ')' instructions       {} 
             ;

args :          {}
     | args_aux {}
     ;

args_aux : TYPE ids               {}
         | TYPE ids ';' args_aux {}
         ;

ids :         {}
    | ids_aux {}
    ;

ids_aux : ID             {}
        | ID ',' ids_aux {}
        ;


instructions:   var_declarations
//            | aritimetic_operations
//            | direct_assignment
//            | if_statement
//            | while_loop
//            | for_loop
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

expression : ID ASSIGNMENT expression  {$$ = createRecord("","");}
            | ID LBRACKET expression RBRACKET {}
            | ID {}
//            | logical_expression  {}
//            | aritimetic_expression  {}
            ;



/*logical_expression :  logical_expression LESS_THAN logical_expression
                    | logical_expression GREATER_THAN logical_expression
                    | logical_expression EQUALS logical_expression
                    | logical_expression LESS_THAN_OR_EQUAL logical_expression
                    | logical_expression GREATER_THAN_OR_EQUAL logical_expression
                    | ID
                    | NUMBER
                    ;


aritimetic_expression : aritimetic_expression OP_PLUS aritimetic_expression
                      | aritimetic_expression OP_MINUS aritimetic_expression
                      | aritimetic_expression OP_DIV aritimetic_expression
                      | aritimetic_expression OP_MULT aritimetic_expression
                      ;


while_loop : WHILE '(' conditions ')' corpo ENDWHILE ;


conditions : expression
            | expression relational_expression expression
            ;

relational_expression : LOGICAL_AND
                      | LOGICAL_OR
                      ;



if_statement : IF '(' conditions ')' instructions ENDIF
             | IF '(' conditions ')' instructions ELSE instructions ENDIF
             ;

for_loop : FOR '(' ID ASSIGNMENT expression ';' ID logic_operator expression ';' ID unary_op ')' corpo ENDFOR
         ;


unary_op : ADITION_ASSIGNMENT
        | INCREMENT
        | DECREMENT
        | SUBTRACTION_ASSIGNMENT
        ;

//	  | logical_operations

direct_assignment : ID ASSIGNMENT expression 
                  | ID LBRACKET ID RBRACKET ASSIGNMENT expression
                  | ID unary_op
                  ;

aritimetic_operations : sum 
		| ID ASSIGNMENT sum		      
		;
//		| subtraction
//		| multiplication
//		| division
//		;



sum : ID OP_PLUS NUMBER
    | ID OP_PLUS ID
    | ID ADITION_ASSIGNMENT NUMBER
    ;

logic_operator : EQUALS
               | NOT_EQUALS
                |GREATER_THAN
                |LESS_THAN
                |GREATER_THAN_OR_EQUAL
                |LESS_THAN_OR_EQUAL
                ;

*/
%%

int main (void) {
  return yyparse();
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}
