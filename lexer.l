%{
  #include <stdio.h>
%}

%%

[ \t\n]                ;
[0-9]+                 {printf("NUMBER(%s)\n",yytext);}
"func"                 {printf("FUNC\n");}
"endfunc"              {printf("ENDFUNC\n");}
"while"                {printf("WHILE\n");}
"endwhile"             {printf("ENDWHILE\n");}
"for"                  {printf("FOR\n");}
"endfor"               {printf("ENDFOR\n");}
"if"                   {printf("IF\n");}
"endif"                {printf("ENDIF\n");}
"else"                 {printf("ELSE\n");}
"'"                    {printf("SQUOTE\n");}
"\""                   {printf("DQUOTE\n");}
"("                    {printf("LPAREN\n");}
")"                    {printf("RPAREN\n");}
";"                    {printf("SEMICOLON\n");}
","                    {printf("COMMA\n");}
"="                    {printf("ASSIGNMENT\n");}
"+"                    {printf("OP_PLUS\n");}
"-"                    {printf("OP_MINUS\n");}
"*"                    {printf("OP_MULT\n");}
"/"                    {printf("OP_DIV\n");}
"=="                   {printf("EQUALS\n");}
"!="                   {printf("NOT_EQUALS\n");}
">"                    {printf("GREATER_THAN\n");}
"<"                    {printf("LESS_THAN\n");}
">="                   {printf("GREATER_THAN_OR_EQUAL\n");}
"<="                   {printf("LESS_THAN_OR_EQUAL\n");}
"int"                  {printf("T_INT\n");}
"float"                {printf("T_FLOAT\n");}
"str"                  {printf("T_STRING\n");}
"bool"                 {printf("T_BOOLEAN\n");}
"print"                {printf("PRINT\n");}
"return"               {printf("RETURN\n");}
\'([^\'\\\n]|(\\.))*\' {printf("STRING(%s)\n", yytext);}
\"([^\"\\\n]|(\\.))*\" {printf("STRING(%s)\n", yytext);}
[a-zA-Z][a-zA-Z0-9_]*  {printf("ID(%s)\n",yytext);}
.                      {printf("Invalid character.\n");}

%%

#ifndef yywrap
  int yywrap (void) {return 1;}
#endif

int main(void) {
  yylex();
  return 0;
}
