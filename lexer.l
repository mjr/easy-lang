%{
  #include <stdio.h>
%}

%%

[ \t\n]               ;
[0-9]+                {printf("NUMBER(%s)\n",yytext);}
"func"                {printf("FUNC\n");}
"endfunc"             {printf("ENDFUNC\n");}
"while"               {printf("WHILE\n");}
"endwhile"            {printf("ENDWHILE\n");}
"for"                 {printf("FOR\n");}
"endfor"              {printf("ENDFOR\n");}
"if"                  {printf("IF\n");}
"endif"               {printf("ENDIF\n");}
"else"                {printf("ELSE\n");}
"'"                   {printf("SQUOTE\n");}
"\""                  {printf("DQUOTE\n");}
"("                   {printf("LPAREN\n");}
")"                   {printf("RPAREN\n");}
";"                   {printf("SEMICOLON\n");}
","                   {printf("COMMA\n");}
"="                   {printf("ASSIGNMENT\n");}
[a-zA-Z][a-zA-Z0-9]*  {printf("ID(%s)\n",yytext);}
.                     {printf("Invalid character.\n");}

%%

#ifndef yywrap
  int yywrap (void) {return 1;}
#endif

int main(void) {
  yylex();
  return 0;
}
