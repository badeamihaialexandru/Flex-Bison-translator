%{
	#include "tema.tab.h"
	
	int lineNo = 1;
	int colNo = 1;
%}
//boolean (true)|(false) 
%%
"intreg"	{ colNo+=6; return TOK_DECLARE_INT; }
"adevarat"	{ colNo+=8; return TOK_DECLARE_BOOL; }
"real"		{ colNo+=4; return TOK_DECLARE_FLOAT; } /*
boolean         {colNo+=strlen(yytext);return TOK_AF} DE LA MIHAELA 
"true"|"false"  { colNo+=strlen(yytext); return TOK_AF;}
[a-zA-Z]*       { colNo++; return TOK_VAR;} */
"+"		{ colNo++; return TOK_PLUS; }
"-"		{ colNo++; return TOK_MINUS; }
"*"		{ colNo++; return TOK_MULTIPLY; }
"/"		{ colNo++; return TOK_DIVIDE; }
"("		{ colNo++; return TOK_LEFT; }
")"		{ colNo++; return TOK_RIGHT; }
";"		{ colNo++; return ';'; }
"="		{ colNo++; return '='; }
0|[1-9][0-9]*	{  return TOK_NUMBER; } 
[ ]		{ colNo++; }
.		{ colNo++; return TOK_ERROR; }
\n		{ lineNo++; colNo=1; }
%%
