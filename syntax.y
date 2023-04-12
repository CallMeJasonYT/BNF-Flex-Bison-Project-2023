%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>
extern int yylineno;
extern char* yytext;
extern FILE* yyin;
extern FILE* yyout;
int yylex();
void yyerror(const char* s);
int yydebug=1;
%}

%token RELATIVE LINEAR TEXTVIEW IMAGEVIEW BUTTON RADIOG RADIOB PROGRESSB
%token SLASH LANGLE RANGLE
%token <integer> INTEGER
%token <string> STRING

%union{
char* string;
unsigned int integer;
}

%start file
%%

file: comment* RelativeLayout | comment* LinearLayout;

LinearLayout: LANGLE LINEAR
              reqattr1 id? orientation?
              RANGLE
              content+
              LANGLE SLASH LINEAR RANGLE;

RelativeLayout: LANGLE RELATIVE
                reqattr1 id?
                RANGLE
                content*
                LANGLE SLASH RELATIVE RANGLE;

TextView: LANGLE TEXTVIEW
          reqattr2 id? textColor?
          SLASH RANGLE;

ImageView: LANGLE IMAGEVIEW
           reqattr3 id? padding?
           SLASH RANGLE;
              
Button: LANGLE BUTTON
        reqattr2 id? padding?
        SLASH RANGLE;

RadioGroup: LANGLE RADIOG
            reqattr1 id? checkedButton?
            RANGLE
            RadioButton+
            LANGLE SLASH RADIOG RANGLE;

RadioButton: comment | 
             LANGLE BUTTON
             reqattr2 id?
             SLASH RANGLE;

ProgressBar: LANGE PROGRESSB 
             reqattr1 id? max? progress?
             SLASH RANGLE;
                   
reqattr1: lwidth lheight;
reqattr2: lwidth lheight text;
reqattr3: lheight lwidth src;

content: LinearLayout | RelativeLayout | TextView | ImageView | Button | RadioGroup | RadioButton | ProgressBar | comment;
elem: INTEGER | STRING;
comment: '<!--' ((char - '-') | ('-' (char - '-')))* '-->';

lwidth: 'android:layout_width=' '"' elem '"';
lheight: 'android:layout_height=' '"' elem '"';
id: 'android:id=' '"' STRING '"';
orientation: 'android:orientation=' '"' STRING '"';
text: 'android:text=' '"' STRING '"';
src: 'android:src=' '"' STRING '"';
tcolor: 'android:textColor=' '"' STRING '"';
padding: 'android:padding=' '"' INTEGER '"';
cbutton: 'android:checkedButton=' '"' STRING '"';
max: 'android:max=' '"' INTEGER '"';
progress: 'android:progress=' '"' INTEGER '"';
char: %x00-7F;

%%

void yyerror(const char* s){
    fprintf(stderr,"error %s in line : %d\n ",s,yylineno);
}

int main(int argc, char** argv){
    FILE* fp=fopen(argv[1],"r");
    char c=fgetc(fp);
    while(c!=EOF){
    printf("%c",c);
    c=fgetc(fp);
}
    printf("\n\n\n");
    fclose(fp);
    yyin=fopen(argv[1],"r");
    if(yyparse()==0){
        printf("succesfull parsing\n");
    }
    else{
        printf("unsuccesfull parsing on line:\n");
        yyerror("parse error");
    }
}