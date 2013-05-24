%{
static void yyerror ();
%}

 /* modifica la variable yylval para obtener los tipos requeridos.*/
%union{
    double numero;
    char *contenido;
    
}

 /*  TOKENS!!!!  */
 
 
 
%token T_ENTER T_SPACE
%token T_COMMENT_IN T_COMMENT_END 
%token T_CDATA_I T_CDATA_F CONT_DATA
%token T_XMLDEC T_F_XMLDEC T_EQ T_ENCOD  T_ENDID T_VNUMBER T_VS
%token T_DOCTYPE T_SYSTEM T_PULIC T_NAME T_ENDDOCTYPE T_PUBIDLIT T_SYSTLIT
%token T_ETAG T_TAG T_FTAG 
%token T_ESTAG T_CONTENT T_ATRIBUTO T_FIN_ETAG T_FIN_STAG 
/*T_ESTAG*/ 


%token <contenido> T_CONTENIDO
%%
/* REGLAS  

corregir espacio! */

Document  : Prolog Element {}   /* No Terminal de inicio  */
	  | Prolog Element Misc {}
	  ;
	  
/* Parte del document  PROLOG ELEMENT MISC  */
Prolog    : XMLdec Misc Doctype {}  
	  ;
	
Element : EETAG {}
	| SCTAG {}
	;

Misc      : Misc T_COMMENT {}
	  | Misc T_SPACE {}
	  | 
	  ;

/*  Elementos de PROLOG  XMLdec? Misc* DocType */
XMLdec	  : XMLdec_E  
	  |
	  ;

Doctype  : T_DOCTYPE T_SPACE T_NAME ExternalID_E T_S T_ENDDOCTYPE {}
	 |
	 ;
/* Elementos de XMLdec     XMLdec_E   VersionINfo  Encoding  T_F_XMLDEC */

XMLdec_E  : T_XMLDEC VersionINfo EncoDecl T_S T_F_XMLDEC {}
	  ;
	 
VersionINfo : T_S T_VS T_EQ T_VNUMBER {} 
	    ;

EncoDecl  : T_S T_ENCOD T_EQ T_ENDID {}
	  |
	  ;
	  
/* ELementos de Misc  Comment Espacio*/
T_COMMENT : T_COMMENT_IN T_COMMENT_END {}
	  ;
	  
T_S      : T_SPACE {}
	  |
	  ;
	  
/* Elementos del DocType    Doctype Name ExternalID  EndDoctype*/ 
	 
ExternalID_E : T_SYSTEM T_SPACE T_SYSTLIT {}
	     | T_PULIC T_SPACE T_PUBIDLIT T_SPACE T_SYSTLIT{}
	     |
	     ;
	     

/* Elementos de Element   EmptyELementTag(EETAG) StagContentETag(SCTAG) */

EETAG   : T_ESTAG T_TAG T_ATRIB T_S T_FIN_ETAG {}
	| T_ESTAG T_TAG T_S T_FIN_ETAG {}
	;

SCTAG : ESTAG CONTENT ETAG {}
      ;
	
/* ELementos del EETAG */
T_ATRIB  : T_ATRIB T_SPACE T_CONTENT T_EQ T_ATRIBUTO {}
	 |
	 ;
	 
/* ELementos del SCTAG*/

ESTAG : T_ESTAG T_TAG T_ATRIB T_S T_FIN_STAG {}
      ;
      
CONTENT : CONTENT Element {}
	| CONTENT CDSect {}
	| CONTENT T_COMMENT {}
	| CONTENT T_SPACE {}
	|
	;
	
ETAG : T_ETAG T_TAG T_S T_FTAG {}
     ;

/* Elementos del CONTENT */
CDSect : T_CDATA_I CONT_DATA T_CDATA_F {}
       ;
%%