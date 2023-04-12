%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>
#include<stdlib.h>
#define ECHO fwrite(yytext,yyleng,1,yyout)
#include "syntax.tab.h"
extern void yyerror(const char* s);
%}
%option yylineno
%option noyywrap
%%
"<" {ECHO; return LANGE;}
">" {ECHO; return RANGLE;}
"/" {ECHO; return SLASH;}

"RelativeLayout" {ECHO; return RELATIVE;}
"LinearLayout" {ECHO; return LINEAR;}
"TextView" {ECHO; return TEXTVIEW;}
"ImageView" {ECHO; return IMAGEVIEW;}
"Button" {ECHO; return BUTTON;}
"RadioGroup" {ECHO; return RADIOG;}
"RadioButton" {ECHO; return RADIOB;}
"ProgressBar" {ECHO; return PROGRESSB;}
[0-9]+ {ECHO; yylval.integer=atoi(yytext); return INTEGER;}
"[^"']*\" {yylval.string=strdup(yytext); ECHO; return STRING;}
"\n" {}
[\t]+ {}
. {}
%%