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

char * cat(char *, char *, char *, char *, char *);

%}

%union {
    char * sValue;  /* string value */
    struct record * rec;
 };

%token <sValue> ID
%token <sValue> TYPE 
%token <sValue> NUMBER 
%token <sValue> STRING 
%token FUNC ENDFUNC WHILE ENDWHILE IF ELSE ENDIF ASSIGNMENT FOR ENDFOR EQUALS RETURN BREAK
NOT_EQUALS GREATER_THAN LESS_THAN GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL OP_PLUS OP_MINUS 
OP_DIV OP_MULT LBRACKET RBRACKET DECREMENT INCREMENT SUBTRACTION_ASSIGNMENT ADITION_ASSIGNMENT LOGICAL_AND LOGICAL_OR PRINT SCAN OP_EXP

%type <rec> instructions
%type <rec> procedimento
%type <rec> funcao
%type <rec> subp expression
%type <rec> subps args args_aux var_declarations var_list variable conditional_if print texts text escape


%start programa

%%
programa : subps instructions {

                              }
    ;

subps :             {$$ = createRecord("","");} 
       | subp subps {}
      ;

subp : funcao       {}
     | procedimento {}
     ;

funcao : FUNC TYPE ID '(' args ')' instructions escape ENDFUNC  {}
       ;

procedimento : FUNC ID '(' args ')' instructions ENDFUNC {} 
             ;


escape:   BREAK escape {}
        | RETURN expression escape {}
        | RETURN escape {}
        | {}
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
              | scan instructions {}
              | call_functions instructions {}
          ;

var_declarations : TYPE var_list {} ;

var_list : variable ',' var_list
          | variable
          ;

variable : ID           {$$ = createRecord($1, "");
                        free($1);
                        }
        | ID LBRACKET ID RBRACKET   {}
        | ID ASSIGNMENT expression  {}
        | ID LBRACKET ID RBRACKET ASSIGNMENT expression  {}
 ;

 call_functions : ID '(' params ')'

 params :   ID params {}
          | ID ',' params {}
          | {}
          ;


expression : ID 	{$$ = createRecord($1, "");
                    free($1);
                  }
            | ID ASSIGNMENT expression  {}
            | ID OP_PLUS expression {}
            | ID OP_MINUS expression {}
            | ID OP_DIV expression {}
            | ID OP_MULT expression {}
	          | ID OP_EXP expression  {}

            | ID LESS_THAN expression {}
            | ID GREATER_THAN expression {}
            | ID EQUALS expression {}
            | ID LESS_THAN_OR_EQUAL expression {}
            | ID GREATER_THAN_OR_EQUAL expression {}
            | ID NOT_EQUALS expression {}
            

            | ID LOGICAL_AND expression {}
            | ID LOGICAL_OR expression {}
            
            ;

direct_assignment : ID ASSIGNMENT expression { //$1 recebe $3, e $$ recebe $1 ?
		  }
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

print : PRINT '(' texts ')' {char * spointer = cat("print", "(", $3->code, ")", "");
      				freeRecord($3);
				$$ = createRecord(spointer, "");
				};

texts :  text {$$ = $1;}
      | text ',' texts {char * spointer = cat($1->code, ",", $3->code, "", "");
			freeRecord($1);
			freeRecord($3);
			$$ = createRecord(spointer, "");
			free(spointer);
			}
;
text :   {$$ = createRecord("","");}
	| STRING {$$ = createRecord($1, "");
		free($1);} 
	| ID {$$ = createRecord($1, "");
		free($1);}     
;

scan : SCAN '(' scan_list ')' ;

scan_list : TYPE ID
	  | TYPE ID ',' scan_list
;

%%

int main (int argc, char ** argv) {
  int codigo;

    if (argc != 3) {
       printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
       exit(0);
    }
    
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");

    codigo = yyparse();

    fclose(yyin);
    fclose(yyout);

	return codigo;
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}
char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5)+ 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}
