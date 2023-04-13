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

file: RelativeLayout | LinearLayout;

LinearLayout: LANGLE LINEAR
              LWIDTH DQUOTES elem DQUOTES
              LHEIGHT DQUOTES elem DQUOTES
              id
              orientation
              RANGLE
              contentp
              LANGLE SLASH LINEAR RANGLE;

RelativeLayout: LANGLE RELATIVE
                LWIDTH DQUOTES elem DQUOTES 
                LHEIGHT DQUOTES elem DQUOTES 
                id
                RANGLE
                contents
                LANGLE SLASH RELATIVE RANGLE;

TextView: LANGLE TEXTVIEW
          LWIDTH DQUOTES elem DQUOTES 
          LHEIGHT DQUOTES elem DQUOTES 
          TEXT DQUOTES STRING DQUOTES 
          id tcolor
          SLASH RANGLE;

ImageView: LANGLE IMAGEVIEW
           LWIDTH DQUOTES elem DQUOTES
           LHEIGHT DQUOTES elem DQUOTES 
           SRC DQUOTES STRING DQUOTES 
           id padding
           SLASH RANGLE;
              
Button: LANGLE BUTTON
        LWIDTH DQUOTES elem DQUOTES 
        LHEIGHT DQUOTES elem DQUOTES 
        TEXT DQUOTES STRING DQUOTES 
        id padding
        SLASH RANGLE;

RadioGroup: LANGLE RADIOG
            LWIDTH DQUOTES elem DQUOTES
            LHEIGHT DQUOTES elem DQUOTES 
            id cbutton
            RANGLE
            tempRB
            RadioButton
            LANGLE SLASH RADIOG RANGLE;

RadioButton: /*empty*/
             | RadioButton tempRB;
tempRB: LANGLE RADIOB 
        LWIDTH DQUOTES elem DQUOTES
        LHEIGHT DQUOTES elem DQUOTES
        TEXT DQUOTES STRING DQUOTES
        id
        SLASH RANGLE;

ProgressBar: LANGLE PROGRESSB 
             LWIDTH DQUOTES elem DQUOTES LHEIGHT DQUOTES elem DQUOTES id max progress
             SLASH RANGLE;

contentp: contentp content
          | content;
contents: /*empty*/
          | contents content;
content: LinearLayout | RelativeLayout | TextView | ImageView | Button | RadioGroup | ProgressBar

elem: INTEGER | STRING;

comment: /*empty*/
         | COMO CHAR COMC;

id: /*empty*/
    | ID DQUOTES STRING DQUOTES;
orientation: /*empty*/
             | ORIENTATION DQUOTES STRING DQUOTES;
tcolor: /*empty*/
        | TEXTCOLOUR DQUOTES STRING DQUOTES;
padding: /*empty*/
        | PADDING DQUOTES INTEGER DQUOTES;
cbutton: /*empty*/ 
         | CHECKEDB DQUOTES STRING DQUOTES;
max: /*empty*/
     | MAX DQUOTES INTEGER DQUOTES;
progress: /*empty*/
          | PROGRESS DQUOTES INTEGER DQUOTES;

%%

void yyerror(const char* s){
    fprintf(stderr,"Error %s in line : %d\n ",s,yylineno);
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
        printf("Succesfull Parsing\n");
    }
    else{
        printf("\nUnsuccesfull parsing\n");

    }
}