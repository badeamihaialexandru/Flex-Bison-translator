%{
#include <stdio.h>
     #include <string.h>

	int yylex();
	int yyerror(const char *msg);
	int EsteCorecta = 1;
	char msg[500];
	
	class Vars
	{ 
		char* val;
		char *nume;
		char type; // ocupa un singur octet
		Vars* urm;
	public: 

		Vars(char*nume,char type,char* val){};
		Vars(){};
 		static Vars* head;
	   	static Vars* tail;
		void add(char* val,char* nume,char type);
		//int set_val(char* val,char* nume);
		//char* get_val(char* nume);
		void exists(char* nume);
	};
	Vars* Vars::head;
	Vars* Vars::tail;

	void Vars::add(char* val,char* nume, char type)
	{
		Vars* var=new Vars(nume,type,val);
		if(Vars::head==NULL) 
		{
		Vars::head=Vars::tail=var;
		}
		else
		{
		Vars::tail->urm=var;
		Vars::tail=Vars::tail->urm;
		}
	}
	void Vars::exists(char* nume)
	{
 		Vars*p;
		p=Vars::head;
		while(p!=NULL)
		{
			if(strcmp(p->nume,nume)==0)
			{
				return 1;
			}
			p=p->urm;
		}
		return 0;
	}

	Vars* variabile=NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}
%union { char* sir; int val; PUNCT p; }


%token TOK_PLUS TOK_VAR TOK_AF TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_ERROR TOK_DECLARE_INT TOK_DECLARE_BOOL TOK_DECLARE_FLOAT 
%token <val> TOK_NUMBER
%token <sir> TOK_VARIABLE

%type <val> E

%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : I ';' S
    | 
    error ';' S
       { EsteCorecta = 0; }//
    ;
I :TOK_DECLARE_INT TOK_VAR 
	{
	if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!", 			   	 @1.first_line,@1.first_column, $1);
			 EsteCorecta=0;
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			variabile.add(NULL,$2,'0');
			}	
	}
    |
   TOK_DECLARE_INT TOK_VAR '=' TOK_NUMBER
	{
	if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!", 			   	 @1.first_line,@1.first_column, $1);
			EsteCorecta=0;
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			variabile.add($4,$2,'0');
			}	
	}
 /*   |
   TOK_DECLARE_BOOL TOK_VAR
	{
	if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!", 			   	 @1.first_line,@1.first_column, $1);
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			variable.add(NULL,$2,'1');
			}	
	}
    |
   TOK_DECLARE_BOOL TOK_VAR '=' TOK_AF
	{
	if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!", 			   	 @1.first_line,@1.first_column, $1);
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			if($4=="true")
			variabile.add("1",$2,'0');
			if($4=="false")
			variable.add("2",$2,'1');
			}	
	}
    |
   TOK_DECLARE_FLOAT TOK_VAR
	{
		
		if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!",   			   	 @1.first_line,@1.first_column, $1);
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			variabile.add(NULL,$2,'2');
			}
	};
    |
   TOK_DECLARE_FLOAT TOK_VAR '=' TOK_NUMBER
	{
		
		if(variabile.exists($2))
			{
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s a fost deja declarata!",   			   	 @1.first_line,@1.first_column, $1);
	   		 yyerror(msg);
	    		 YYERROR;
			}
		else 
			{
			variabile.add($4,$2,'2');
			} 
	};

	*/




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







