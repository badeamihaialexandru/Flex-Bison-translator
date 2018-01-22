%{
	#include <stdio.h>
     #include <string.h>

	int yylex();
	int yyerror(const char *msg);
     int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}

%union { char* sir; int val; PUNCT p; }

%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_ERROR
%token <val> TOK_NUMBER
%token <sir> TOK_VARIABLE

%type <val> E

%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : 
    |
    I ';' S
    | 
    error ';' S
       { EsteCorecta = 0; }
    ;
I : TOK_VARIABLE '=' E
      {
	if(ts != NULL)
	{
	  if(ts->exists($1) == 1)
	  {
	    ts->setValue($1, $3);
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(msg);
	  YYERROR;
	}
      }
    |
    TOK_DECLARE TOK_VARIABLE
      {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2);
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  ts = new TVAR();
	  ts->add($2);
	}
      }
    |
    TOK_PRINT TOK_VARIABLE
      {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 1)
	  {
	    if(ts->getValue($2) == -1)
	    {
	      sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $2);
	      yyerror(msg);
	      YYERROR;
	    }
	    else
	    {
	      printf("%d\n",ts->getValue($2));
	    }
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
	  yyerror(msg);
	  YYERROR;
	}
      }
    ;
E : E TOK_PLUS E { $$ = $1 + $3; }
    |
    E TOK_MINUS E { $$ = $1 - $3; }
    |
    E TOK_MULTIPLY E { $$ = $1 * $3; }
    |
    E TOK_DIVIDE E 
	{ 
	  if($3 == 0) 
	  { 
	      sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(msg);
	      YYERROR;
	  } 
	  else { $$ = $1 / $3; } 
	}
    | 
    TOK_LEFT E TOK_RIGHT
      {
	$$ = $2;
      }
    |
    TOK_NUMBER { $$ = $1; }
    ;
%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
