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

char *cat(char *, char *, char *, char *, char *, char *, char *, char *, char *, char *);
char* generateLabel();

SymbolTable *symbolTable;
int gotoCounter;
int scope_count;
int labelCounter;

void scopeIncrement ();
void scopeDecrement ();
%}

%union {
  char *sValue;
  struct record *rec;
};

%token CONST
%token FUNC ENDFUNC
%token IF ELSE ENDIF
%token MAIN ENDMAIN
%token PRINT INPUT RETURN BREAK
%token ASSIGN OPPLUS OPMINUS OPMULT OPDIV OPMOD OPEQ OPNEQ OPGT OPLT OPGTE OPLTE OPEXP
%token OPPLUSASSIGN
%token INCR DECR
%token LGAND LGOR LGNOT
%token FOR ENDFOR WHILE ENDWHILE
%token <sValue> ID TYPE INT FLOAT STRING BOOLEAN

%type <rec> globaldef subprogs subprog args_op args arg main cmds vardecl cmd
%type <rec> cond loop return break print input exp call exps_op exps assign_stmt assign increment_stmt decrement_stmt fordecl forstop forinter

%left OPPLUS OPMINUS
%left OPMULT OPDIV OPMOD OPEQ OPNEQ OPGT OPLT OPGTE OPLTE OPEXP
%left LGAND LGOR
%right LGNOT

%start prog

%%
prog : globaldef subprogs main {
        fprintf(yyout, "%s\n%s\n%s", $1->code, $2->code, $3->code);
        freeRecord($1);
        freeRecord($2);
        freeRecord($3);
      };

globaldef : {
            $$ = createRecord("", "", "");
          }
          | CONST TYPE ID ASSIGN exp ';' {
            char * s = cat("#define", " ", $3, " ", $5->code, "", "", "", "", "");
            free($3);
            freeRecord($5);
            $$ = createRecord(s, "", "");
            free(s);
          };

subprogs : {
          $$ = createRecord("","","");
        }
        | subprog subprogs {
          char * s = cat($1->code, "\n", $2->code, "", "", "", "", "", "", "");
          freeRecord($1);
          freeRecord($2);
          $$ = createRecord(s, "","");
          free(s);
        };

subprog : FUNC TYPE ID {scopeIncrement();}'(' args_op ')' cmds ENDFUNC {
          char * s1 = cat($2, " ", $3, "(", $6->code, "", "", "", "", "");
          char * s2 = cat(s1, ")\n", "{\n", $8->code, "}", "", "", "", "", "");
          free(s1);
          free($2);
          free($3);
          freeRecord($6);
          freeRecord($8);
          $$ = createRecord(s2, "", "");
          free(s2);
	  scopeDecrement();
        }
        | FUNC ID '(' args_op ')' cmds ENDFUNC {
          scope_count++;
          char * s1 = cat("void", " ", $2, "(", $4->code, "", "", "", "", "");
          char * s2 = cat(s1, ")\n", "{\n", $6->code, "}", "", "", "", "", "");
          free(s1);
          free($2);
          freeRecord($4);
          freeRecord($6);
          $$ = createRecord(s2, "", "");
          free(s2);
        };

args_op : {
          $$ = createRecord("", "", "");
        }
        | args {
          $$ = $1;
        };

