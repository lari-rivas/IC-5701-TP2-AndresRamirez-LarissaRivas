#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Nodo{
   char *tipo;   
   char *content;   
   struct Nodo* hijo;
   struct Nodo* hermano;  
}nodo;

nodo *crear_nodo(char *tiponodo, char *contenido){
  nodo* nuevo = (nodo*)malloc(sizeof(nodo));
  nuevo->tipo = (char *)malloc(sizeof(tiponodo)+1);
  strcpy(nuevo->tipo, tiponodo);
  nuevo->content = (char *)malloc(sizeof(contenido)+1);
  strcpy(nuevo->content, contenido);
  return nuevo;
};

nodo *crear_padre(char *tiponodo){
  nodo* nuevo = (nodo*)malloc(sizeof(nodo));
  nuevo->tipo = (char *)malloc(sizeof(tiponodo)+1);
  strcpy(nuevo->tipo, tiponodo);
  return nuevo;
};

// IMPRIMIR ARBOL
void imprimir_margin (int margin, nodo *arbol){
  int i;
  for (i=0; i < margin; i++) printf("-");
  if(arbol->content == NULL){
    printf(" %s \n", arbol->tipo);
  }
  else
  {
    printf(" %s : %s \n", arbol->tipo, arbol->content);
  }
  
  
}


void imprimir_aux(int margin, nodo *arbol){
  if(arbol->hijo != NULL){
    if (strcmp(arbol->tipo, "vacio")!=0){
       imprimir_margin(margin, arbol);
      }
    imprimir_aux(margin+2, arbol->hijo);
  }
  else{
    if (strcmp(arbol->tipo, "vacio")!=0){
       imprimir_margin(margin, arbol);
      }      
  }
  if(arbol->hermano != NULL){
    imprimir_aux(margin, arbol->hermano);
  }
}

void imprimir (nodo *arbol){
  int margin =0;
  imprimir_aux(margin, arbol); 
}

//  FUNCION PARA ENCONTRAR EL ULTIMO EN LOS RECURSIVOS
nodo *encontrar_ultimo (nodo *nodo){
  if(nodo->hermano == NULL)
  {
    return nodo;
  }
  else
  {
    encontrar_ultimo(nodo->hermano);
  }
}