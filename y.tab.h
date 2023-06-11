/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    TYPE = 259,                    /* TYPE  */
    NUMBER = 260,                  /* NUMBER  */
    FUNC = 261,                    /* FUNC  */
    ENDFUNC = 262,                 /* ENDFUNC  */
    WHILE = 263,                   /* WHILE  */
    ENDWHILE = 264,                /* ENDWHILE  */
    IF = 265,                      /* IF  */
    ELSE = 266,                    /* ELSE  */
    ENDIF = 267,                   /* ENDIF  */
    ASSIGNMENT = 268,              /* ASSIGNMENT  */
    FOR = 269,                     /* FOR  */
    ENDFOR = 270,                  /* ENDFOR  */
    EQUALS = 271,                  /* EQUALS  */
    NOT_EQUALS = 272,              /* NOT_EQUALS  */
    GREATER_THAN = 273,            /* GREATER_THAN  */
    LESS_THAN = 274,               /* LESS_THAN  */
    GREATER_THAN_OR_EQUAL = 275,   /* GREATER_THAN_OR_EQUAL  */
    LESS_THAN_OR_EQUAL = 276,      /* LESS_THAN_OR_EQUAL  */
    ADITION_ASSIGNMENT = 277,      /* ADITION_ASSIGNMENT  */
    OP_PLUS = 278                  /* OP_PLUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define ID 258
#define TYPE 259
#define NUMBER 260
#define FUNC 261
#define ENDFUNC 262
#define WHILE 263
#define ENDWHILE 264
#define IF 265
#define ELSE 266
#define ENDIF 267
#define ASSIGNMENT 268
#define FOR 269
#define ENDFOR 270
#define EQUALS 271
#define NOT_EQUALS 272
#define GREATER_THAN 273
#define LESS_THAN 274
#define GREATER_THAN_OR_EQUAL 275
#define LESS_THAN_OR_EQUAL 276
#define ADITION_ASSIGNMENT 277
#define OP_PLUS 278

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 12 "parser.y"

  int    iValue;  /* integer value */
  char   cValue;  /* char value */
  char * sValue;  /* string value */

#line 119 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
