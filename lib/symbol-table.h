#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct SymbolTableEntry {
  char *identifier;
  char *type;
} SymbolTableEntry;

typedef struct SymbolTable {
  SymbolTableEntry **entries;
  int size;
} SymbolTable;

SymbolTable* createSymbolTable(int size);
void destroySymbolTable(SymbolTable *table);
int hash(const char *str, int size);
void insertSymbol(SymbolTable *table, const char *identifier, const char *type, const int scope);
char* lookupSymbolType(SymbolTable *table, const char *identifier);

#endif
