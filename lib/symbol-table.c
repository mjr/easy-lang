#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct SymbolTableEntry {
  char *identifier;
  char *type;
} SymbolTableEntry;

typedef struct SymbolTable {
  SymbolTableEntry **entries;
  int size;
} SymbolTable;

SymbolTable* createSymbolTable(int size) {
  SymbolTable *table = malloc(sizeof(SymbolTable));
  table->entries = calloc(size, sizeof(SymbolTableEntry*));
  table->size = size;
  return table;
}

void destroySymbolTable(SymbolTable *table) {
  if (table == NULL) return;
  for (int i = 0; i < table->size; i++) {
    SymbolTableEntry *entry = table->entries[i];
    if (entry != NULL) {
      free(entry->identifier);
      free(entry->type);
      free(entry);
    }
  }
  free(table->entries);
  free(table);
}

int hash(const char *str, int size) {
  int hash = 0;
  int len = strlen(str);
  for (int i = 0; i < len; i++) {
    hash = (hash * 31 + str[i]) % size;
  }
  return hash;
}

void insertSymbol(SymbolTable *table, const char *identifier, const char *type) {
  int index = hash(identifier, table->size);
  SymbolTableEntry *entry = malloc(sizeof(SymbolTableEntry));
  entry->identifier = strdup(identifier);
  entry->type = strdup(type);
  table->entries[index] = entry;
}

char* lookupSymbolType(SymbolTable *table, const char *identifier) {
  int index = hash(identifier, table->size);
  SymbolTableEntry *entry = table->entries[index];
  if (entry != NULL && strcmp(entry->identifier, identifier) == 0) {
    return entry->type;
  }
  return NULL;
}
