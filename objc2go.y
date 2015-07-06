%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define YYSTYPE char*
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 

void print_help(char *argv[]) {
    printf("Welcome to Obj2Go\n");
    printf("------------------\n");
    printf("Usage: %s -i <input-file.h> [-o <output-dir>]\n", argv[0]);
    printf("\n");
    printf("-i <input-file.h>         Specifies the input Objective-C file to parse\n");
    printf("-o <output-dir>           Specifies the output directory for the output files. If omitted the current directory will be used\n");
    printf("\n\n");
}

char *output_dir;
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
    yyparse();
} 


%}

%token PLUSTOK MINUSTOK SEMICOLON COLON OPAREN EPAREN WORD PTRTOK

%%
methods:
       | methods method
       ;

static_type: 
        WORD

ptr_type:
     static_type PTRTOK

typen:
     static_type | ptr_type;

method_arg:
      WORD COLON OPAREN typen EPAREN WORD

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

static_method_noargs:
      PLUSTOK OPAREN typen EPAREN WORD SEMICOLON

static_method_onearg:
      PLUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD SEMICOLON

static_method_moreargs:
      PLUSTOK OPAREN typen EPAREN WORD COLON OPAREN typen EPAREN WORD method_args SEMICOLON

member_method: member_method_noargs | member_method_onearg | member_method_moreargs

static_method: static_method_noargs | static_method_onearg | static_method_moreargs

method: member_method | static_method

%%
