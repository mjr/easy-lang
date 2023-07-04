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

char *cat(char *, char *, char *, char *, char *, char *);

SymbolTable *symbolTable;
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
%token <sValue> ID TYPE INT FLOAT STRING BOOLEAN

%type <rec> subprogs subprog args_op args arg ids main cmds vardecl cmd
%type <rec> cond return print exp call exps_op exps

%left OPPLUS OPMINUS
%left OPMULT OPDIV OPEXP

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
          char * s = cat($1->code, "\n", $2->code, "", "", "");
          freeRecord($1);
          freeRecord($2);
          $$ = createRecord(s, "");
          free(s);
        };

subprog : FUNC TYPE ID '(' args_op ')' cmds ENDFUNC {
          char * s1 = cat($2, " ", $3, "(", $5->code, "");
          char * s2 = cat(s1, ")\n", "{\n", $7->code, "}", "");
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
    | arg ';' args {
      char * s = cat($1->code, "; ", $3->code, "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

arg : TYPE ids {
      char * s = cat($1, " ", $2->code, "", "", "");
      free($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };


ids : ID {
      $$ = createRecord($1, "");
      free($1);
    }
    | ID ',' ids {
      char * s = cat($1, ", ", $3->code, "", "", "");
      free($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

// args : arg {
//       // printf("2 - HERE \n");
//       // printf("arg: %s\n", $1->code);
//       $$ = $1;
//     };
//     | arg ',' args {
//       // printf("1 - HERE \n");
//       // printf("arg 1: %s\n", $1->code);
//       // printf("arg 2: %s\n", $3->code);
//       char * s = cat($1->code, "; ", $3->code, "", "", "");
//       freeRecord($1);
//       freeRecord($3);
//       $$ = createRecord(s, "");
//       free(s);
//     };

// arg : TYPE ID {
//       // printf("TYPE ID\n");
//       // printf("arg 1: %s\n", $1);
//       // printf("arg 2: %s\n", $2);
//       char * s = cat($1, " ", $2->code, "", "", "");
//       free($1);
//       freeRecord($2);
//       $$ = createRecord(s, "");
//       free(s);
//     };


// ids : ID {
//       $$ = createRecord($1, "");
//       free($1);
//     }
//     | ID ',' ids {
//       char * s = cat($1, ", ", $3->code, "", "", "");
//       free($1);
//       freeRecord($3);
//       $$ = createRecord(s, "");
//       free(s);
//     };

main : MAIN cmds ENDMAIN {
      char * s = cat("int main() {\n", $2->code, "}", "", "", "");
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

cmds : {
      $$ = createRecord("","");
    }
    | vardecl cmds {
      char *s = cat($1->code, "\n", $2->code, "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    }
    | cmd cmds {
      char * s = cat($1->code, "\n", $2->code, "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

vardecl : TYPE ID ASSIGN exp ';' {
          insertSymbol(symbolTable, $2, $1);
          char *s = cat($1, " ", $2, " = ", $4->code, ";");
          free($1);
          free($2);
          freeRecord($4);
          $$ = createRecord(s, "");
          free(s);
        };
        // | TYPE ID ASSIGN INT ';' {
        //   char *s = cat($1, " ", $2, " = ", $4, ";");
        //   free($1);
        //   free($2);
        //   free($4);
        //   $$ = createRecord(s, "");
        //   free(s);
        // }
        // | TYPE ID ASSIGN FLOAT ';' {
        //   char *s = cat($1, " ", $2, " = ", $4, ";");
        //   free($1);
        //   free($2);
        //   free($4);
        //   $$ = createRecord(s, "");
        //   free(s);
        // };

cmd : cond {
      $$ = $1;
    }
    | return {
      $$ = $1;
    }
    | print {
      $$ = $1;
    };

cond : IF exp cmds ENDIF {
      char * s = cat("if ", $2->code, " {\n", $3->code, "}", "");
      freeRecord($2);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | IF exp cmds ELSE cmds ENDIF {
      char * s1 = cat("if ", $2->code, " {\n", $3->code, "}", "");
      char * s2 = cat(s1, "\nelse ", "{\n", $5->code, "}", "");
      free(s1);
      freeRecord($2);
      freeRecord($3);
      freeRecord($5);
      $$ = createRecord(s2, "");
      free(s2);
    };

return : RETURN exp ';' {
        char * s = cat("return ", $2->code, ";", "", "", "");
        freeRecord($2);
        $$ = createRecord(s, "");
        free(s);
      };

print : PRINT '(' exps ')' ';' {
        // printf("-----\n");
        // printf("PRINT\n");
        // printf("Valor: %s\n", $3->code);
        // printf("Tipo: %s\n", $3->opt1);
        // printf("-----\n");

        char *format;
        char * s;
        if (strcmp($3->opt1, "int") == 0) {
          format = "%d";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "");
        } else if (strcmp($3->opt1, "float") == 0) {
          format = "%f";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "");
        } else {
          s = cat("puts", "(", $3->code, ")", ";", "");
        }

        freeRecord($3);
        $$ = createRecord(s, "");
        free(s);
      };

exp : exp OPPLUS exp {
      char * s = cat($1->code, " + ", $3->code, "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMINUS exp {
      char * s = cat($1->code, " - ", $3->code, "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMULT exp {
      char * s = cat($1->code, " * ", $3->code, "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPDIV exp {
      char * s = cat($1->code, " / ", $3->code, "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPEXP exp {
      char * s = cat("pow", "(", $3->code, ",", $1->code, ")");
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
      char * s = cat("(", $2->code, ")", "", "", "");
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
      char * s = cat($1, "(", $3->code, ")", "", "");
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
      char * s = cat($1->code, ", ", $3->code, "", "", "");
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

char *cat(char *s1, char *s2, char *s3, char *s4, char *s5, char *s6) {
  int tam;
  char *output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + strlen(s6) + 1;
  output = (char *) malloc(sizeof(char) *tam);

  if (!output) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  sprintf(output, "%s%s%s%s%s%s", s1, s2, s3, s4, s5, s6);

  return output;
}
