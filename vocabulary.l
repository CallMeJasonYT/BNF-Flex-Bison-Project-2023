%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>
#include<stdlib.h>
#define ECHO fwrite(yytext,yyleng,1,yyout)
#include "syntax.tab.h"
extern void yyerror(const char* s);
int checkComment(const char* str);
%}
%option yylineno
%option noyywrap
%s COMMENT, INITIAL
%%

<INITIAL>"<!--"{BEGIN(COMMENT);}

<COMMENT>{
    "-->" {BEGIN(INITIAL);}
    "(.|\n)*" {checkComment(yytext);}
}

<INITIAL>{
"<" {ECHO; return LANGLE;}
">" {ECHO; return RANGLE;}
"/" {ECHO; return SLASH;}
\" {ECHO; return DQUOTES;}

android:layout_width= {ECHO; return LWIDTH;}
android:layout_height= {ECHO; return LHEIGHT;}
android:id= {ECHO; return ID;}
android:orientation= {ECHO; return ORIENTATION;}
android:text= {ECHO; return TEXT;}
android:textColour= {ECHO; return TEXTCOLOUR;}
android:src= {ECHO; return SRC;}
android:padding= {ECHO; return PADDING;}
android:checkedButton= {ECHO; return CHECKEDB;}
android:max= {ECHO; return MAX;}
android:progress= {ECHO; return PROGRESS;}
android:radioButtonCount= {ECHO; return RBCOUNT;}

"RelativeLayout" {ECHO; return RELATIVE;}
"LinearLayout" {ECHO; return LINEAR;}
"TextView" {ECHO; return TEXTVIEW;}
"ImageView" {ECHO; return IMAGEVIEW;}
"Button" {ECHO; return BUTTON;}
"RadioGroup" {ECHO; return RADIOG;}
"RadioButton" {ECHO; return RADIOB;}
"ProgressBar" {ECHO; return PROGRESSB;}
[0-9]+ {ECHO; yylval.integer=atoi(yytext); return INTEGER;}
[a-zA-Z0-9_ ]+ {yylval.string=strdup(yytext); ECHO; return STRING;}
[\n] {ECHO;}
[\t]+ {ECHO;}
. {}
}
%%

int checkComment(const char* str) {
    int length = strlen(str);
    int i;

    for (i = 4; i < length - 5; i++) {
        if (str[i] == '-' && str[i+1] == '-') {
            printf("Error: Two consecutive '-' found. Exiting.\n");
            exit(1); // Two consecutive dashes found
        }
    }
    printf("%s\n", str);
    return 0; // No consecutive dashes found
}
