#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void freeRecord(record * r){
  if (r) {
    if (r->code != NULL) free(r->code);
	  if (r->opt1 != NULL) free(r->opt1);
    free(r);
  }
}

record * createRecord(char * c1, char * c2){
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->code = strdup(c1);
  r->opt1 = strdup(c2);

  return r;
}

void checkType (char* typeOne, char* typeTwo){ 
    if(typeOne == NULL || typeTwo == NULL) {
            fprintf (stderr, "Um erro de inesperado de tipagem ocorreu! Linha: %d\n", yylineno);
            exit(0);
    }
    if(((strcmp(typeOne, "int") == 0) && (strcmp(typeTwo, "str") == 0)) || ((strcmp(typeOne, "str") == 0) && (strcmp(typeTwo, "int") == 0))) {
            fprintf (stderr, "ERROR: String e Int não podem ser operados/atribuidos. Linha: %d\n", yylineno);
            exit(0);
    }
    if(((strcmp(typeOne, "int") == 0) && (strcmp(typeTwo, "char") == 0)) || ((strcmp(typeOne, "char") == 0) && (strcmp(typeTwo, "int") == 0))) {
            fprintf (stderr, "ERROR: Char e Int não podem ser operados/atribuidos. Linha: %d\n", yylineno);
            exit(0);
    }
    if(((strcmp(typeOne, "float") == 0) && (strcmp(typeTwo, "str") == 0)) || ((strcmp(typeOne, "str") == 0) && (strcmp(typeTwo, "float") == 0))) {
            fprintf (stderr, "ERROR: String e Float não podem ser operados/atribuidos. Linha: %d\n", yylineno);
            exit(0);
    }
    if(((strcmp(typeOne, "char") == 0) && (strcmp(typeTwo, "float") == 0)) || ((strcmp(typeOne, "float") == 0) && (strcmp(typeTwo, "char") == 0))) {
            fprintf (stderr, "ERROR: Char e Float não podem ser operados/atribuidos. Linha: %d\n", yylineno);
            exit(0);
    }

}


