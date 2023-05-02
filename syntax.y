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
%token LWIDTH LHEIGHT ID ORIENTATION TEXT TEXTCOLOUR SRC PADDING CHECKEDB MAX PROGRESS RBCOUNT
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
  int progress_max = 0;
  int rbcounter = 0;
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
            RBCOUNT DQUOTES INTEGER DQUOTES
            id cbutton
            RANGLE
            tempRB
            RadioButton
            LANGLE SLASH RADIOG RANGLE{
                if($13 != rbcounter){
                    printf("\nError: RadioButtonCount value must be equal to %d", rbcounter);
                    longjmp(buf, 1);
                }
                rbcounter = 0;
            }

RadioButton: /*empty*/
             | RadioButton tempRB

tempRB: LANGLE RADIOB 
        LWIDTH DQUOTES elem DQUOTES
        LHEIGHT DQUOTES elem DQUOTES
        TEXT DQUOTES STRING DQUOTES
        id
        SLASH RANGLE{
                rbcounter++;
             };

ProgressBar: LANGLE PROGRESSB 
             LWIDTH DQUOTES elem DQUOTES 
             LHEIGHT DQUOTES elem DQUOTES 
             id max progress
             SLASH RANGLE;

contentp: contentp content
          | content;
contents: /*empty*/
          | contents content;
content: LinearLayout | RelativeLayout | TextView | ImageView | Button | RadioGroup | ProgressBar

elem: INTEGER {
    // check if the integer value is positive
    if ($1 <= 0) {
        printf("\nError: elem value must be a positive integer, wrap_content, or match_parent");
        longjmp(buf, 1);
    }
} 
| STRING {
    // check if the string value is "wrap_content" or "match_parent"
    if (strcmp($1, "wrap_content") != 0 && strcmp($1, "match_parent") != 0) {
        printf("\nError: elem value must be a positive integer, wrap_content, or match_parent");
        longjmp(buf, 1);
    }
};

comment: /* empty */

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
            printf("\nError: id %s already exists", $3);
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
        | PADDING DQUOTES INTEGER DQUOTES{
            if($3 <= 0) {
                printf("\nError: Padding value must be a Possitive integer");
                longjmp(buf, 1);
            }
        };

cbutton: /*empty*/ 
         | CHECKEDB DQUOTES STRING DQUOTES

max: /*empty*/
     | MAX DQUOTES INTEGER DQUOTES{
            progress_max = $3;
     };
progress: /*empty*/
          | PROGRESS DQUOTES INTEGER DQUOTES{
                if($3 <= 0 || $3 > progress_max){
                    printf("\nError: Progress value must a Value between 0 and %d", progress_max);
                    longjmp(buf, 1);
                }
          };

%%

void yyerror(const char* s){
    fprintf(stderr,"%s in line : %d\n ",s,yylineno);
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
    }
    if(yyparse()==0){
        printf("Succesfull Parsing\n");
    }
    else{
        printf("\nUnsuccesfull parsing\n");
        yyerror("Parse Error");

    }
}