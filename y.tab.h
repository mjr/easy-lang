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
    STRING = 261,
    FUNC = 262,
    ENDFUNC = 263,
    WHILE = 264,
    ENDWHILE = 265,
    IF = 266,
    ELSE = 267,
    ENDIF = 268,
    ASSIGNMENT = 269,
    FOR = 270,
    ENDFOR = 271,
    EQUALS = 272,
    NOT_EQUALS = 273,
    GREATER_THAN = 274,
    LESS_THAN = 275,
    GREATER_THAN_OR_EQUAL = 276,
    LESS_THAN_OR_EQUAL = 277,
    OP_PLUS = 278,
    OP_MINUS = 279,
    OP_DIV = 280,
    OP_MULT = 281,
    LBRACKET = 282,
    RBRACKET = 283,
    DECREMENT = 284,
    INCREMENT = 285,
    SUBTRACTION_ASSIGNMENT = 286,
    ADITION_ASSIGNMENT = 287,
    LOGICAL_AND = 288,
    LOGICAL_OR = 289,
    PRINT = 290,
    SCAN = 291
  };
#endif
/* Tokens.  */
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
#define SCAN 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 18 "parser.y"

    char * sValue;  /* string value */
    struct record * rec;
 

#line 135 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
