%{
void FILACOLUMNA();
%}

%{
int numFila = 1, numColumna = 1;
%}
S " "
EQ {S}*={S}*
VN 1"."[0-9]+
NAMESTCHAR (:|"_"|[a-zA-Z])
NAMECHAR ({NAMESTCHAR}|"-"|"."|[0-9])
NAME {NAMESTCHAR}({NAMECHAR})*
CONTENIDO_ATRIBUTO (\"[^<\"]*\"|'[^<\"]*')
SCRIPT \"([a-z]|[A-Z]|[0-9])*\(([a-z]|[A-Z]|[0-9]|[^\n])*\)\"
PubIDChar [0-9]|[a-zA-Z]|([-'()+,./:=?;!*#@$_%]|" ")
PubIDLit "\""({PubIDChar})*"\""|'({PubIDChar})*'
SYSTLIT (\"([^"\n]*)\")|('([^\'\n]*)')
ENCNAME [a-zA-Z]([a-zA-Z]|[0-9]|"."|"_"|"-")*
ENCODNAME "\""({ENCNAME})"\""|'({ENCNAME})'
CONTENIDO_CDATA (((.)|(\n))[^\]\]>])*	
ATRIBUTO "accesskey"|"class"|"contenteditable"|"contextmenu"|"dir"|"draggable"|"dropzone"|"hidden"|"id"|"inert"|"itemid"|"itemprop"|"itemref"|"itemscope"|"lang"|"spellocheck"|"style"|"tabindex"|"title"|"translate"|"version"|"xml:lang"|"xmlns"|"xmlns:xsi"|"xsi:schemaLocation"|"http-quiv"|"content"|"name"|"rel"|"media"|"type"|"title"|"charset"|"href"|"hreflang"|"rel"|"rev"|"shape"|"coords"|"target"|"name"|"cite"|"alink"|"background"|bgcolor"|"text"|"vlink"|"aling"|"accept-charset"|"action"|"autocomplete"|"enctype"|"method"|"novalidate"|"profile"|"noshade"|"size"|"width"|"manifest"|"alt"|"border"|"crossorigin"|"height"|"hspace"|"ismap"|"longdesc"|"src"|"usemap"|"vspace"|"autofocus"|"checked"|"disable"|"form"|"formation"|"formenctype"|"formmeter"|"formnovalidate"|"list"|"max"|"maxlength"|"min"|"multiple"|"patron"|"placeholder"|"reado}ly"|"required"|"step"|"value"|"sizes"|"scheme"|"archive"|"classid"|"codebase"|"codetype"|"data"|"declare"|"standby"|"compac"|"type"|"char"|"charoff"|"valign"|abbr"|"axis"|"colspan"|"headers"|"nowrap"|"rowspan"|"label"|"reversed"|"start"|"select"|"async"|"defer"|"xml:space"|"scoped"|"cellpaddinf"|"cellspacing"|"frame"|"rules"|"summary"|"scope"
TAG "a"|"b"|"blockquote"|"body"|"br"|"button"|"caption"|"code"|"dd"|"dir"|"div"|"dl"|"dt"|"em"|"embed"|"form"|"footer"|"frame"|"h1"|"h2"|"h3"|"h4"|"h5"|"h6"|"head"|"header"|"hr"|"html"|"img"|"input"|"1i"|"link"|"label"|"meta"|"ol"|"object"|"option"|"p"|"pre"|"span"|"summary"|"script"|"select"|"style"|"strong"|"table"|"td"|"textarea"|"th"|"title"|"tr"|"ul"


%x XMLDec 
%x DocType
%x ETags
%x ESTags
%x PubIDLit
%x SystLit
%x cDATA
%x COMENT
%x CONTENIDO 

%%
\n          		        {FILACOLUMNA(); printf(" ENTER\n "); return T_ENTER;} /* los enters valen 00 */
"<!--"				{FILACOLUMNA(); printf(" t_COMMENT");BEGIN(COMENT); return T_COMMENT_INI;} /* los comentarios valen 02 */
<COMENT>{
"--"				{error();}
((.)|(\n))			{FILACOLUMNA();}
"-->"				{FILACOLUMNA(); BEGIN(INITIAL); return T_COMMENT_END}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return T_ENTER;}
}

"<![CDATA["			{FILACOLUMNA(); printf(" t_cdata_ini "); BEGIN(cDATA); return T_CDATA_I;}
<cDATA>{
"]]>"				{FILACOLUMNA(); printf(" t_cdata_fin ");BEGIN(INITIAL);return T_CDATA_F;}
{CONTENIDO_CDATA}		{FILACOLUMNA(); printf(" Content_data "); return CONT_DATA;}
.				{;error();}
}
   /*------------------------- DEFINICION XMLDec ------------------------------------*/
"<?xml"				{FILACOLUMNA(); printf(" t_XMLDec "); BEGIN(XMLDec); return T_XMLDEC;}
<XMLDec>{
"?>"				{FILACOLUMNA(); printf(" t_fin_XMLDec "); BEGIN(INITIAL);return T_F_XMLDEC;}
{S}				{FILACOLUMNA(); return T_SPACE;} /* los espacios valen 01*/
{EQ}				{FILACOLUMNA(); printf(" t_EQ "); return T_EQ; } /* los iguales valen 06 */

(encoding)			{FILACOLUMNA(); printf(" t_encd "); return T_ENCOD;}
{ENCODNAME}			{FILACOLUMNA(); printf(" t_endId "); return T_ENDID;}
  
(version)			{FILACOLUMNA(); printf(" t_vs "); return T_VS;}
\"{VN}\"			{FILACOLUMNA(); printf(" t_v_number ");return T_VNUMBER;}
'{VN}'				{FILACOLUMNA(); printf(" t_v_number ");return T_VNUMBER;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return T_ENTER;}
.				{;error();}

}
 /* ------------------------------DOCTYPE------------------------------ */
