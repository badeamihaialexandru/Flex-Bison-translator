%{
	#include "tema.tab.h"
	
	int lineNo = 1;
	int colNo = 1;
%}
boolval (true)|(false) 
%%
"int"	{ colNo+=6; return TOK_DECLARE_INT ;}
"boolean"       {return TOK_DECLARE_BOOL ;} /*DE LA MIHAELA /*
"true"|"false"  { colNo+=strlen(yytext); return TOK_AF;}  
*/
"program" 	{colNo+=7;return TOK_PROG; }
"true"|"false"  {colNo++;return TOK_AF;} 
"float"		{ colNo+=4; return TOK_DECLARE_FLOAT; } 
"begin"         { colNo+=5; return TOK_BEGIN;}
"end"		{ colNo+=3; return TOK_END;}
"if" 		{ colNo+=2; return TOK_IF;}
"repeat"	{ colNo+=6; return TOK_REP;}
"until"		{ colNo+=5; return TOK_UNT;}
"print"		{ colNo+=5; return TOK_PRINT;}
"read"		{ colNo+=4; return TOK_READ;}
"then"		{ colNo+=4; return TOK_THEN;}
"else"  	{ colNo+=4; return TOK_ELSE;}
"=="		{ colNo+=2; return TOK_EQU;}
"!="		{ colNo+=2; return TOK_DIF;}
"+"		{ colNo++; return TOK_PLUS; }
"-"		{ colNo++; return TOK_MINUS; }
"*"		{ colNo++; return TOK_MULTIPLY; }
"/"		{ colNo++; return TOK_DIVIDE; }
"("		{ colNo++; return TOK_LEFT; }
")"		{ colNo++; return TOK_RIGHT; }
";"		{ colNo++; return ';'; }
"="		{ colNo++; return '='; }
"<"		{ colNo++; return '<'; }
[+-]?[1-9][0-9]*,[0-9]*|[+-]?0,[0-9]*  {colNo++;return TOK_FL;}
[+-]?0|[+-]?[1-9][0-9]*	{ colNo++; return TOK_NUMBER; } 
[a-zA-Z0-9]*       { colNo++; return TOK_VAR;}
[ ]		{ colNo++; } 
.		{ colNo++; return TOK_ERROR; }  
\n		{ lineNo++; colNo=1; }  
%%
