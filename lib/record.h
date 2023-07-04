#ifndef RECORD
#define RECORD

extern int yylineno;

struct record {
  char * code; /* field for storing the output code */
  char * opt1; /* field for another purpose */
};

typedef struct record record;

void freeRecord(record *);
record * createRecord(char *, char *);


void checkType(char* typeOne, char* typeTwo);

#endif
