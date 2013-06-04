%{ 
  #include <stdio.h>
  #include <assert.h>
  #include "clases.h"   /* contiene las estructuras y metodos de las funciones que se utilizan para construir el arbol e imprimirlo en consola */
  void yyerror (char const *s);
%}
  //se incluye location para el uso de la variable yylloc
%locations  

/*  redefine el valor la varible de yylval permitiendole poseer 2 tipos de contenido, un puntero char  o un struct de tipo nodo que esta en clases.h */
%union{
  char *contenido;
  struct Nodo *node;
}

 /* redefinen los tokens terminales de la gramatica definiendolos como tipos de punteros a char */

%token <contenido> T_ENTER T_SPACE
%token <contenido> T_COMMENT_IN T_COMMENT_END
%token <contenido> T_CDATA_I T_CDATA_F CONT_DATA
%token <contenido> T_XMLDEC T_F_XMLDEC T_EQ T_ENCOD T_ENDID T_VNUMBER T_VS
%token <contenido> T_DOCTYPE T_SYSTEM T_PULIC T_NAME T_ENDDOCTYPE T_PUBIDLIT T_SYSTLIT
%token <contenido> T_ETAG T_TAG T_FTAG
%token <contenido> T_ESTAG T_CONTENT T_ATRIBUTO T_FIN_ETAG T_FIN_STAG
%token <contenido>  T_CONTENIDO

/*   define los no terminales como punteros de struct de nodo, que permiten tenerles difentes datos almacenados.  
    Estos no terminales son definidos en la gramatica y que aparecen todos del lado izquierdo seguido de dos puntos. */
%type <node> Prolog Element CONTENT OPCIONES SCTAG ESTAG EETAG T_ATRIB Misc OPCIONESMisc T_COMMENT T_S T_SS Doctype ExternalID_E XMLdec XMLdec_E VersionINfo EncoDecl ETAG

/*   Implementacion de asociatividad por la izquierda para eliminar problemas en la gramatica como reduce reduce, o shit-reduce */
%left T_TAG T_ESTAG T_COMMENT_IN T_SPACE

%%

/*  las reglas gramaticales que reciben un token por parte del scanner e intenta acomodarlo en alguna que encaje
    aparecen de mas general a mas especifico para que se puedan llamar a no terminales que esten debajo de las creadas.
    
    la gramatica de comienzo es el Document  como punto inicial de construccion
    cada terminal o no terminal es un struct nodo que se encuentra en el clases.h que son llamados a traves de sus funciones*/
Document : Prolog T_S Element 				{
								 nodo* padre = crear_padre("Document"); /*se concluye con la construccion del arbol y la gramatica*/
								 $1->hermano = $2;
								 $2->hermano=$3;
								 padre->hijo=$1;
								 printf("\n");
								 imprimir(padre); /*se invoca al metodo imprimir para mostrar en consola el arbol construido*/
								 }	
	  ;   
    
Element : EETAG 						{
								 nodo* padre = crear_padre("ELEMENT");
								 padre->hijo=$1;
								 $$=padre;}
	| SCTAG 						{
								 nodo* padre = crear_padre("ELEMENT");
								 padre->hijo=$1;
								 $$=padre;}
	; 

SCTAG : ESTAG CONTENT ETAG 					{ 
								  nodo* padre = crear_padre("SCTAG");
								  nodo* nodo2 = crear_padre("CONTENT");
								  nodo2->hijo = $2;
								  $1->hermano=nodo2;
								  nodo2->hermano=$3;
								  padre->hijo=$1;
								  $$=padre;}	
      ;
      
CONTENT : CONTENT OPCIONES 					{								 
								 nodo* ultimo = encontrar_ultimo($1);
								 ultimo->hermano = $2;
								 $$ = $1;
								 }
	|							{nodo* nodo_padre = crear_padre ("vacio");
								$$ = nodo_padre;}
	;
OPCIONES : T_COMMENT    					{nodo* padre = crear_padre("OPCIONES");
								 padre->hijo=$1;
								 $$=padre;}
	 | T_SS         					{nodo* padre = crear_padre("OPCIONES");
								 padre->hijo=$1;
								 $$=padre;}
	 | Element      					{nodo* padre = crear_padre("OPCIONES");
								 padre->hijo=$1;
								 $$=padre;}
	 | T_CONTENIDO  					{
								 nodo* nodo1 = crear_nodo("T_CONTENIDO",$1);
								 nodo* padre = crear_padre("OPCIONES");
								 padre->hijo=nodo1;
								 $$=padre;}
	 ;

ESTAG :T_ESTAG T_TAG T_ATRIB T_S T_FIN_STAG   			{
								 nodo* nodo1 = crear_nodo("T_ESTAG", $1); 								  
								 nodo* nodo2 = crear_nodo("T_TAG", $2);
								 
								 nodo* nodo3 = crear_padre("T_ATRIB");
								 nodo* nodo5 = crear_nodo("T_FIN_STAG", $5);
								 nodo* padre = crear_padre("ESTAG");
								 nodo3->hijo = $3;
								 nodo1->hermano=nodo2;
								 nodo2->hermano=nodo3;
								 nodo3->hermano=$4;
								 $4->hermano=nodo5;
								 padre->hijo=nodo1;
								 $$=padre;}
     
      ;
       
