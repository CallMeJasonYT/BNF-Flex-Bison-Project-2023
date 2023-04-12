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
%token LWIDTH LHEIGHT ID ORIENTATION TEXT TEXTCOLOUR SRC PADDING CHECKEDB MAX PROGRESS
%token SLASH LANGLE RANGLE DQUOTES COMO COMC CHAR
%token <integer> INTEGER
%token <string> STRING

%union{
char* string;
unsigned int integer;
}

%start file
%%

file: comment RelativeLayout | comment LinearLayout;

LinearLayout: LANGLE LINEAR
              reqattr1 id orientation
              RANGLE
              contentp
              LANGLE SLASH LINEAR RANGLE;

RelativeLayout: LANGLE RELATIVE
                reqattr1 id
                RANGLE
                contents
                LANGLE SLASH RELATIVE RANGLE;

TextView: LANGLE TEXTVIEW
          reqattr2 id tcolor
          SLASH RANGLE;

ImageView: LANGLE IMAGEVIEW
           reqattr3 id padding
           SLASH RANGLE;
              
Button: LANGLE BUTTON
        reqattr2 id padding
        SLASH RANGLE;

RadioGroup: LANGLE RADIOG
            reqattr1 id cbutton
            RANGLE
            RadioButton
            LANGLE SLASH RADIOG RANGLE;

RadioButton: RadioButton tempRB
             | tempRB;
tempRB: comment | LANGLE BUTTON reqattr2 id SLASH RANGLE

ProgressBar: LANGLE PROGRESSB 
             reqattr1 id max progress
             SLASH RANGLE;
                   
reqattr1: lwidth lheight;
reqattr2: lwidth lheight text;
reqattr3: lheight lwidth src;

contentp: contentp content
          | content;
contents: /*empty*/
          | contents content
          | content;
content: LinearLayout | RelativeLayout | TextView | ImageView | Button | RadioGroup | RadioButton | ProgressBar | comment

elem: INTEGER | STRING;

comment: /*empty*/
         | COMO comment_content COMC;

comment_content: /*empty*/
                 | comment_text comment_content 
                 | '-' comment_text comment_content;
comment_text: CHAR;

lwidth: LWIDTH elem DQUOTES;
lheight: LHEIGHT elem DQUOTES;
text: TEXT STRING DQUOTES;
src: SRC STRING DQUOTES;

id: /*empty*/
    | ID STRING DQUOTES;
orientation: /*empty*/
             | ORIENTATION STRING DQUOTES;
tcolor: /*empty*/
        | TEXTCOLOUR STRING DQUOTES;
padding: /*empty*/
        | PADDING INTEGER DQUOTES;
cbutton: /*empty*/ 
         | CHECKEDB STRING DQUOTES;
max: /*empty*/
     | MAX INTEGER DQUOTES;
progress: /*empty*/
          | PROGRESS INTEGER DQUOTES;

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
        printf("\nunsuccesfull parsing on line:\n");

    }
}