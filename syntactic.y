%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"
#include "./lib/symbol-table.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;
extern FILE *yyin, *yyout;

char *cat(char *, char *, char *, char *, char *, char *, char *);

SymbolTable *symbolTable;
int gotoCounter;
%}

%union {
  char *sValue;
  struct record *rec;
};

%token FUNC ENDFUNC
%token IF ELSE ENDIF
%token MAIN ENDMAIN
%token PRINT RETURN
%token ASSIGN OPPLUS OPMINUS OPMULT OPDIV OPEQ OPEXP
%token WHILE ENDWHILE
%token <sValue> ID TYPE INT FLOAT STRING BOOLEAN

%type <rec> subprogs subprog args_op args arg main cmds vardecl cmd interation while 
%type <rec> cond return print exp call exps_op exps

%left OPPLUS OPMINUS
%left OPMULT OPDIV OPEXP OPEQ

%start prog

%%
prog : subprogs main {
        fprintf(yyout, "%s\n%s", $1->code, $2->code);
        freeRecord($1);
        freeRecord($2);
      };

subprogs : {
          $$ = createRecord("","");
        }
        | subprog subprogs {
          char * s = cat($1->code, "\n", $2->code, "", "", "", "");
          freeRecord($1);
          freeRecord($2);
          $$ = createRecord(s, "");
          free(s);
        };

subprog : FUNC TYPE ID '(' args_op ')' cmds ENDFUNC {
          char * s1 = cat($2, " ", $3, "(", $5->code, "", "");
          char * s2 = cat(s1, ")\n", "{\n", $7->code, "}", "", "");
          free(s1);
          free($2);
          free($3);
          freeRecord($5);
          freeRecord($7);
          $$ = createRecord(s2, "");
          free(s2);
        };

args_op : {
          $$ = createRecord("","");
        }
        | args {
          $$ = $1;
        };

