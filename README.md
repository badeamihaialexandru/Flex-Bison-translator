# Flex-Bison-translator

By compiling in linux bash using the following comands: 
flex tema.l 
bison -d tema.y 
g++ lex.yy.c tema.tab.c -lfl 
./a.out<in.txt 
The a.out file will check your input text file for the errors defined in the gramar.
