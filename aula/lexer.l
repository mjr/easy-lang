%{
  #include <stdio.h>
  #include "y.tab.h"

  extern int yyerror (char *msg);
%}

%%

[ \t]                   ;
\n                     {yylineno++;}
[0-9]+                 {yylval.sValue = strdup(yytext); 
                         return ID;}
[0-9]\.[0-9]+	         {printf("FLOAT_NUMBER (%s)\n",yytext);}
"func"                 {return(FUNC);}
"endfunc"              {return(ENDFUNC);}
"while"                {return(WHILE);}
"endwhile"             {return(ENDWHILE);}
"for"                  {return(FOR);}
"endfor"               {return(ENDFOR);}
"if"                   {return(IF);}
"endif"                {return(ENDIF);}
"else"                 {return(ELSE);}
"input" 	             {printf("INPUT\n");}
"'"                    {printf("SQUOTE\n");}
"\""                   {printf("DQUOTE\n");}
"("                    {return(yytext[0]);}
")"                    {return(yytext[0]);}
";"                    {return(yytext[0]);}
"["                    {return LBRACKET;}
"]"                    {return RBRACKET;}
","                    {return(yytext[0]);}
"="                    {return ASSIGNMENT;}
"+"                    {return OP_PLUS;}
"-"                    {return OP_MINUS;}
"*"                    {return OP_MULT;}
"/"                    {return OP_DIV;}
"=="                   {return EQUALS;}
"!="                   {return NOT_EQUALS;}
">"                    {return GREATER_THAN;}
"<"                    {return LESS_THAN;}
">="                   {return GREATER_THAN_OR_EQUAL;}
"<="                   {return LESS_THAN_OR_EQUAL;}
"++"                   {return INCREMENT;}
"--"                   {return DECREMENT;}
"+="                   {return ADITION_ASSIGNMENT;}
"-="                   {return SUBTRACTION_ASSIGNMENT;}
"and"                  {return LOGICAL_AND;}
"or"                   {return LOGICAL_OR;}
"not"                  {printf("LOGICAL_NOT\n");}
"const"                {printf("CONSTANT_VALUE\n");}
"global"               {printf("GLOBAL_VALUE\n");}
"int"                  {yylval.sValue = strdup("int"); return TYPE;}
"float"                {yylval.sValue = strdup("float"); return TYPE;}
"str"                  {printf("T_STRING\n");}
"bool"                 {printf("T_BOOLEAN\n");}
"print"                {printf("PRINT\n");}
"return"               {printf("RETURN\n");}
"null"                 {printf("NULL\n");}
\'([^\'\\\n]|(\\.))*\' {printf("STRING(%s)\n", yytext);}
\"([^\"\\\n]|(\\.))*\" {printf("STRING(%s)\n", yytext);}
[a-zA-Z][a-zA-Z0-9_]*  {yylval.sValue = strdup(yytext); return ID;}
.                      {printf("Invalid character.\n");}

%%

#ifndef yywrap
  int yywrap (void) {return 1;}
#endif
