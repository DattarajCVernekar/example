/* even more like Unix wc */
%option noyywrap yylineno 
%x COMMENT
%x IDENT
%x INT
%x FLOAT
%x OPERA
%x STRING
%x FUNC
%x HEAD
KEY auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|main|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while
ARTHOP "+"|"-"|"/"|"*"|"%"|"++"|"--"
RELAOP ">"|"<"|"=="|">="|"<="|"!="
LOGIOP "&&"|"||"|"!"
ASSIOP "="|"+="|"-="|"/="|"*="|"%="|"<<="|">>="|"&="|"^="|"|="
PUNCT ","|";"|"->"
%{
#include<string.h>
int lines = 1;
char buf[20];
%}	

%%
{KEY} {printf("line:%d:%s :keyword\n",lines,yytext);}

"#" {BEGIN(HEAD);}
<HEAD>include[<][a-zA-Z_]+[.][h|c][>] {printf("line:%d: header file\n",lines); BEGIN(INITIAL);}

\n {lines++;}
"//"[^\n]* {printf("line:%d:single line comment\n",lines);lines++;}
{ARTHOP}|{RELAOP}|{ASSIOP}|{LOGIOP} {printf("line:%d:%s :operator\n",lines,yytext);}

";" {printf("line:%d:%s :semicolon\n",lines,yytext);}

"," {}

[ \t] {}

"("|"{"|"[" {printf("line:%d:%s :open parenthesis\n",lines,yytext);}

")"|"}"|"}" {printf("line:%d:%s :closed parenthesis\n",lines,yytext);}

"/*" { BEGIN(COMMENT); }

<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>([^*])+|.
<COMMENT>\n {lines++;}
<COMMENT><<EOF>> { printf("line:%d: Unterminated comment\n", lines); return 0;}

[a-zA-Z_] {BEGIN(IDENT);buf[0]='\0';strcpy(buf,yytext);}
<IDENT>[_a-zA-Z0-9]*/(" "|\t|{PUNCT}|{ARTHOP}|{RELAOP}|{ASSIOP}|"&&"|"||"|"("|")") {BEGIN(INITIAL);strcat(buf,yytext);printf("line:%d:%s:identifier\n",lines,buf);buf[0]='\0';}
<IDENT>[_a-zA-Z0-9]*[!@#$] {strcat(buf,yytext);printf("line:%d:error:%s undefined symbol in indentifier\n",lines,buf);buf[0]='\0';BEGIN(INITIAL) ;}
<IDENT>[_a-zA-Z0-9]*[\n] {strcat(buf,yytext);printf("line:%d:error: semicolon ';' missing\n",lines);buf[0]='\0';lines++;BEGIN(INITIAL) ;}




[-]?[0-9]+ {BEGIN(INT);buf[0]='\0';strcpy(buf,yytext);}
<INT>""/(" "|\t|"("|")"|{ARTHOP}|{RELAOP}|{LOGIOP}|{ASSIOP}|{PUNCT}) {BEGIN(INITIAL);printf("line:%d:%s :integer\n",lines,buf);buf[0]='\0';}
<INT>""/[.|e|E] {BEGIN(FLOAT);}
<INT>. {printf("line:%d:error:%s: integer value followed by invalid character\n",lines,yytext);BEGIN(INITIAL) ;}
<INT>\n {printf("line:%d:error: semicolon ';' missing\n",lines);lines++;BEGIN(INITIAL) ;}

[-]?[0-9]* {BEGIN(FLOAT);buf[0]='\0';strcpy(buf,yytext);}
<FLOAT>[.][0-9]+/(" "|\t|{PUNCT}|{ARTHOP}|{RELAOP}|{ASSIOP}|"&&"|"||") {BEGIN(INITIAL);strcat(buf,yytext);printf("line:%d:%s:floating point\n",lines,buf);buf[0]='\0';}
<FLOAT>[E|e][-+]?[0-9]+/(" "|\t|{PUNCT}|{ARTHOP}|{RELAOP}|{ASSIOP}|"&&"|"||") {BEGIN(INITIAL);strcat(buf,yytext);printf("%s:exponential value\n",buf);buf[0]='\0';}
<FLOAT>. {printf("line:%d:error: %s:floating point value followed by invalid character\n",lines,yytext);BEGIN(INITIAL) ;}
<FLOAT>\n {printf("line:%d:error: semicolon ';' missing\n",lines);lines++;BEGIN(INITIAL) ;}

["] {BEGIN(STRING);}
<STRING>["] {BEGIN(INITIAL);printf("line:%d:%s:string\n",lines,buf);lines++;}
<STRING>[^"]* {buf[0]='\0';strcpy(buf,yytext);}
<STRING><<EOF>> {printf("line:%d:error:Unterminated string\n",lines);lines++; return 0;}
. {}
%%


int main(int argc,char **argv)
{
if(argc > 1) {
if(!(yyin = fopen(argv[1], "r"))) {
perror(argv[1]);
return (1);
}
}

yylex();

}
