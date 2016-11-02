%option noyywrap

%{
#define YYSTYPE char*
#include "setfunc.tab.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXL 5000
#include <ctype.h>
void RmWs(char* str);

%}

ws [ \t]+
digits [0-9]
number 0|([1-9]+{digits}*)
/************* Start: add your definitions here */
op [-]
lb [(]
rb [)]
num {ws}*{number}{ws}*
sethelper [,-]{num}
set {ws}*[{]{num}{sethelper}*[}]{ws}*

/* End: add your definitions here */


%%
{op}|\n return *yytext;
{lb}	return LB;
{rb}	return RB;
{set}   {RmWs(yytext); yylval = (char*)malloc(sizeof(char)*MAXL); strcpy(yylval,yytext); return SET;};
[&]      return INTERSECT;
[|]      return UNION;
"MAX"   return MAX;
"MIN"   return MIN;
{ws}
%%

void RmWs(char* str){
  int i=0,j=0;
  char temp[strlen(str)+1];
  double x,y;
  strcpy(temp,str);
  while (temp[i]!='\0'){
        while (temp[i]==' '||temp[i]=='\t'){i++;}
        str[j]=temp[i];
        i++; j++;
  }
 str[j]='\0';
}
