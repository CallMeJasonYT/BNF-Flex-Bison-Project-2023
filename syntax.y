%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>
#include<setjmp.h>

typedef struct id_list {
    char* id;
    struct id_list* next;
} id_list;

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
%{
  jmp_buf buf;
  id_list* head = NULL;
  bool id_found = false;
%}
%%

file: comment RelativeLayout | comment LinearLayout;

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

comment: /* empty */
         | COMO comment_text COMC

comment_text: /* empty */
            | comment_text CHAR
            ;

id: /*empty*/
    | ID DQUOTES STRING DQUOTES{
        // check if id already exists in linked list
        id_found = false;
        id_list* cur = head;
        while (cur != NULL) {
            if (strcmp(cur->id, $3) == 0) {
                id_found = true;
                break;
            }
            cur = cur->next;
        }
        // if id is found, report an error
        if (id_found) {
            printf("Error: id %s already exists\n", $3);
            longjmp(buf, 1);
        }
        // otherwise, add id to linked list
        id_list* new_id = malloc(sizeof(id_list));
        new_id->id = $3;
        new_id->next = NULL;
        if (head == NULL) {
            head = new_id;
        } else {
            id_list* tail = head;
            while (tail->next != NULL) {
                tail = tail->next;
            }
            tail->next = new_id;
        }
    };


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
    if(setjmp(buf) != 0) {
        printf("\nUnsuccessful parsing\n");
        return 1;
    }
    if(yyparse()==0){
        printf("Succesfull Parsing\n");
    }
    else{
        printf("\nUnsuccesfull parsing\n");

    }
}