%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
%}

%union {
  int    iValue;  /* integer value */
  char   cValue;  /* char value */
  char * sValue;  /* string value */
};

%token <sValue> ID
%token <sValue> TYPE 
%token <iValue> NUMBER
%token FUNC ENDFUNC WHILE ENDWHILE IF ELSE ENDIF ASSIGNMENT FOR ENDFOR EQUALS NOT_EQUALS GREATER_THAN LESS_THAN GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL ADITION_ASSIGNMENT OP_PLUS

%type <sValue> corpo
%type <sValue> procedimento
%type <sValue> funcao
%type <sValue> subp
%type <sValue> subps args args_aux ids ids_aux


%start programa

%%
programa : subps corpo {/*printf("%s%s\n", $1, $2);
                        free($1);
                        free($2);*/}
    ;

subps :             {$$ = strdup("");} 
       | subp subps {/*int n1 = strlen($1);
                     int n2 = strlen($2);
                     char * s = malloc(sizeof(char)*(n1+n2+2));
                     sprintf(s, "%s\n%s", $1, $2);
                     free($1);
                     free($2);
                     $$ = s;*/}
      ;

subp : funcao       {$$ = $1;}
     | procedimento {$$ = $1;}
     ;

funcao : FUNC TYPE ID '(' args ')' corpo ENDFUNC  {/*int n1 = strlen($3);
                                                  int n2 = strlen($5);
                                                  int n3 = strlen($2);
                                                  int n4 = strlen($7);
                                                  char * s = malloc(sizeof(char)*(n1+n2+n3+n4+12));
                                                  sprintf(s, "FUNC %s(%s) : %s %s", $3, $5, $2, $7);
                                                  free($3);
                                                  free($5);
                                                  free($2);
                                                  free($7);
                                                  $$ = s;*/}
       ;

procedimento : FUNC ID '(' args ')' corpo       {int n1 = strlen($2);
                                                int n2 = strlen($4);
                                                int n3 = strlen($6);
                                                char * s = malloc(sizeof(char)*(n1+n2+n3));
                                                sprintf(s, "PROCEDURE %s() %s", $2, $6);
                                                free($2);
                                                free($6);
                                                $$ = s;} 
             ;

args :          {$$ = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ids               {int n1 = strlen($1);
                                   int n2 = strlen($2);
                                   char * s = malloc(sizeof(char) * (n1+n2+2));
                                   sprintf(s,"%s %s", $1, $2);
                                   free($1);
                                   free($2);
                                   $$ = s;}
         | TYPE ids ';' args_aux {int n1 = strlen($1);
                                  int n2 = strlen($2);
                                  int n3 = strlen($4);
                                  char * s = malloc(sizeof(char) * (n1+n2+n3+4));
                                  sprintf(s,"%s %s; %s", $1, $2, $4);
                                  free($1);
                                  free($2);
                                  free($4);
                                  $$ = s;}
         ;

ids :         {$$ = strdup("");}
    | ids_aux {$$ = $1;}
    ;

ids_aux : ID             {$$ = $1;}
        | ID ',' ids_aux {int n1 = strlen($1);
                          int n2 = strlen($3);
                          char * s = malloc(sizeof(char) * (n1+n2+3));
                          sprintf(s,"%s, %s", $1, $3);
                          free($1);
                          free($3);
                          $$ = s;}
        ;

//corpo : var_declarations {}    dessa forma o corpo da função só poderia ter declaração de variáveis OU declaração de método. 
//        | method_declaration
//	|  
//      ;

corpo : blocks
      |
	;

blocks : block
       | block blocks
	;

block : var_declarations
      | method_declaration
	| instructions
  | IF '(' ID logic_operator NUMBER ')' instructions ELSE instructions ENDIF
  | for_loop
	;

var_declarations : TYPE var_list ;

var_list : variable ',' var_list
        | variable
        ;

variable : ID
	| ID ASSIGNMENT NUMBER 	
  | ID ASSIGNMENT ID
 ;

method_declaration : while_loop ;
//		| for_loop
//		;

while_loop : WHILE '(' ID logic_operator NUMBER ')' instructions ENDWHILE ;
	

instructions: var_declarations
          | aritimetic_operations
	  | direct_assignment
    | if_statement
    | for_loop
          ;

if_statement : IF '(' ID logic_operator NUMBER ')' instructions ENDIF
             | IF '(' ID logic_operator NUMBER ')' instructions ELSE instructions ENDIF
             ;

for_loop : FOR '(' ID ASSIGNMENT NUMBER ';' ID logic_operator NUMBER ';' ID ADITION_ASSIGNMENT NUMBER ')' instructions ENDFOR
         ;


//	  | logical_operations

direct_assignment : ID ASSIGNMENT NUMBER ;

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


%%

int main (void) {
  return yyparse();
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}
