%{
#include <stdio.h>
     #include <string.h>

	int yylex();
	int yyerror(const char *msg);
	int yywarning(const char *wmsg);
	int EsteCorecta = 1;
	char msg[500];
	char wmsg[500];
	//pot sa mai fac sa dea warrning cand fac while(ok) si ok-ul nu se modifica 
	//sa pot adauga comentarii
	class Vars
	{ 
		char* val;
		char *nume;
		char type; // ocupa un singur octet
		Vars* urm;
	public: 

		Vars(char*name,char type,char* valoare);
		Vars();
 		static Vars* head;
	   	static Vars* tail;
		void add(char* val,char* nume,char tip);
		void set_val(Vars* var,char* val);
		int set_type(Vars*,int);
		char* get_val(){return val;}
		char get_type(){return type;}
		Vars* exists(char* nume);
	};
	Vars* Vars::head;
	Vars* Vars::tail;
	
	Vars::Vars()
	{
	Vars::head=NULL;
	Vars::tail=NULL;
	}
	
	Vars::Vars(char*name,char tip,char* valoare)
		{
		nume=new char[strlen(name)+1];
		val=new char[strlen(valoare)+1];
		strcpy(nume,name);
		strcpy(val,valoare);
		type=tip;
		}
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
		Vars::tail=var;
		}
	}
	
	Vars* Vars::exists(char* nume)
	{
	Vars*p;
	p = Vars::head;
	while (p !=NULL)
	   {
		if (strcmp(p->nume, nume) == 0)
		{
			return p;
		}
		p = p->urm;
	   }
		return NULL;
	}

	void Vars::set_val(Vars* var, char * val)
	{
		var->val = val;
	}

	int Vars::set_type(Vars* var, int type)
	{
		var->type = type;
		return 1;
	}




	Vars* variabile=NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}
%union { char* sir; int val; PUNCT p; }


%token TOK_MULTIPLY TOK_DIVIDE TOK_DECLARE TOK_PRINT TOK_ERROR TOK_DECLARE_INT TOK_DECLARE_BOOL TOK_DECLARE_FLOAT TOK_BEGIN TOK_END TOK_PROG
TOK_IF TOK_REP TOK_UNT TOK_DIF TOK_EQU TOK_READ TOK_THEN TOK_ELSE
 
%token <sir> TOK_VARIABLE TOK_PLUS TOK_MINUS
%token <sir> TOK_VAR 
%token <sir>TOK_NUMBER TOK_FL TOK_AF 
%type <sir> SGN E C


%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : TOK_PROG TOK_VAR V
    | 
    error V    
    ;
V :TOK_BEGIN I  TOK_END 
    |
    error I   //in cazul in care eroarea apare la begin
    |
    error V   //in cazul in care eroarea apare la end 
; 



I : T I
    |
    T
;

