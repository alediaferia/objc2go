%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
#include "objc2go.h"

%}

%%
\+                                return PLUSTOK;
\-                                return MINUSTOK;
;                                 return SEMICOLON;
:                                 return COLON;
\(                                return OPAREN;
\)                                return EPAREN;
const                             return CONSTTOK;
([a-zA-Z_]+[0-9]*)+                yylval=strdup(yytext); return WORD;
(\*)*                             return PTRTOK;
\@interface                       return OINTRFCTOK;
\@end                             return EINTRFCTOK;
\@class                           return OCLASSTOK;
\,                                return COMMA;
\>                                return ECHEVR;
\<                                return OCHEVR;
\n                                /* just ignore newlines */
[ \t]+                            /* just ignore tabs */;
\/\*(.*(\n|\t|\r)*)*\*\/          /* just ignore comments */;
\/\/.*                            /* just ignore comments */;
\#[a-zA-Z].*                      /* just ignore preprocessor */;
typedef(.*(\n|\t|\r)*)*;          /* just ignore typedefs */;
enum(.*(\n|\t|\r)*)*;             /* just ignore enums */;
\@property(.*(\n|\t|\r)*)*;       /* just ignore properties */;
%%

