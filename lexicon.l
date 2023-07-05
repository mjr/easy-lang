%{
  #include <stdio.h>
  #include "y.tab.h"

  extern int yyerror (char *msg);  
%}

%%

"//"(.)*
[ \t]                   ;
\n                      {yylineno++;}
"func"                  {return FUNC;}
"endfunc"               {return ENDFUNC;}
"if"                    {return IF;}
"else"                  {return ELSE;}
"endif"                 {return ENDIF;}
"main"                  {return MAIN;}
"endmain"               {return ENDMAIN;}
"print"                 {return PRINT;}
"return"                {return RETURN;}
"while"                 {return WHILE;}
"endwhile"              {return ENDWHILE;}
"("                     {return yytext[0];}
")"                     {return yytext[0];}
"["                     {return yytext[0];}
"]"                     {return yytext[0];}
","                     {return yytext[0];}
":"                     {return yytext[0];}
";"                     {return yytext[0];}
"="                     {return ASSIGN;}
"+"                     {return OPPLUS;}
"-"                     {return OPMINUS;}
"*"                     {return OPMULT;}
"/"                     {return OPDIV;}
"**"                    {return OPEXP;}
"&"                     {return yytext[0];}
"=="                    {return OPEQ;}
"!="                    {return DIFF;}
">"                     {return HIGHER;}
"<"                     {return LESS;}
">="                    {return HIGHER_EQ;}
"<="                    {return LESS_EQ;}
"&&"                    {return AND;}
"!"                     {return NOT;}
"bool"                  {yylval.sValue = strdup("bool"); return TYPE;}
"int"                   {yylval.sValue = strdup("int"); return TYPE;}
"float"                 {yylval.sValue = strdup("float"); return TYPE;}
"str"                   {yylval.sValue = strdup("str"); return TYPE;}
[0-9]+                  {yylval.sValue = strdup(yytext); return INT;}
[0-9]\.[0-9]+           {yylval.sValue = strdup(yytext); return FLOAT;}
\"[a-zA-Z0-9 é]*\"      {yylval.sValue = strdup(yytext); return STRING;}
"true"                  {yylval.sValue = strdup(yytext); return BOOLEAN;}
"false"                 {yylval.sValue = strdup(yytext); return BOOLEAN;}
[a-zA-Z][a-zA-Z0-9]*    {yylval.sValue = strdup(yytext); return ID;}
.                       {yyerror("Invalid character");}

%%

#ifndef yywrap
  int yywrap (void) {return 1;}
#endif
