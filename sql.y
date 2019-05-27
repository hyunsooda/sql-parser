/*
http://2k8618.blogspot.com/2011/08/parser-for-sql-query-select-yacc.html
컴파일 방법

0. yacc -d sql.y
1. lex sql.l
2. yacc sql.y
3. gcc y.tab.c -ll -ly
4. ./a.out

./a.out 으로 프로그램을 실행시킨뒤 쿼리를 입력한다 ex) select myid from table;

example)
> ./a.out
> select id from table

*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* text1 = NULL;
char* text2 = NULL;

void text_write() {
    FILE* fp;
    fp = fopen("lang.js", "w");
    
    if(text1 != NULL && text2 != NULL) {
        fprintf(fp, "%s\n", text1);
        fprintf(fp, "%s\n", text2);
        printf("file writing success\n");
    }
}

%}

%union {
    char* str;
}
%type<str> S ST1 ST2 ST3 ST4 ST5 ST6 attributeList tableList ID F

%token ID NUM SELECT DISTINCT FROM WHERE LE GE EQ NE OR AND LIKE GROUP HAVING ORDER ASC DESC 
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE

%%

    S         : ST1';' { text_write(); printf("INPUT ACCEPTED....\n"); exit(0); };
    ST1     : SELECT attributeList FROM tableList ST2   { text1 = $2; text2 = $4; }
               | SELECT DISTINCT attributeList FROM tableList ST2
               ;
    ST2     : WHERE COND ST3
               | ST3
               ;
    ST3     : GROUP attributeList ST4
               | ST4
               ;
    ST4     : HAVING COND ST5
               | ST5
               ;
    ST5     : ORDER attributeList ST6
               |
               ;
    ST6     : DESC
               | ASC
               |
               ;
  attributeList : ID','attributeList  
               | '*' 
               | ID { 
                   char* temp = strtok($1, " ");
                   $$ = $1;
                }  
               ;
 tableList    : ID',' tableList   
               | ID  { /* $$ = $1; printf("1%s\n", $1); */ }
               ;
    COND    : COND OR COND
               | COND AND COND
               | E
               ;
    E         : F '=' F
               | F '<' F 
               | F '>' F  
               | F LE F 
               | F GE F
               | F EQ F
               | F NE F
               | F OR F 
               | F AND F 
               | F LIKE F 
               ;
    F         : ID 
               | NUM  
               ;
%%
#include"lex.yy.c"
#include<ctype.h>

main()
{
    printf("Enter the query: ");
    yyparse();
}          