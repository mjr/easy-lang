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

char * cat(char *, char *, char *, char *, char *, char *, char*);

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
OP_DIV OP_MULT LBRACKET RBRACKET DECREMENT INCREMENT SUBTRACTION_ASSIGNMENT ADITION_ASSIGNMENT LOGICAL_AND LOGICAL_OR PRINT SCAN OP_EXP LOGICAL_NOT

%type <rec> instructions
%type <rec> procedimento
%type <rec> funcao
%type <rec> subp expression
%type <rec> subps args args_aux var_declarations var_list variable conditional_if print texts text escape direct_assignment unary_op while_loop for_loop scan call_functions params



%start programa

%%
programa : subps instructions {

                              }
    ;

subps :             {$$ = createRecord("","");} 
       | subp subps {
	  char * s = cat($1->code, "\n", $2->code, "", "", "", "");
          freeRecord($1);
          freeRecord($2);
          $$ = createRecord(s, "");
          free(s);
	  };

subp : funcao       {
          char * s = cat($1->code, "", "", "", "", "", "");
          freeRecord($1);
          $$ = createRecord(s, "");
          free(s);}
     | procedimento {
	  char * s = cat($1->code, "", "", "", "", "", "");
          freeRecord($1);
          $$ = createRecord(s, "");
          free(s);}
     ;

funcao : FUNC TYPE ID '(' args ')' instructions escape ENDFUNC  {
			char * s = cat($2, $3, "(", $5->code, ")", $7->code, $8->code);
              	        free($2);
          		free($3);
          		freeRecord($5);
          		freeRecord($7);
          		freeRecord($8);
			$$ = createRecord(s, "");
			free(s);
			};
 
procedimento : FUNC ID '(' args ')' instructions ENDFUNC {
                        char * s = cat($2, "(", $4->code, ")", $6->code, "", "");
                        free($2);
                        freeRecord($4);
                        freeRecord($6);
                        $$ = createRecord(s, "");
                        free(s);	     
			};


escape:   BREAK escape {}
        | RETURN expression escape {}
        | RETURN escape {}
        | {}
        ;

args :             {$$ = createRecord("","");}
        | args_aux {
		   $$ = $1;
		   };

args_aux :    TYPE ID               {char * s = cat($1, $2, "", "", "", "", "");
	  			    free($1);
				    free($2);
				    $$ = createRecord(s, "");
				    free(s);
				    }
            | TYPE ID LBRACKET RBRACKET ',' args_aux  {
				    char * s = cat($1, $2, "[", "]", ",", $6->code, "");
                                    free($1);
                                    free($2);
				    freeRecord($6);
                                    $$ = createRecord(s, "");
                                    free(s);
				    }
            | TYPE ID ',' args_aux  {
				    char * s = cat($1, $2, ",", $4->code, "", "", "");
				    free($1);
				    free($2);
				    freeRecord($4);
				    $$ = createRecord(s, "");
				    free(s);
				    };


instructions:   {$$ = createRecord("", "");}
              | var_declarations instructions {
				char * s = cat($1->code, $2->code, "", "", "", "", "");
				freeRecord($1);
				freeRecord($2);
				$$ = createRecord(s, "");
				free(s);	
				}
              | direct_assignment instructions {
      			        char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, ""); 
				}
              | unary_op instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | conditional_if instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | while_loop instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | for_loop instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | print instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | scan instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                }

              | call_functions instructions { 
                                char * s = cat($1->code, $2->code, "", "", "", "", "");
                                freeRecord($1);
                                freeRecord($2);
                                $$ = createRecord(s, "");
                                };

var_declarations : TYPE var_list {
				char *s = cat($1, $2->code, "", "", "", "", "");
				free ($1);
				freeRecord($2);
				$$ = createRecord(s, "");
				free(s);		 
} ;

var_list : variable ',' var_list {
				char *s = cat($1->code, ",", $3->code, "", "", "", "");
				freeRecord($1);
				freeRecord($3);
				$$ = createRecord(s, "");
				free(s);	 
				}
          | variable {
//				char *s = cat($1->code, "", "", "", "", "", "");  
//                                freeRecord($1);
//                                $$ = createRecord(s, "");
//                                free(s);
				$$ = createRecord($1->code, "");
				}
          ;