args : arg {
      $$ = $1;
    }
    | arg ',' args {
      char * s = cat($1->code, ", ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    };

arg : TYPE ID {
      insertSymbol(symbolTable, $2, $1, scope_count);
      char * s = cat($1, " ", $2, "", "", "", "", "", "", "");
      free($1);
      free($2);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | TYPE OPMULT ID {
      insertSymbol(symbolTable, $3, $1, scope_count);
      char * s = cat($1, " *", $3, "", "", "", "", "", "", "");
      free($1);
      free($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | TYPE '&' ID {
      insertSymbol(symbolTable, $3, $1, scope_count);
      char * s = cat($1, " &", $3, "", "", "", "", "", "", "");
      free($1);
      free($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | TYPE ID '[' INT ']' '[' INT ']' {
      insertSymbol(symbolTable, $2, $1, scope_count);
      char * s = cat($1, " ", $2, "[", $4, "]", "[", $7, "]", "");
      free($1);
      free($2);
      free($4);
      free($7);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | TYPE ID '[' ID ']' '[' ID ']' {
      insertSymbol(symbolTable, $2, $1, scope_count);
      char * s = cat($1, " ", $2, "[", $4, "]", "[", $7, "]", "");
      free($1);
      free($2);
      free($4);
      free($7);
      $$ = createRecord(s, "", "");
      free(s);
    };

main : MAIN cmds ENDMAIN {
      char * s = cat("int main() {\n", $2->code, "}", "", "", "", "", "", "", "");
      freeRecord($2);
      $$ = createRecord(s, "", "");
      free(s);
    };

cmds : {
      $$ = createRecord("", "", "");
    }
    | vardecl cmds {
      char *s = cat($1->code, "\n", $2->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | cmd cmds {
      char * s = cat($1->code, "\n", $2->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($2);
      $$ = createRecord(s, "", "");
      free(s);
    };

vardecl : TYPE ID ASSIGN exp ';' {
          char *type = lookupSymbolType(symbolTable, $2);
          if (type != NULL) {
            yyerror("variavel com mesmo nome já declarada");
            exit(0);
          }
          insertSymbol(symbolTable, $2, $1, scope_count);
          char *s = cat($1, " ", $2, " = ", $4->code, ";", "", "", "", "");
          free($1);
          free($2);
          freeRecord($4);
          $$ = createRecord(s, "", "");
          free(s);
        }
        | TYPE ID ';' {
          insertSymbol(symbolTable, $2, $1, scope_count);
          char *s = cat($1, " ", $2, ";", "", "", "", "", "", "");
          free($1);
          free($2);
          $$ = createRecord(s, "", "");
          free(s);
        }
        | TYPE OPMULT ID ';' {
          insertSymbol(symbolTable, $3, $1, scope_count);
          char *s = cat($1, " *", $3, ";", "", "", "", "", "", "");
          free($1);
          free($3);
          $$ = createRecord(s, "", "");
          free(s);
        }
        | TYPE ID '[' INT ']' ';' {
            insertSymbol(symbolTable, $2, $1, scope_count);
            char *s = cat($1, " ", $2, "[", $4, "]", ";", "", "", "");
            free($1);
            free($2);
            free($4);
            $$ = createRecord(s, "", "");
            free(s);
        }
        | TYPE ID '[' INT ']' '[' INT ']' ';' {
            insertSymbol(symbolTable, $2, $1, scope_count);
            char *s = cat($1, " ", $2, "[", $4, "]", "[", $7, "]", ";");
            free($1);
            free($2);
            free($4);
            free($7);
            $$ = createRecord(s, "", "");
            free(s);
        }
        | TYPE ID '[' ID ']' '[' ID ']' ';' {
            insertSymbol(symbolTable, $2, $1, scope_count);
            char *s = cat($1, " ", $2, "[", $4, "]", "[", $7, "]", ";");
            free($1);
            free($2);
            free($4);
            free($7);
            $$ = createRecord(s, "", "");
            free(s);
        };

cmd : cond{scopeIncrement();} {
      $$ = $1;
      scopeDecrement();
    }
    | loop {
      $$ = $1;
    }
    | return {
      $$ = $1;
    }
    | break {
      $$ = $1;
    }
    | print {
      $$ = $1;
    }
    | input {
      $$ = $1;
    }
    // | interation {
    //   $$ = $1;
    // }
    | assign_stmt {
      $$ = $1;
    }
    | increment_stmt {
      $$ = $1;
    }
    | decrement_stmt {
      $$ = $1;
    }
    | call {
      $$ = $1;
    };


fordecl : TYPE ID ASSIGN exp {
  char *type = lookupSymbolType(symbolTable, $2);
  if (type != NULL) {
    yyerror("variavel com mesmo nome já declarada");
    exit(0);
  }
  insertSymbol(symbolTable, $2, $1, scope_count);
  char *s = cat($1, " ", $2, " = ", $4->code, "", "", "", "", "");
  free($1);
  free($2);
  freeRecord($4);
  $$ = createRecord(s, "", "");
  free(s);
};

forstop : exp {
  $$ = $1;
};

forinter : ID INCR {
          char *s = cat($1, "++", "", "", "", "", "", "", "", "");
          free($1);
          $$ = createRecord(s, "", "");
          free(s);
        }
        | INCR ID {
          char *s = cat("++", $2, "", "", "", "", "", "", "", "");
          free($2);
          $$ = createRecord(s, "", "");
          free(s);
        };

loop : FOR '(' fordecl ';' forstop ';' forinter ')' cmds ENDFOR {
      char *loopLabel = generateLabel();
      char *endLabel = generateLabel();

      char *s1 = cat(loopLabel, ":\n", "", "", "", "", "", "", "", "");
      char *s2 = cat($3->code, ";\n", "", "", "", "", "", "", "", "");
      char *s3 = cat(loopLabel, "_cond:\n", "", "", "", "", "", "", "", "");
      char *s4 = cat("if (!(", $5->code, ")) goto ", endLabel, ";\n", "", "", "", "", "");
      char *s5 = cat($9->code, "\n", "", "", "", "", "", "", "", "");
      char *s6 = cat($7->code, "; goto ", loopLabel, "_cond;\n", "", "", "", "", "", "");
      char *s7 = cat(endLabel, ":\n", "", "", "", "", "", "", "", "");

      char *s = cat(s1, s2, s3, s4, s5, s6, s7, "", "", "");

      free(loopLabel);
      free(endLabel);
      freeRecord($3);
      freeRecord($5);
      freeRecord($7);
      freeRecord($9);

      $$ = createRecord(s, "", "");
    }
    | WHILE exp cmds ENDWHILE {

      char *wLabel = generateLabel();
      char *endLabel = generateLabel();
      
      char * ss = cat( wLabel,"loop_while_", ":\n", "\tif(!(" , $2->code, "))", " goto ", endLabel, ";\n", $3->code);
      char * sss = cat("goto ", wLabel,"loop_while_;\n", endLabel, ":", "", "", "", "", "");

      char * s = cat(ss, sss, "", "", "", "", "", "", "", "");
      freeRecord($2);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
      free(ss);
      free(sss);
    };

/* atribuição direta ===== */
assign_stmt : assign ';' {
        char * s = cat($1->code, ";", "\n", "", "", "", "", "", "", "");
        freeRecord($1);
        $$ = createRecord(s, "", "");
        free(s);
};

increment_stmt : ID INCR ';' {
                 char *s = cat($1, "++;", "", "", "", "", "", "", "", "");
                 free($1);
                 $$ = createRecord(s, "", "");
                 free(s);
               }
               | INCR ID ';' {
                 char *s = cat("++", $2, ";", "", "", "", "", "", "", "");
                 free($2);
                 $$ = createRecord(s, "", "");
                 free(s);
               };

decrement_stmt : ID DECR ';' {
                 char *s = cat($1, "--;", "", "", "", "", "", "", "", "");
                 free($1);
                 $$ = createRecord(s, "", "");
                 free(s);
               }
               | DECR ID ';' {
                 char *s = cat("--", $2, ";", "", "", "", "", "", "", "");
                 free($2);
                 $$ = createRecord(s, "", "");
                 free(s);
               };

assign: ID ASSIGN exp {
        //printf($3->code);
        //printf(" type\n");
        char *type = lookupSymbolType(symbolTable, $1);
        if (type == NULL) {
          yyerror("variavel não declarada");
          exit(0);
        }
        char * s = cat($1, "=", $3->code, "", "", "", "", "", "", "");
        free($1);
        freeRecord($3);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | ID '[' exp ']' ASSIGN exp {
                  char *s = cat($1, "[", $3->code, "]", " = ", $6->code, "", "", "", "");
                  free($1);
                  freeRecord($3);
                  freeRecord($6);
                  $$ = createRecord(s, "", "");
                  free(s);
      }
      | ID '[' exp ']' '[' exp ']' ASSIGN exp {
                  char *s = cat($1, "[", $3->code, "]", "[", $6->code, "]", " = ", $9->code, "");
                  free($1);
                  freeRecord($3);
                  freeRecord($6);
                  freeRecord($9);
                  $$ = createRecord(s, "", "");
                  free(s);
      }
      | OPMULT ID ASSIGN exp {
        char * s = cat("*", $2, "=", $4->code, "", "", "", "", "", "");
        free($2);
        freeRecord($4);
        $$ = createRecord(s, "", "");
        free(s);
      }
      /* | ID ASSIGN OPMULT ID {
        char * s = cat($1, "=", "*", $4, "", "", "", "", "", "");
        free($1);
        free($4);
        $$ = createRecord(s, "", "");
        free(s);
      } */
      | '&' ID ASSIGN exp {
        char * s = cat("&", $2, "=", $4->code, "", "", "", "", "", "");
        free($2);
        freeRecord($4);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | ID ASSIGN '&' ID {
        char * s = cat($1, "=", "&", $4, "", "", "", "", "", "");
        free($1);
        free($4);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | ID OPPLUSASSIGN exp {
        char *type = lookupSymbolType(symbolTable, $1);
        if (type == NULL) {
          yyerror("variavel não declarada");
          exit(0);
        }
        char * s = cat($1, "+=", $3->code, "", "", "", "", "", "", "");
        free($1);
        freeRecord($3);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | ID '[' exp ']' '[' exp ']' OPPLUSASSIGN exp {
        char *s = cat($1, "[", $3->code, "]", "[", $6->code, "]", " += ", $9->code, "");
        free($1);
        freeRecord($3);
        freeRecord($6);
        freeRecord($9);
        $$ = createRecord(s, "", "");
        free(s);
      };

cond : IF exp cmds ENDIF {
      //printf("result type");
      //printf($2->result_type);
      if (!(strcmp($2->result_type, "logic") == 0)) {
        yyerror("Expresão em if só aceita expressão logica");
        exit(0);
      }
      char * s = cat("if ", $2->code, " {\n", $3->code, "}\n", "", "", "", "", "");
      //char * ss = cat("if_label: \n ", $4->code, "", "", "", "", "", "", "", "");
      //char * sss = cat(s, ss, "", "", "", "", "", "", "", "");

      freeRecord($2);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
      //free(ss);
      //free(sss);
    }
    | IF exp cmds ELSE cmd ENDIF {
      // printf("IF ELSE\n");
      // printf("exp: %s\n", $2->code);
      // printf("cmds: %s\n", $3->code);
      // printf("cmd: %s\n", $5->code);
      // char * s = cat("if ", $2->code, " {\n", $3->code, "} else ", $5->code, "", "", "", "");
      // freeRecord($2);
      // freeRecord($3);
      // freeRecord($5);
      // $$ = createRecord(s, "", "");
      // free(s);

      char gotoRef[5] = "";
      sprintf(gotoRef, "%d", gotoCounter);
      gotoCounter++;
      char * s1 = cat("if (!", $2->code, ") {\n", "goto else", gotoRef, ";}", $3->code, "", "", "");
      char * s2 = cat("", "\n", "else", gotoRef, ":", $5->code, "", "", "", "");
      char * s = cat(s1, s2, "", "", "", "", "", "", "", "");
      freeRecord($2);
      freeRecord($3);
      freeRecord($5);
      $$ = createRecord(s, "", "");
      free(s1);
      free(s2);
      free(s);
//      scopeDecrement();
    };

return : RETURN exp ';' {
        char * s = cat("return ", $2->code, ";", "", "", "", "", "", "", "");
        freeRecord($2);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | RETURN ';' {
        char * s = cat("return;", "", "", "", "", "", "", "", "", "");
        $$ = createRecord(s, "", "");
        free(s);
      };

break : BREAK ';' {
        char * s = cat("break;", "", "", "", "", "", "", "", "", "");
        $$ = createRecord(s, "", "");
        free(s);
      };

print : PRINT '(' exps ')' ';' {
        char *format;
        char * s;
        if (strcmp($3->opt1, "int") == 0) {
          format = "%d";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "", "", "", "", "");
        } else if (strcmp($3->opt1, "float") == 0) {
          format = "%f";
          s = cat("printf(\"", format, "\\n\", ", $3->code, ");", "", "", "", "", "");
        } else {
          s = cat("printf", "(", $3->code, ")", ";", "", "", "", "", "");
        }

        freeRecord($3);
        $$ = createRecord(s, "", "");
        free(s);
      };

input : INPUT '(' ID ')' ';' {
        //char *format;
        //if (strcmp($3->opt1, "int") == 0) {
        //  format = "%d";
        //} else if (strcmp($3->opt1, "float") == 0) {
        //  format = "%f";
        //} else {
        //  format = "%c";
        //}
        
        char * s = cat("scanf(\"", "%d", "", "\", &", $3, ");", "", "", "", "");
        //freeRecord($3);
        $$ = createRecord(s, "", "");
        free(s);
      }
      | INPUT '(' ID '[' exp ']' '[' exp ']' ')' ';' {
        char * s = cat("scanf(\"", "%d", "", "\", &", $3, "[", $5->code, "][", $8->code, "]);");
        free($3);
        freeRecord($5);
        freeRecord($8);
        $$ = createRecord(s, "", "");
        free(s);
      };

exp : exp OPPLUS exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " + ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | exp OPMINUS exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " - ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | exp OPMULT exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " * ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | exp OPDIV exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " / ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | exp OPMOD exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " % ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | exp OPEQ exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " == ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPNEQ exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat($1->code, " != ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPGT exp {
      char * s = cat($1->code, " > ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPLT exp {
      char * s = cat($1->code, " < ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPGTE exp {
      char * s = cat($1->code, " >= ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPLTE exp {
      char * s = cat($1->code, " <= ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp OPEXP exp {
      checkType($1->opt1, $3->opt1);
      char * s = cat("pow", "(", $3->code, ",", $1->code, ")", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | ID {
      char *type = lookupSymbolType(symbolTable, $1);
        if (type == NULL) {
          yyerror("variavel não declarada");
          exit(0);
        } else {
        $$ = createRecord($1, type, "");
      }
      free($1);
    }
    | OPMULT ID {
      char * s = cat("*", $2, "", "", "", "", "", "", "", "");
      free($2);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | INT {
      $$ = createRecord($1, "int", "");
      free($1);
    }
    | FLOAT {
      $$ = createRecord($1, "float", "");
      free($1);
    }
    | STRING {
      $$ = createRecord($1, "str", "");
      free($1);
    }
    | BOOLEAN {
      $$ = createRecord($1, "bool", "");
      free($1);
    }
    // | INCR ID ';' {
    //   char *s = cat($2, "++", "", "", "", "", "", "", "", "");
    //   free($2);
    //   $$ = createRecord(s, "");
    //   free(s);
    // }
    // | DECR ID ';' {
    //   char *s = cat($2, "--", "", "", "", "", "", "", "", "");
    //   free($2);
    //   $$ = createRecord(s, "");
    //   free(s);
    // }
    // | ID INCR ';' {
    //   printf("ID INCR\n");
    //   char *s = cat($1, "++", "", "", "", "", "", "", "", "");
    //   free($1);
    //   $$ = createRecord(s, "");
    //   free(s);
    // }
    // | ID DECR ';' {
    //   char *s = cat($1, "--", "", "", "", "", "", "", "", "");
    //   free($1);
    //   $$ = createRecord(s, "");
    //   free(s);
    // }
    | '(' exp ')' {
      char * s = cat("(", $2->code, ")", "", "", "", "", "", "", "");
      //printf($2->result_type);
      if (strcmp($2->result_type, "logic") == 0) {
        $$ = createRecord(s, "", "logic");
      }else{
        $$ = createRecord(s, "", "");
      }
      freeRecord($2);
      free(s);
    }
    | exp LGAND exp {
      char * s = cat($1->code, " && ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | exp LGOR exp {
      char * s = cat($1->code, " || ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | LGNOT exp %prec LGNOT {
      char * s = cat("!", $2->code, "", "", "", "", "", "", "", "");
      freeRecord($2);
      $$ = createRecord(s, "", "logic");
      free(s);
    }
    | ID '[' exp ']' {
        char *s = cat($1, "[", $3->code, "]", "", "", "", "", "", "");
        free($1);
        freeRecord($3);
        $$ = createRecord(s, "", "");
        free(s);
    }
    | ID '[' exp ']' '[' exp ']' {
        char *s = cat($1, "[", $3->code, "]", "[", $6->code, "]", "", "", "");
        free($1);
        freeRecord($3);
        freeRecord($6);
        $$ = createRecord(s, "", "");
        free(s);
    }
    | call {
      $$ = $1;
    };

call : ID '(' exps_op ')' ';' {
      char * s = cat($1, "(", $3->code, ")", ";", "", "", "", "", "");
      free($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    };

exps_op : {
          $$ = createRecord("","", "");
        }
        | exps {
          $$ = $1;
        };

exps : exp {
      $$ = $1;
    }
    | exp ',' exps {
      char * s = cat($1->code, ", ", $3->code, "", "", "", "", "", "", "");
      freeRecord($1);
      freeRecord($3);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | '&' ID {
      char * s = cat("&", $2, "", "", "", "", "", "", "", "");
      free($2);
      $$ = createRecord(s, "", "");
      free(s);
    }
    | '&' ID ',' exps {
      char * s = cat("&", $2, ", ", $4->code, "", "", "", "", "", "");
      free($2);
      freeRecord($4);
      $$ = createRecord(s, "", "");
      free(s);
    }
    ;
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
  scope_count = 0;
  labelCounter = 0;

  code = yyparse();

  fclose(yyin);
  fclose(yyout);

  //display(symbolTable);

  destroySymbolTable(symbolTable);

  return code;
}

int yyerror(char *msg) {
  fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
  return 0;
}

char *cat(char *s1, char *s2, char *s3, char *s4, char *s5, char *s6, char *s7, char *s8, char *s9, char *s10) {
  int tam;
  char *output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + strlen(s6) + strlen(s7) + strlen(s8) + strlen(s9) + strlen(s10) + 1;
  output = (char *) malloc(sizeof(char) *tam);

  if (!output) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  sprintf(output, "%s%s%s%s%s%s%s%s%s%s", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);

  return output;
}

char* generateLabel() {
  char* label = (char*)malloc(15 * sizeof(char));
  sprintf(label, "label%d", labelCounter);
  labelCounter++;
  return label;
}

void scopeIncrement (){
        scope_count++;
//      printf("===============SCOPE=%d============\n",scope);
//        printf("===========SCOPE=COUNT=%d============\n",scope_count);
}

void scopeDecrement (){
        removeScope(symbolTable, scope_count);
        scope_count--;
}
