%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./lib/record.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;
extern FILE *yyin, *yyout;

char *cat(char *, char *, char *, char *, char *);
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
%type <rec> cond return write exp call exps_op exps

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
          char * s = cat($1->code, "\n", $2->code, "", "");
          freeRecord($1);
          freeRecord($2);
          $$ = createRecord(s, "");
          free(s);
        };

subprog : FUNC TYPE ID '(' args_op ')' cmds ENDFUNC {
          char * s1 = cat($2, " ", $3, "(", $5->code);
          char * s2 = cat(s1, ")\n", "{\n", $7->code, "}");
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
      char * s = cat($1->code, "; ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

arg : TYPE ids {
      char * s = cat($1, " ", $2->code, "", "");
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
      char * s = cat($1, ", ", $3->code, "", "");
      free($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    };

main : MAIN cmds ENDMAIN {
      char * s = cat("int main() {\n", $2->code, "}", "", "");
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

cmds : {
      $$ = createRecord("","");
    }
    | vardecl cmds {
      char *s = cat($1->code, "\n", $2->code, "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    }
    | cmd cmds {
      char * s = cat($1->code, "\n", $2->code, "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    };

vardecl : TYPE ID ASSIGN exp ';' {
          char *s = cat($1, " ", $2, " = ", $4->code);
          free($1);
          free($2);
          freeRecord($4);
          $$ = createRecord(s, "");
          free(s);
        }
        | TYPE ID ASSIGN INT ';' {
          char *s = cat($1, " ", $2, " = ", $4);
          free($1);
          free($2);
          free($4);
          $$ = createRecord(s, "");
          free(s);
        }
        | TYPE ID ASSIGN FLOAT ';' {
          char *s = cat($1, " ", $2, " = ", $4);
          free($1);
          free($2);
          free($4);
          $$ = createRecord(s, "");
          free(s);
        };

cmd : cond {
      $$ = $1;
    }
    | return {
      $$ = $1;
    }
    | write {
      $$ = $1;
    };

cond : IF exp cmds ENDIF {
      char * s = cat("if ", $2->code, " {\n", $3->code, "}");
      freeRecord($2);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | IF exp cmds ELSE cmds ENDIF {
      char * s1 = cat("if ", $2->code, " {\n", $3->code, "}");
      char * s2 = cat(s1, "\nelse ", "{\n", $5->code, "}");
      free(s1);
      freeRecord($2);
      freeRecord($3);
      freeRecord($5);
      $$ = createRecord(s2, "");
      free(s2);
    };

return : RETURN exp ';' {
        char * s = cat("return ", $2->code, ";", "", "");
        freeRecord($2);
        $$ = createRecord(s, "");
        free(s);
      };

write : PRINT '(' exps ')' ';' {
        char * s = cat("write", "(", $3->code, ")", ";");
        freeRecord($3);
        $$ = createRecord(s, "");
        free(s);
      };

exp : exp OPPLUS exp {
      char * s = cat($1->code, " + ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMINUS exp {
      char * s = cat($1->code, " - ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPMULT exp {
      char * s = cat($1->code, " * ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPDIV exp {
      char * s = cat($1->code, " / ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | exp OPEXP exp {
      char * s = cat($1->code, " ** ", $3->code, "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "");
      free(s);
    }
    | ID {
      $$ = createRecord($1, "");
      free($1);
    }
    | INT {
      $$ = createRecord($1, "");
      free($1);
    }
    | FLOAT {
      $$ = createRecord($1, "");
      free($1);
    }
    | STRING {
      $$ = createRecord($1, "");
      free($1);
    }
    | BOOLEAN {
      $$ = createRecord($1, "");
      free($1);
    }
    | '(' exp ')' {
      char * s = cat("(", $2->code, ")", "", "");
      freeRecord($2);
      $$ = createRecord(s, "");
      free(s);
    }
    | call {
      $$ = $1;
    };

call : ID '(' exps_op ')' {
      char * s = cat($1, "(", $3->code, ")", "");
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
      char * s = cat($1->code, ", ", $3->code, "", "");
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

  code = yyparse();

  fclose(yyin);
  fclose(yyout);

  return code;
}

int yyerror(char *msg) {
  fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}

char *cat(char *s1, char *s2, char *s3, char *s4, char *s5) {
  int tam;
  char *output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + 1;
  output = (char *) malloc(sizeof(char) *tam);

  if (!output) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);

  return output;
}