variable : ID           {$$ = createRecord($1, "");
                        free($1);
                        }
        | ID LBRACKET ID RBRACKET   {
			char *s = cat($1, "[", $3, "]", "", "", "");
			free($1);
			free($3);
			$$ = createRecord(s, "");
			free(s);
			}
        | ID ASSIGNMENT expression  {
			char *s = cat($1, " = ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
        | ID LBRACKET ID RBRACKET ASSIGNMENT expression  {
			char *s = cat($1, "[", $3, "]", " = ", $6->code, "");
                        free($1);
                        free($3);
			freeRecord($6);
                        $$ = createRecord(s, "");
                        free(s);
			};

 call_functions : ID '(' params ')'  {
			char *s = cat($1, "(", $3->code, ")", "", "", "");
                        free($1);
			freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			};

 params :   ID params {
			char *s = cat($1, $2->code, "", "", "", "", "");
                        free($1);
                        freeRecord($2);
                        $$ = createRecord(s, "");
                        free(s);
			}
          | ID ',' params {
			char *s = cat($1, ",", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
          | {
			createRecord("", "");
			};


expression : ID 	{
	   		$$ = createRecord($1, "");
                    	free($1);
                  	}
            | ID ASSIGNMENT expression  {
			char * s = cat($1, " = ", $3->code, "", "", "", "");
      			free($1);
      			freeRecord($3);
      			$$ = createRecord(s, "");
      			free(s);
			}
            | ID OP_PLUS expression {
			char * s = cat($1, " + ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID OP_MINUS expression {
			char * s = cat($1, " - ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID OP_DIV expression {
			char * s = cat($1, " / ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID OP_MULT expression {
			char * s = cat($1, " * ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
	    | ID OP_EXP expression  {
			char * s = cat($1, " ^ ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}

            | ID LESS_THAN expression {
			char * s = cat($1, " < ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID GREATER_THAN expression {
			char * s = cat($1, " > ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID EQUALS expression {
			char * s = cat($1, " == ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID LESS_THAN_OR_EQUAL expression {
			char * s = cat($1, " <= ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID GREATER_THAN_OR_EQUAL expression {
			char * s = cat($1, " >= ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID NOT_EQUALS expression {
			char * s = cat($1, " != ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            

            | ID LOGICAL_AND expression {
			char * s = cat($1, " and ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            | ID LOGICAL_OR expression {
			char * s = cat($1, " or ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
			}
            
            | ID LOGICAL_NOT expression {
                        char * s = cat($1, " not ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
                        };

direct_assignment : ID ASSIGNMENT expression { //$1 recebe $3, e $$ recebe $1 ?
		  	char * s = cat($1, " = ", $3->code, "", "", "", "");
                        free($1);
                        freeRecord($3);
                        $$ = createRecord(s, "");
                        free(s);
		  	};

unary_op :  ID ADITION_ASSIGNMENT {
	 		char * s = cat($1, " += ", "", "", "", "", "");
                        free($1);
                        $$ = createRecord(s, "");
                        free(s);
			}
          | ID INCREMENT {
			char * s = cat($1, " ++ ", "", "", "", "", "");
                        free($1);
                        $$ = createRecord(s, "");
                        free(s);
			}
          | ID DECREMENT {
			char * s = cat($1, " -- ", "", "", "", "", "");
                        free($1);
                        $$ = createRecord(s, "");
                        free(s);
			}
          | ID SUBTRACTION_ASSIGNMENT {
			char * s = cat($1, " -= ", "", "", "", "", "");
                        free($1);
                        $$ = createRecord(s, "");
                        free(s);
			}
  ;


conditional_if : IF '(' expression ')' instructions ENDIF {
	       		char * s = cat("if ", "(", $3->code, ")", $5->code, "endif", "");
      			freeRecord($3);
		        freeRecord($5);
      			$$ = createRecord(s, "");
      			free(s);
			}
                | IF '(' expression ')' instructions ELSE instructions ENDIF {
			char * s1 = cat("if ", "(", $3->code, ")", $5->code, "else", $7->code);
			char * s2 = cat(s1, "endif", "", "", "", "", "");
                        free(s1);
			freeRecord($3);
                        freeRecord($5);
			freeRecord($7);
                        $$ = createRecord(s2, "");
                        free(s2);
			}

while_loop : WHILE '(' expression ')' instructions ENDWHILE {
	   		char * s = cat("while ", "(", $3->code, ")\n", $5->code, "endwhile", "");
                	$$ = createRecord(s, "");
                	freeRecord($3);
                	freeRecord($5);
                	free(s);
			};

for_loop : FOR '(' var_declarations ';' expression ';' unary_op ')' instructions ENDFOR {
	 		char *s1 = cat("for", "(", $3->code, ";", $5->code, ";", $7->code);
			char *s2 = cat(s1, ")", $9->code, "endfor", "", "", "");
			free(s1);
			freeRecord($3);
			freeRecord($5);
                        freeRecord($7);
                        freeRecord($9);
			$$ = createRecord(s2, "");
			};  // validar o var_declarations com o professor

print : PRINT '(' texts ')' {char * spointer = cat("print", "(", $3->code, ")", "", "", "");
      				freeRecord($3);
				$$ = createRecord(spointer, "");
				};

texts :  text {$$ = $1;}
      | text ',' texts {char * spointer = cat($1->code, ",", $3->code, "", "", "", "");
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

scan : SCAN '(' scan_list ')'{} ;

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
char * cat(char * s1, char * s2, char * s3, char * s4, char * s5, char * s6, char * s7){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + strlen(s6) + strlen(s7) + 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s%s%s", s1, s2, s3, s4, s5, s6, s7);
  
  return output;
}
