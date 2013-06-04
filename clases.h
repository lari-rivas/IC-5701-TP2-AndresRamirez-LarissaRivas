#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//  estructura del nodo del arbol que contiene los datos donde se guardan lo recolectado de la gramatica y analizador lexico

typedef struct Nodo{
   char *tipo;   
   char *content;   
   struct Nodo* hijo;	// posee al puntero hijo de quien el es padre
   struct Nodo* hermano;  // posee 1 solo hermano, el cual se accede con un puntero al hermano del hermano y estos a su vez son hijos indirectos de puntero 
			 //    que lo senala con el puntero de hijo.
}nodo;			// se define la estrucutra Nodo como nodo.


//   funcion que permite crear un nodo a traves de la funcion malloc y asignacinar con la libreria string.h la informacion al nodo.
//   este metodo devulve un puntero al nodo creado
nodo *crear_nodo(char *tiponodo, char *contenido){
  nodo* nuevo = (nodo*)malloc(sizeof(nodo));
  nuevo->tipo = (char *)malloc(sizeof(tiponodo)+1);
  strcpy(nuevo->tipo, tiponodo);
  nuevo->content = (char *)malloc(sizeof(contenido)+1);
  strcpy(nuevo->content, contenido);
  return nuevo;
};
//  funciona igual a la funcion anterior, con la difencia de que posee entrada 1 parametro
nodo *crear_padre(char *tiponodo){
  nodo* nuevo = (nodo*)malloc(sizeof(nodo));
  nuevo->tipo = (char *)malloc(sizeof(tiponodo)+1);
  strcpy(nuevo->tipo, tiponodo);
  return nuevo;
};

// IMPRIMIR ARBOL 
//   imprime el tipo de nodo y los margenes para representar la jerarquia de los nodos del arbol
void imprimir_margin (int margin, nodo *arbol){
  int i;
  for (i=0; i < margin; i++) printf("-");
    printf(" %s \n", arbol->tipo);    
}

//  funcion auxiliar llamada por imprimir para realizar recursion, busca el ultimo nodo sin hijos, y comienza a recorrer los hermanos
void imprimir_aux(int margin, nodo *arbol){
  if(arbol->hijo != NULL){
    if (strcmp(arbol->tipo, "vacio")!=0){
       imprimir_margin(margin, arbol);
      }
    imprimir_aux(margin+3, arbol->hijo);
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

//   funcion que llama a la funcion recursiva de imprimir. no devuelve nada

void imprimir (nodo *arbol){
  int margin =0;
  imprimir_aux(margin, arbol); 
}

//  FUNCION PARA ENCONTRAR EL ULTIMO EN LOS RECURSIVOS
  // recorre a los hermanos hatas encontrar el nulo. utilizado para devolver el ultimo hermano y pegarle el puntero
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