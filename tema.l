%{
	#include "tema.tab.h"
	
	int lineNo = 1;
	int colNo = 1;
%}
boolval (true)|(false) 
%%
"int"	{ yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=3; return TOK_DECLARE_INT ;}
"boolean"       {yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=7;return TOK_DECLARE_BOOL ;} 
"program" 	{colNo+=7;return TOK_PROG; }

"true"|"false"  {yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=strlen(yytext);yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext);return TOK_AF;} 

"float"		{yylloc.first_line = lineNo; yylloc.first_column=colNo; colNo+=4; return TOK_DECLARE_FLOAT; } 
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
"+"		{ yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo++;yylval.sir = new char; strcpy(yylval.sir,yytext); return TOK_PLUS; }
"-"		{ yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo++;yylval.sir = new char; strcpy(yylval.sir,yytext); return TOK_MINUS; }
"*"		{ colNo++; return TOK_MULTIPLY; }
"/"		{ colNo++; return TOK_DIVIDE; }
"("		{ colNo++; return '('; }
")"		{ colNo++; return ')'; }
";"		{ colNo++; return ';'; }
"="		{ colNo++; return '='; }
"<"		{ colNo++; return '<'; }
">"		{ colNo++; return '>'; }
"\t"            { colNo+=8;}

[1-9]+[0-9]*,[0-9]*|0,[0-9]*  {yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=strlen(yytext);yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext);return TOK_FL;}

0|[1-9][0-9]*	{yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=strlen(yytext);yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_NUMBER; } 
colNo
[a-zA-Z][a-zA-Z0-9_]*    {yylloc.first_line = lineNo; yylloc.first_column=colNo;colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext);return TOK_VAR;}
\n		{ lineNo++; colNo=1; }  
[ ] 		{colNo++;}
.		{printf("Eroare:L:%d C:%d\n",lineNo,colNo) ; colNo++; return TOK_ERROR; }  
%%