EETAG : T_ESTAG T_TAG T_ATRIB T_S T_FIN_ETAG 			{
								nodo* nodo1 = crear_nodo("T_ESTAG", $1);
								nodo* nodo2 = crear_nodo("T_TAG", $2);								
								nodo* nodo3 = crear_padre("T_ATRIB");
								nodo* nodo5 = crear_nodo("T_FIN_ETAG", $5);
								nodo* padre = crear_padre("EETAG");
	 							nodo3->hijo = $3;
								nodo1->hermano=nodo2;								
								nodo2->hermano=nodo3;
								nodo3->hermano = $4;
								$4->hermano = nodo5;
								padre->hijo=nodo1;
								$$=padre;}
	
      ;

T_ATRIB : 							{ 
								nodo* nodo_padre = crear_padre ("vacio");
								$$ = nodo_padre;}
	| T_ATRIB T_SS T_ATRIBUTO T_EQ T_CONTENT 		{
								 nodo* nodo3 = crear_nodo("T_Atributo", $3);
								 nodo* nodo4 = crear_nodo("T_EQ", "=");								 
								 nodo* nodo5 = crear_nodo("T_CONTENT", $5);								 
								 $2->hermano = nodo3;
								 nodo3->hermano=nodo4;
								 nodo4->hermano=nodo5;
								 nodo *ultimo = encontrar_ultimo($1);
								 ultimo->hermano = $2;
								 
								 $$=$1;}
	
	; 

Prolog : XMLdec Misc Doctype 					{
								nodo* padre = crear_padre("Prolog");
								$1->hermano=$2;
								$2->hermano=$3;
								padre->hijo=$1;
								$$=padre;
								}	
	
       ;
       
       
Misc : Misc OPCIONESMisc 					{nodo* padre = crear_padre("Misc");
								$1->hermano=$2;
								padre->hijo=$1;
								$$=padre;
								}
     | 								{
								nodo* nodo_padre = crear_padre ("vacio");
								$$ = nodo_padre;}
     ;

OPCIONESMisc: T_COMMENT 					{
								 nodo* padre = crear_padre("OpcionesMisc");
								 padre->hijo=$1;
								 $$=padre;} 
	    | T_SPACE 						{
								nodo* nodo_padre = crear_padre("OpcionesMisc");
								nodo* nodo1 = crear_nodo("T_SPACE", $1);
								nodo_padre->hijo=nodo1;
								$$ = nodo_padre;}
	    ;
     
    
Doctype : T_DOCTYPE T_SS T_NAME ExternalID_E T_S T_ENDDOCTYPE 	{								 
								 nodo* nodo1 = crear_nodo("T_DOCTYPE",$1);
								 nodo* nodo3 = crear_nodo("T_NAME", $3);
								 nodo* nodo6 = crear_nodo("T_ENDOCTYPE", $6);
								 nodo* padre = crear_padre("DOCTYPE");
								 nodo1->hermano = $2;
								 $2->hermano=nodo3;
								 nodo3->hermano=$4;
								 $4->hermano=$5;
								 $5->hermano=nodo6;
								 padre->hijo=nodo1;
								 $$=padre;}
	| T_DOCTYPE T_SS T_NAME T_S T_ENDDOCTYPE 		{   								  
								 nodo* nodo1 = crear_nodo("T_DOCTYPE",$1);
								 nodo* nodo3 = crear_nodo("T_NAME", $3);
								 nodo* nodo5 = crear_nodo("T_ENDOCTYPE", $5);
								 nodo* padre = crear_padre("DOCTYPE");
								 nodo1->hermano = $2;
								 $2->hermano=nodo3;
								 nodo3->hermano=$4;
								 $4->hermano=nodo5;
								 padre->hijo=nodo1;
								 $$=padre;}		
	
	; 


ExternalID_E : T_SS T_SYSTEM T_SS T_SYSTLIT 			{
								nodo* nodo2 = crear_nodo("T_SYSTEM", $2);
								nodo* nodo4 = crear_nodo("T_SYSTLIT", $4);
								nodo* padre = crear_padre("ExternalID_E");
								$1->hermano = nodo2;
								nodo2->hermano = $3;
								$3->hermano = nodo4;
								padre->hijo=$1;
								$$=padre;
								}
	     |T_SS T_PULIC T_SS T_PUBIDLIT T_S T_SYSTLIT	{ 
								nodo* nodo2 = crear_nodo("T_PUBLIC", $2);
								nodo* nodo4 = crear_nodo("T_PUBIDLIT", $4);
								nodo* nodo6 = crear_nodo("T_SYSTLIT", $6);
								nodo* padre = crear_padre("ExternalID_E");
								$1->hermano = nodo2;
								nodo2->hermano = $3;
								$3->hermano = nodo4;
								nodo4->hermano = $5;
								$5->hermano = nodo6;
								padre->hijo=$1;
								$$=padre;}
	
	     ;
    
    
