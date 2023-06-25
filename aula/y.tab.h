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
    STRING = 261,                  /* STRING  */
    FUNC = 262,                    /* FUNC  */
    ENDFUNC = 263,                 /* ENDFUNC  */
    WHILE = 264,                   /* WHILE  */
    ENDWHILE = 265,                /* ENDWHILE  */
    IF = 266,                      /* IF  */
    ELSE = 267,                    /* ELSE  */
    ENDIF = 268,                   /* ENDIF  */
    ASSIGNMENT = 269,              /* ASSIGNMENT  */
    FOR = 270,                     /* FOR  */
    ENDFOR = 271,                  /* ENDFOR  */
    EQUALS = 272,                  /* EQUALS  */
    NOT_EQUALS = 273,              /* NOT_EQUALS  */
    GREATER_THAN = 274,            /* GREATER_THAN  */
    LESS_THAN = 275,               /* LESS_THAN  */
    GREATER_THAN_OR_EQUAL = 276,   /* GREATER_THAN_OR_EQUAL  */
    LESS_THAN_OR_EQUAL = 277,      /* LESS_THAN_OR_EQUAL  */
    OP_PLUS = 278,                 /* OP_PLUS  */
    OP_MINUS = 279,                /* OP_MINUS  */
    OP_DIV = 280,                  /* OP_DIV  */
    OP_MULT = 281,                 /* OP_MULT  */
    LBRACKET = 282,                /* LBRACKET  */
    RBRACKET = 283,                /* RBRACKET  */
    DECREMENT = 284,               /* DECREMENT  */
    INCREMENT = 285,               /* INCREMENT  */
    SUBTRACTION_ASSIGNMENT = 286,  /* SUBTRACTION_ASSIGNMENT  */
    ADITION_ASSIGNMENT = 287,      /* ADITION_ASSIGNMENT  */
    LOGICAL_AND = 288,             /* LOGICAL_AND  */
    LOGICAL_OR = 289,              /* LOGICAL_OR  */
    PRINT = 290                    /* PRINT  */
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
#define STRING 261
#define FUNC 262
#define ENDFUNC 263
#define WHILE 264
#define ENDWHILE 265
#define IF 266
#define ELSE 267
#define ENDIF 268
#define ASSIGNMENT 269
#define FOR 270
#define ENDFOR 271
#define EQUALS 272
#define NOT_EQUALS 273
#define GREATER_THAN 274
#define LESS_THAN 275
#define GREATER_THAN_OR_EQUAL 276
#define LESS_THAN_OR_EQUAL 277
#define OP_PLUS 278
#define OP_MINUS 279
#define OP_DIV 280
#define OP_MULT 281
#define LBRACKET 282
#define RBRACKET 283
#define DECREMENT 284
#define INCREMENT 285
#define SUBTRACTION_ASSIGNMENT 286
#define ADITION_ASSIGNMENT 287
#define LOGICAL_AND 288
#define LOGICAL_OR 289
#define PRINT 290

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 18 "parser.y"

    char * sValue;  /* string value */
    struct record * rec;
 

#line 143 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
