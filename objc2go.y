%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define YYERROR_VERBOSE 1
#define YYDEBUG 1

extern int yyparse();
extern int yylex();
extern FILE* yyin;
void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\nline: %d\n", str);
}
 
int yywrap()
{
        return 1;
} 

void print_help(char *argv[]) {
    printf("Welcome to Obj2Go\n");
    printf("------------------\n\n");
    printf("Usage: %s -i <input-file.h> [-o <output-dir>]\n", argv[0]);
    printf("\n");
    printf("-i <input-file.h>         Specifies the input Objective-C file to parse\n");
    printf("-o <output-dir>           Specifies the output directory for the output files. If omitted the current directory will be used\n");
    printf("\n\n");
}

char *output_dir = "./";
char *input_file;
  
int main(int argc, char *argv[])
{
    if (argc <= 1) {
        print_help(argv);
        exit(1);
    }

    int curopt = 0; // 1 = inputfile, 2 = outputfile
    for (int i = 1; i < argc; i++) {
        switch (curopt) {
        case 1:
          input_file = strdup(argv[i]);
          break;
        case 2:
          output_dir = strdup(argv[i]);
          break;
        default:
        {
            if (!strcmp(argv[i], "-i")) {
                curopt = 1;
            } else if (!strcmp(argv[i], "-o")) {
                curopt = 2;
            } else {
                fprintf(stderr, "Unrecognized option '%s'\n", argv[i]);
                print_help(argv);
                exit(1);
            }
        }
        }
    }

    FILE *input = fopen(input_file, "r"); 
    if (input == NULL) {
        fprintf(stderr, "Cannot open input file at path %s\n", input_file);
        exit(1);
    }
    yyin = input;

    yyparse();

    fclose(input);

    return 0;
} 


%}

%token PLUSTOK MINUSTOK SEMICOLON COLON OPAREN EPAREN PTRTOK
%token OINTRFCTOK EINTRFCTOK COMMA ECHEVR OCHEVR OCLASSTOK

%union
{
  int  n;
  char *string;
}

%token <string> WORD

%%
methods:
       | methods method
       ;

stype: /* simple type */
	  WORD
	 ;
      
cstype: /* const simple type */
      CONSTTOK stype
      ;
    
ptype: /* pointer type */
     stype PTRTOK
     ;
     
ctypep: /* const type pointer */
      CONSTTOK ptype
      ;

typen:
     WORD
     |
     WORD PTRTOK
     ;

ltypens: /* empty */
      | ltypens COMMA typen
      ;

ptypens: /* protocol types defs */
       | ptypens COMMA WORD
       ;

method_arg:
      WORD COLON OPAREN typen EPAREN WORD
      ;

method_args:
      |
      method_args method_arg
      ;

member_method_noargs:
       MINUSTOK OPAREN typen EPAREN WORD SEMICOLON
       ;

member_method_onearg:
       MINUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD SEMICOLON
       ;

member_method_moreargs:
      MINUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD method_args SEMICOLON
      ;

static_method_noargs:
      PLUSTOK OPAREN typen EPAREN WORD SEMICOLON
      ;

static_method_onearg:
      PLUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD SEMICOLON
      ;

static_method_moreargs:
      PLUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD method_args SEMICOLON
      ;

member_method: 
             member_method_noargs
             |
             member_method_onearg 
             |
             member_method_moreargs
             ;

static_method:
             static_method_noargs 
             | 
             static_method_onearg 
             |
             static_method_moreargs
             ;

method:
      member_method
      |
      static_method
      ;

class: 
     OCLASSTOK typen SEMICOLON
     |
     OCLASSTOK typens SEMICOLON
     ;

interface_head:
      OINTRFCTOK static_type COLON static_type
      |
      OINTRFCTOK static_type COLON static_type OCHEVR ptypens ECHEVR
      ;
%%
