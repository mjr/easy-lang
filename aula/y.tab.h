/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
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
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    TYPE = 259,
    NUMBER = 260,
    FUNC = 261,
    ENDFUNC = 262,
    WHILE = 263,
    ENDWHILE = 264,
    IF = 265,
    ELSE = 266,
    ENDIF = 267,
    ASSIGNMENT = 268,
    FOR = 269,
    ENDFOR = 270,
    EQUALS = 271,
    NOT_EQUALS = 272,
    GREATER_THAN = 273,
    LESS_THAN = 274,
    GREATER_THAN_OR_EQUAL = 275,
    LESS_THAN_OR_EQUAL = 276,
    OP_PLUS = 277,
    OP_MINUS = 278,
    OP_DIV = 279,
    OP_MULT = 280,
    LBRACKET = 281,
    RBRACKET = 282,
    DECREMENT = 283,
    INCREMENT = 284,
    SUBTRACTION_ASSIGNMENT = 285,
    ADITION_ASSIGNMENT = 286,
    LOGICAL_AND = 287,
    LOGICAL_OR = 288
  };
#endif
/* Tokens.  */
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
#define OP_PLUS 277
#define OP_MINUS 278
#define OP_DIV 279
#define OP_MULT 280
#define LBRACKET 281
#define RBRACKET 282
#define DECREMENT 283
#define INCREMENT 284
#define SUBTRACTION_ASSIGNMENT 285
#define ADITION_ASSIGNMENT 286
#define LOGICAL_AND 287
#define LOGICAL_OR 288

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 18 "parser.y"

    char * sValue;  /* string value */
    struct record * rec;
 

#line 129 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