T :TOK_DECLARE_INT TOK_VAR ';' 	
		{
		 if(variabile!=NULL)
			if(variabile->exists($2)==NULL)
				 variabile->add("NULL",$2,'0'); 
			else 
				{
				sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR;
				} 
		 else 
			{
			variabile=new Vars();
			variabile->add("NULL",$2,'0');
			}
		}
    |
   TOK_DECLARE_INT TOK_VAR '=' TOK_NUMBER ';' 
		{ 
			bool ok=true;
			if (strlen($4)>=10)
				{
				if(strcmp("2147483647",$4)<0)
					{
					ok=false;			
					sprintf(wmsg,"%d:%d Eroare semantica: Gama de reprezentare a fost depasita!Valoarea lui %s a fost inlocuita cu INT_MAX!",@1.first_line, @1.first_column,$2);
					yywarning(wmsg);					
					}
				}
			if(ok)
				{
				strcpy($4,"2147483647");
				}
			
				if (variabile!=NULL)
					{
					if (variabile->exists($2)!=NULL)   //nu merge momentan functia asta 
						{
						sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
						yyerror(msg);
						YYERROR;					
						}
					else 
						{
						variabile->add($4,$2,'0');
						}
					}
				else 
				{
					variabile=new Vars();
					variabile->add($4,$2,'0');
				
				}
			
		}
    |
   TOK_DECLARE_INT TOK_VAR '=' SGN TOK_NUMBER ';' 
		{
		if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)   
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					char* var=new char[strlen($5)+1];
					strcpy(var,$4);
					strcat(var,$5);
					variabile->add(var,$2,'0');
					}
				}
			else 
			{
				variabile=new Vars();
				char* var=new char[strlen($5)+1];
				strcpy(var,$4);
				strcat(var,$5);
				variabile->add(var,$2,'0');
			}
		}
    |
   TOK_DECLARE_BOOL TOK_VAR ';' 
		{
		 if(variabile!=NULL)
			if(variabile->exists($2)==NULL)
				 variabile->add("NULL",$2,'1'); 
			else 
				{
				sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR;
				} 
		 else 
			{
			variabile=new Vars();
			variabile->add("NULL",$2,'1');
			}
		}
    |
   TOK_DECLARE_BOOL TOK_VAR '=' TOK_AF ';'
			{ 
			if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)   
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					variabile->add($4,$2,'1');
					}
				}
			else 
			{
				variabile=new Vars();
				variabile->add($4,$2,'1');
				
			}
		}
	
    |
   TOK_DECLARE_FLOAT TOK_VAR ';'
				{
		 if(variabile!=NULL)
			if(variabile->exists($2)==NULL)
				 variabile->add("NULL",$2,'2'); 
			else 
				{
				sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR;
				} 
		 else 
			{
			variabile=new Vars();
			variabile->add("NULL",$2,'2');
			}
		}
    |
   TOK_DECLARE_FLOAT TOK_VAR '=' TOK_FL ';'
		{ 
			if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)   
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					variabile->add($4,$2,'2');
					}
				}
			else 
			{
				variabile=new Vars();
				variabile->add($4,$2,'2');
				
			}
		}
    |
   TOK_DECLARE_FLOAT TOK_VAR '=' SGN TOK_FL ';'
	{
		if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)   
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					char* var=new char[strlen($5)+1];
					strcpy(var,$4);
					strcat(var,$5);
					variabile->add(var,$2,'2');
					}
				}
			else 
			{
				variabile=new Vars();
				char* var=new char[strlen($5)+1];
				strcpy(var,$4);
				strcat(var,$5);
				variabile->add(var,$2,'2');
			}
		}
    |
   TOK_DECLARE_FLOAT TOK_VAR '=' TOK_NUMBER ';'
		{ 
			if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)    
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					variabile->add($4,$2,'2');
					}
				}
			else 
			{
				variabile=new Vars();
				variabile->add($4,$2,'2');
			}
		}
    |
   TOK_DECLARE_FLOAT TOK_VAR '=' SGN TOK_NUMBER ';'
		{
		if (variabile!=NULL)
				{
				if (variabile->exists($2)!=NULL)   
					{
					sprintf(msg,"%d:%d Eroare semantica: Variabila a fost declarata deja!",@1.first_line, @1.first_column);
					yyerror(msg);
					YYERROR;					
					}
				else 
					{
					char* var=new char[strlen($5)+1];
					strcpy(var,$4);
					strcat(var,$5);
					variabile->add(var,$2,'2');
					}
				}
			else 
			{
				variabile=new Vars();
				char* var=new char[strlen($5)+1];
				strcpy(var,$4);
				strcat(var,$5);
				variabile->add(var,$2,'2');
			}
		}
    |
   TOK_IF '(' D ')' TOK_THEN V
    |
   TOK_IF '(' D ')' TOK_THEN V TOK_ELSE V
    |
   TOK_REP V TOK_UNT '(' D ')' ';'
    |
   TOK_PRINT TOK_VAR ';'
	{
		Vars* var=variabile->exists($2);
		if(var!=NULL)
			printf("%s",var->get_val());
		else 
			{
			sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata",@1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR; 
			}				
	}
    |
   TOK_READ TOK_VAR ';'  
    |
   TOK_VAR '='TOK_AF ';'
	{
	Vars* var=variabile->exists($1);
	if(var!=NULL)
			{
			Vars *val=variabile->exists($1);
			var->set_val(val,$3);
			}	
	else 
			{
			sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata",@1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR; 
			}	
	}
    |
   TOK_VAR '=' E ';'
	{
	Vars* var=variabile->exists($1);
	if(var!=NULL)
			{
			Vars *val=variabile->exists($1);
			var->set_val(val,$3);
			}	
	else 
			{
			sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata",@1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR; 
			}	
	}
    |
    error I  { }
    ;