XMLdec : XMLdec_E 						{
								 nodo* padre = crear_padre("XMLdec");
								 padre -> hijo=$1;
								 $$ = padre;}
       |							{nodo* nodo_padre = crear_padre ("vacio");
								$$ = nodo_padre;}
       ; 
       
       
XMLdec_E : T_XMLDEC VersionINfo EncoDecl T_S T_F_XMLDEC 	{nodo* nodo1 = crear_nodo("T_XMLDEC", $1);
								 nodo* nodo5 = crear_nodo("T_F_XMLDEC", $5);
								 nodo* padre = crear_padre("XMLdec_E");
								 nodo1->hermano = $2;
								 $2 -> hermano = $3;
								 $3 -> hermano = $4;
								 $4 -> hermano = nodo5;
								 padre->hijo = nodo1;
								 $$ = padre;}
	  | T_XMLDEC VersionINfo T_S T_F_XMLDEC 		{ nodo* nodo1 = crear_nodo("T_XMLDEC", $1);
								 nodo* nodo4 = crear_nodo("T_F_XMLDEC", $4);
								 nodo* padre = crear_padre("XMLdec_E");
								 nodo1->hermano = $2;
								 $2 -> hermano = $3;
								 $3 -> hermano = nodo4;
								 padre->hijo = nodo1;
								 $$ = padre;}
	
	  ;



VersionINfo : T_SS T_VS T_EQ T_VNUMBER 				{								
								nodo* nodo2 = crear_nodo("Version", $2);
								nodo* nodo3 = crear_nodo("EQ", "=");
								nodo* nodo4 = crear_nodo("NumVersion", $4);
								nodo* padre = crear_padre("Info_Version");
								$1->hermano = nodo2;
								nodo2->hermano = nodo3;
								nodo3->hermano = nodo4;
								padre->hijo = $1;
								$$ = padre;
								}		
	    ;



EncoDecl : T_SS T_ENCOD T_EQ T_ENDID 				{
								 nodo* nodo2 = crear_nodo("Encod", $2);
								 nodo* nodo3 = crear_nodo("EQ", "=");
								 nodo* nodo4 = crear_nodo("ENDID", $4);
								 nodo* padre = crear_padre("EncodingDecl");
								 $1->hermano = nodo2;
								 nodo2->hermano = nodo3;
								 nodo3->hermano = nodo4;
								 padre->hijo=$1;
								 $$ = padre;}
	
	 ; 



ETAG : T_ETAG T_TAG T_S T_FTAG 					{ 
								  nodo* nodo1 = crear_nodo("tag de inicio", $1);
								  nodo* nodo2 = crear_nodo("tag",$2);
								  nodo* nodo4 = crear_nodo("tag de cierre", $4);
								  nodo* padre = crear_padre("Etag");
								  nodo1->hermano = nodo2;
								  nodo2->hermano = $3;
								  $3->hermano = nodo4;
								  padre->hijo=nodo1;
								  $$ = padre;
								}
	
     ; 

     
     
T_COMMENT : T_COMMENT_IN T_COMMENT_END 				{ nodo* nodo1 = crear_nodo("comentario inicio", $1);
								  nodo* nodo2 = crear_nodo("comentario cerrar", $2);
								  nodo1->hermano = nodo2;
								  nodo* nodo_padre = crear_padre("comentario");
								  nodo_padre->hijo = nodo1;
								  $$ =  nodo_padre;}
	  ;



T_SS : T_SPACE  						{ 
								nodo* nodo_padre = crear_padre("T_SS");
								nodo* nodo1 = crear_nodo("T_SPACE", " ");
								nodo_padre->hijo=nodo1;
								$$ = nodo_padre;}
     |  T_SPACE T_SS 						{  
								nodo* nodo_padre = crear_padre("T_SS");
								nodo* nodo1 = crear_nodo("T_SPACE", " ");
								nodo1->hermano = $2;
								nodo_padre->hijo=nodo1;
								$$ = nodo_padre; }
     ;   



T_S : T_SPACE T_S 						{ 
								nodo* nodo_padre = crear_padre("T_S");
								nodo* nodo1 = crear_nodo("T_SPACE", " ");
								nodo1->hermano = $2;
								nodo_padre->hijo=nodo1;
								$$ = nodo_padre; }
    |								{ 
								nodo* nodo_padre = crear_padre ("vacio");
								$$ = nodo_padre;}
    ;
    // ----------------------------------------------------------- BUENOS ---------------------------------------------->>


%%

/*  funcion de error que cuando se intenta hacer un elemento que no este correcto se llama a yyerror con un puntero que indicara el tipo de error presentado, 
    ademas imprime  el numero de linea y columna donde se encuentra el error, que son variables del yylloc */
void yyerror (char const *s)
     {
       fprintf (stderr, "ERROR EN POSICION: %d, %d: %s\n", yylloc.first_line, yylloc.first_column, s);
     }
     
/*      la funcion main se encarga de llamar el yyparse el cual se encarga de llamar a su vez al scanner y comienza a pedir tokens
	los cuales son procesados en la gramatica. la funcion termina cuando el scanner no le envie mas tokens*/

int main() {
	return yyparse();
}