"<!DOCTYPE"			{FILACOLUMNA(); printf(" t_DocType "); BEGIN(DocType);return T_DOCTYPE;}
<DocType>{
{S}				{FILACOLUMNA();return T_SPACE;}
SYSTEM				{FILACOLUMNA();printf(" t_System "); BEGIN (SystLit);return T_SYSTEM;}
PUBLIC				{FILACOLUMNA();printf(" t_Public "); BEGIN (PubIDLit);return T_PULIC;}
{NAME}				{FILACOLUMNA();printf(" t_Name "); return T_NAME;}
">"				{FILACOLUMNA(); printf(" End_Doctype "); BEGIN(INITIAL);return T_ENDDOCTYPE;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return T_ENTER;}
.				{FILACOLUMNA();error();}
}

<PubIDLit>{S}			{FILACOLUMNA();return T_SPACE;}
<SystLit>{S}			{FILACOLUMNA();return T_SPACE;}
<PubIDLit>{PubIDLit}		{FILACOLUMNA(); printf(" t_PubIDLit");BEGIN(SystLit);return T_PUBIDLIT;}
<SystLit>{SYSTLIT}		{FILACOLUMNA(); printf(" t_systlit "); BEGIN(DocType);return T_SYSTLIT;}
<SystLit>\n                    {FILACOLUMNA(); printf(" ENTER\n ");return T_ENTER;}
<PubIDLit>.			{;error();}
<SystLit>.			{;error();}

  /* ----------------------------DEFINICION ETags----------------------*/
"</"				{FILACOLUMNA(); printf(" t_ETags "); BEGIN(ETags);return T_ETAG;}
<ETags>{
{TAG}				{FILACOLUMNA(); printf(" t_TAG ");return T_TAG;} /* return un tag*/
{S}				{FILACOLUMNA();return T_SPACE;}
{S}?">"				{FILACOLUMNA(); printf(" t_fin_ETAG ");BEGIN(INITIAL);return T_FTAG;}
\n                             {FILACOLUMNA(); printf(" ENTER\n "); return T_ENTER;}
.				{error();}
}
 
  
  
  /*-----------------------------DEFINICION ESTags-----------------------
   {SCRIPT}			{FILACOLUMNA(); printf(" t_scriptcont ");return T_SCRIPTCONT;}  */
"<"				{FILACOLUMNA(); printf(" t_ESTags"); BEGIN(ESTags);return T_ESTAG;} 
<ESTags>{
{S}				{FILACOLUMNA();{printf(" ");}return T_SPACE;}
{EQ}				{FILACOLUMNA(); printf(" t_EQ ");return T_EQ;}
{TAG}				{FILACOLUMNA(); printf(" t_TAG "); return T_TAG;}

{CONTENIDO_ATRIBUTO}		{FILACOLUMNA(); printf(" t_content ");printf(" t_content_end ");return T_CONTENT;}
{ATRIBUTO}			{FILACOLUMNA(); printf(" t_Atributo ");return T_ATRIBUTO;}
{S}?"/>"/[" "\n]*"<"		{FILACOLUMNA(); printf(" t_fin_EmTAG ");BEGIN(INITIAL);return T_FIN_ETAG;}
{S}?">"/[" "\n]*"<"		{FILACOLUMNA(); printf(" t_fin_STAG ");BEGIN(INITIAL);return T_FIN_STAG;}
{S}?"/>"			{FILACOLUMNA(); printf(" t_fin_EmTAG ");BEGIN(CONTENIDO);return T_FIN_ETAG;}
{S}?">"				{FILACOLUMNA(); printf(" t_fin_STAG ");BEGIN(CONTENIDO);return T_FIN_STAG;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return T_ENTER;}
.				{error();}
} 
 /*-----------------------------DEFINICION Contenido-----------------------*/
<CONTENIDO>"&"			{error();}
<CONTENIDO>"</"			{FILACOLUMNA(); printf(" t_ETags "); BEGIN(ETags);return T_ETAG;}
<CONTENIDO>"<"			{FILACOLUMNA(); printf(" t_ESTags"); BEGIN(ESTags);return T_ESTAG;}
<CONTENIDO>"]]>"/[^&<]		{error();}
<CONTENIDO>[^&<]*		{FILACOLUMNA();printf(" CONTENIDO ");return T_CONTENIDO;}


" "				{FILACOLUMNA();return T_SPACE;}
%%

void FILACOLUMNA()
{
  if(strcmp("\n",yytext)==0)
	  {
	    numFila++;		
	    numColumna=1;
	  }
  else {
	    numColumna+= yyleng;
  }
}

int error(void)
{
    printf("\n");
    printf("ERROR!! \n");
    printf("en el numero de fila:%d\nY en la columna:%d\n", numFila, numColumna);
    exit(1);
    
}
