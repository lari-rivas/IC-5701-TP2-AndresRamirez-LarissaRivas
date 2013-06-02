%{
  #include <stdio.h>
  #include <assert.h>
  void yyerror (char const *s);
%}

 /* modifica la variable yylval para obtener los tipos requeridos.*/
%union{    
    char *contenido;
}

 /* TOKENS!!!! */
 
 
 
%token T_ENTER T_SPACE
%token T_COMMENT_IN T_COMMENT_END
%token T_CDATA_I T_CDATA_F CONT_DATA
%token T_XMLDEC T_F_XMLDEC T_EQ T_ENCOD T_ENDID T_VNUMBER T_VS
%token T_DOCTYPE T_SYSTEM T_PULIC T_NAME T_ENDDOCTYPE T_PUBIDLIT T_SYSTLIT
%token T_ETAG T_TAG T_FTAG
%token T_ESTAG T_CONTENT T_ATRIBUTO T_FIN_ETAG T_FIN_STAG
/*T_ESTAG*/

%token  T_CONTENIDO

%left T_TAG T_ESTAG T_COMMENT_IN T_SPACE

%%
/* REGLAS

corregir espacio! */
/*

*/
/*  
CONTENT : CONTENT Element {}
| CONTENT CDSect {}
| CONTENT T_COMMENT {}
| CONTENT T_SPACE {}
|
; */


/* CDSect : T_CDATA_I CONT_DATA T_CDATA_F { printf ("cdsect!!!   ");} */
/*        ; 	   */	  

    // ----------------------------------------------------------- BUENOS ---------------------------------------------->>
    
Document : Prolog T_S Element {printf("document!!  "); }  /*Misc*/
	  ;   
    
Element : EETAG {printf ("eetag!!  ");}
	| SCTAG {printf ("sctag!!  ");}
	; 
	
SCTAG : ESTAG CONTENT ETAG { printf (" sctag ");}
      ;
      
CONTENT : CONTENT OPCIONES {}
	|
	;
OPCIONES : T_COMMENT    {}
	 | T_SS         {}
	 | Element      {}
	 | T_CONTENIDO  {printf("contenido! ");}
	 ;
	 
ESTAG :T_ESTAG T_TAG T_ATRIB T_S T_FIN_STAG   {printf (" tag inicio ...");}
      ;
      
EETAG : T_ESTAG T_TAG T_ATRIB T_S T_FIN_ETAG {printf(" EETAG 2 ");} 
      ;

T_ATRIB : 	{ printf (" atributo vacio ");}
	| T_ATRIB T_SS T_ATRIBUTO T_EQ T_CONTENT { printf (" atributo ");}	
	; 
	
Prolog : XMLdec Misc Doctype 					{ printf(" Prolog ");}	
       ;
       
       
Misc : Misc OPCIONESMisc
     | {printf(" NADA " );}
     ;

OPCIONESMisc: T_COMMENT {printf(" MISC Comment ");} 
	    | T_SPACE {printf(" MISC ESP");}
	    ;
     
    
Doctype : T_DOCTYPE T_SS T_NAME ExternalID_E T_S T_ENDDOCTYPE 	{printf(" DOCTYPE ");}	
	| T_DOCTYPE T_SS T_NAME T_S T_ENDDOCTYPE 		{printf(" DOCTYPE ");}
	; 
	
	
ExternalID_E : T_SS T_SYSTEM T_SS T_SYSTLIT 			{ printf(" SYSTEM ");}
	     |T_SS T_PULIC T_SS T_PUBIDLIT T_S T_SYSTLIT	{printf(" PUBLIC ");}	      
	     ;
    
    
XMLdec : XMLdec_E 						{printf(" XML ");}
       |
       ; 
       
       
XMLdec_E : T_XMLDEC VersionINfo EncoDecl T_S T_F_XMLDEC 	{}
	  | T_XMLDEC VersionINfo T_S T_F_XMLDEC 		{}
	  ;

	  
	  
VersionINfo : T_SS T_VS T_EQ T_VNUMBER 				{printf(" Version info ");}
	    ;



EncoDecl : T_SS T_ENCOD T_EQ T_ENDID 				{printf(" EncoDecl ");}
	 ; 
	
	
	
ETAG : T_ETAG T_TAG T_S T_FTAG 					{ printf (" tag!!!!!!!!!!! :) ");}
     ; 

     
     
T_COMMENT : T_COMMENT_IN T_COMMENT_END 				{ printf (" comentario!!! :)");}
	  ;

	  
	  
T_SS : T_SPACE  						{ printf (" espacio tss!!! ");}
     |  T_SPACE T_SS 						{ printf (" espacio tss!!! ");}
     ;   
	  
	  
	  
T_S : T_SPACE T_S 						{ printf (" espacio con 0!!! ");}
    |								{ printf (" espacio con 1!!! ");}
    ;
    // ----------------------------------------------------------- BUENOS ---------------------------------------------->>


%%
// void yyerror ()
// {
//   printf (" error en el parser ");
// }

void yyerror (char const *s)
     {
       fprintf (stderr, "%s\n", s);
     }

int main() {
	return yyparse();
}