D: TOK_AF
    |
    C
;

C : C '<' C
	{
	if((strcmp($1,"n")==0)&&(strcmp($3,"n")==0))
		{
		sprintf(wmsg,"%d:%d Conditia pusa va cauza o bucla infinita!",@1.first_line, @1.first_column);
		yywarning(wmsg);
		}
	}
    |
    C '>' C
	{
	if((strcmp($1,"n")==0)&&(strcmp($3,"n")==0))
		{
		sprintf(wmsg,"%d:%d Conditia pusa va cauza o bucla infinita!",@1.first_line, @1.first_column);
		yywarning(wmsg);
		}
	}
    |
    C TOK_DIF C    
    |
    C TOK_EQU C
    |
    H TOK_DIF H
    |
    H TOK_EQU H
    |
    TOK_VAR
	{
		Vars* var=variabile->exists($1);
		if(var==NULL)
				{
				sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR; 
				}
		else 
			{
			if(var->get_val()==NULL)
				{
				sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi initializata!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR; 
				}
			}	
	}
    |
    TOK_NUMBER
	{
	$$="n";
	}
;
H: TOK_AF
    |
   TOK_VAR  
	{
	Vars* var=variabile->exists($1);
		if(var==NULL)
				{
				sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR; 
				}
		else 
			{
			if(var->get_type()=='1')
				{
				sprintf(msg,"%d:%d Eroare sintactica: Variabilele de tip bool nu pot fi comparate cu numere intregi sau reale!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR; 
				}
			if(var->get_val()==NULL)
				{
				sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi initializata!",@1.first_line, @1.first_column);
				yyerror(msg);
				YYERROR; 
				}
			
			}
	}
;
E:  E TOK_PLUS E
	{
	
	}
    |
    E TOK_MINUS E 
	{
		
	}
    |
    E TOK_MULTIPLY E 
    |
    E TOK_DIVIDE E 
    | 
    '(' E ')'
    | 
    TOK_NUMBER 
	{
	$$=$1;
	}
    |
    TOK_VAR
	{
		Vars* var=variabile->exists($1);
		if(var!=NULL)
		{
			char * to_ret=new char;
			to_ret[0]=var->get_type();
			$$=to_ret;
		}
		else 
		{
			sprintf(msg,"%d:%d Eroare sintactica: Variabila utilizata fara a fi declarata",@1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR; 
		}
		if(var->get_type()=='1')
		{
			sprintf(msg,"%d:%d Eroare sintactica: Nu sunt permise operatii cu variabile de tip Boolean!",@1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR; 	
		}
	}
    |
    TOK_FL
    |
    SGN TOK_FL
    |
    SGN TOK_NUMBER
	
    ;
SGN: TOK_PLUS
    |
    TOK_MINUS 
    ;
	

%%

int main()
{
	
	yyparse();
	if(EsteCorecta == 1)
	{
		//printf("CORECTA\n");		
	}	
       return 0;
}
int yywarning(const char* wmsg)
{
	printf("Warning: %s\n",wmsg);
	return 1;
}
int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}







