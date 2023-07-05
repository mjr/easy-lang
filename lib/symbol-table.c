#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CAPACITY 32

typedef struct SymbolTableEntry {
  char *identifier;
  char *type;
  int scope;
} SymbolTableEntry;

typedef struct SymbolTable {
  SymbolTableEntry **entries;
  int size;
} SymbolTable;

int stack[CAPACITY];
int pointer = 1;

void push(int __key) {
    if (pointer < CAPACITY)
        stack[pointer++] = __key;
}

void pop(void) {
    pointer -= 1;
}

int top(void) {
    return stack[pointer-1];
}

int previous(int __key) {
    for (int i = 0; i < pointer; ++i) 
        if (stack[i] == __key)
            return stack[i-1];
    return -1;
}

void print_stack() {
    for (int i = 0; i < pointer; ++i) 
        printf("%d", stack[i]);
    printf(" ----- STACK\n");
}


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

void insertSymbol(SymbolTable *table, const char *identifier, const char *type, const int scope) {
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