args : arg {
      $$ = $1;
    }
    | arg ',' args {
      char * s = cat($1->code, ", ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

arg : TYPE ID {
      char * s = cat($1, " ", $2, "", "", "", "");
      free($1);
      free($2);
      $$ = createRecord(s, "");
      free(s);
    };

main : MAIN cmds ENDMAIN {
      char * s = cat("int main() {\n", $2->code, "}", "", "", "", "");
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

cmds : {
      $$ = createRecord("","");
    }
    | vardecl cmds {
      char *s = cat($1->code, "\n", $2->code, "", "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    }
    | cmd cmds {
      char * s = cat($1->code, "\n", $2->code, "", "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

vardecl : TYPE ID ASSIGN exp ';' {
          insertSymbol(symbolTable, $2, $1);
          char *s = cat($1, " ", $2, " = ", $4->code, ";", "");
          free($1);
          free($2);
          freeRecord($4);
          $$ = createRecord(s, "");
          free(s);
        };

cmd : cond {
      $$ = $1;
    }
    | return {
      $$ = $1;
    }
    | print {
      $$ = $1;
    }
    | interation {
      $$ = $1;
    };

interation: while { $$ = $1; }
            ;

while: WHILE exp cmds ENDWHILE {
        char * s = cat("while", $2->code, " {\n", $3->code, "}", "", "");
        freeRecord($2);
        freeRecord($3);
        $$ = createRecord(s, "");
        free(s);
      };


cond : IF exp cmds ENDIF {
      char * s = cat("if ", $2->code, " {\n", $3->code, "}", "", "");
      freeRecord($2);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | IF exp cmds ELSE cmds ENDIF {
      char gotoRef[] = "end";
      sprintf(gotoRef, "%d", gotoCounter);
      gotoCounter++;

      char * s1 = cat("if ", $2->code, " {\n", $3->code, "goto end", gotoRef, ";}");
      char * s2 = cat(s1, "\n", $5->code, "end", gotoRef, ":", "");

      // ---
      // if (1 == 1) {
        // printf("Condição verdadeira\n");
        // goto end;
      // }

      // printf("Condição falsa\n");

      // end:
      // printf("Fim do programa\n");
      // ---


      free(s1);
      freeRecord($2);
      freeRecord($3);
      freeRecord($5);
      $$ = createRecord(s2, "");
      free(s2);
    };

return : RETURN exp ';' {
        char * s = cat("return ", $2->code, ";", "", "", "", "");
        freeRecord($2);
        $$ = createRecord(s, "");
        free(s);
      };

print : PRINT '(' exps ')' ';' {
        char *format;
        char * s;
        if (strcmp($3->opt1, "int") == 0) {
          format = "%d";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "", "");
        } else if (strcmp($3->opt1, "float") == 0) {
          format = "%f";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "", "");
        } else {
          s = cat("puts", "(", $3->code, ")", ";", "", "");
        }

        freeRecord($3);
        $$ = createRecord(s, "");
        free(s);
      };

exp : exp OPPLUS exp {
      char * s = cat($1->code, " + ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMINUS exp {
      char * s = cat($1->code, " - ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMULT exp {
      char * s = cat($1->code, " * ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPDIV exp {
      char * s = cat($1->code, " / ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPEQ exp {
      char * s = cat($1->code, " == ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPEXP exp {
      char * s = cat("pow", "(", $3->code, ",", $1->code, ")", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | ID {
      // printf("IDENTIFY\n");
      char *type = lookupSymbolType(symbolTable, $1);
      // printf("%s\n", type);
      // printf("%s\n", $1);
      if (type == NULL) {
        $$ = createRecord($1, "");
      } else {
        $$ = createRecord($1, type);
      }
      free($1);
    }
    | INT {
      // printf("INT\n");
      // printf("%s\n", $1);
      $$ = createRecord($1, "int");
      free($1);
    }
    | FLOAT {
      // printf("FLOAT\n");
      // printf("%s\n", $1);
      $$ = createRecord($1, "float");
      free($1);
    }
    | STRING {
      // printf("STRING\n");
      // printf("%s\n", $1);
      $$ = createRecord($1, "str");
      free($1);
    }
    | BOOLEAN {
      // printf("BOOLEAN\n");
      // printf("%s\n", $1);
      $$ = createRecord($1, "bool");
      free($1);
    }
    | '(' exp ')' {
      // printf("EXPRESSION\n");
      // printf("%s\n", $2->code);
      char * s = cat("(", $2->code, ")", "", "", "", "");
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    }
    | call {
      $$ = $1;
    };

call : ID '(' exps_op ')' {
      // printf("exps_op\n");
      // printf("%s\n", $3->code);
      char * s = cat($1, "(", $3->code, ")", "", "", "");
      free($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

exps_op : {
          $$ = createRecord("","");
        }
        | exps {
          $$ = $1;
        };

exps : exp {
      $$ = $1;
    }
    | exp ',' exps {
      char * s = cat($1->code, ", ", $3->code, "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };
%%

int main(int argc, char **argv) {
  int code;

  if (argc != 3) {
    printf("Usage: $./compiler input.txt output.txt\nClosing application...\n");
    exit(0);
  }

  yyin = fopen(argv[1], "r");
  yyout = fopen(argv[2], "w");

  symbolTable = createSymbolTable(100);
  gotoCounter = 0;

  code = yyparse();

  fclose(yyin);
  fclose(yyout);

  destroySymbolTable(symbolTable);

  return code;
}

int yyerror(char *msg) {
  fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}

char *cat(char *s1, char *s2, char *s3, char *s4, char *s5, char *s6, char *s7) {
  int tam;
  char *output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + strlen(s6) + strlen(s7) + 1;
  output = (char *) malloc(sizeof(char) *tam);

  if (!output) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  sprintf(output, "%s%s%s%s%s%s%s", s1, s2, s3, s4, s5, s6, s7);

  return output;
}
