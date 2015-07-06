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
([a-zA-Z]+[0-9]*)+                yylval=strdup(yytext); return WORD;
(\*)*                             yylval=strdup(yytext); return PTRTOK;
\n                                /* just ignore */;
[ \t]+                            /* just ignore */;
\/\*.*\*\/                        /* just ignore */;
\/\/.*                            /* just ignore */;
%%

