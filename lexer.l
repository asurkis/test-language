%{
#include "ast.h"
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%

"proc"  { return T_PROC   ; }
"var"   { return T_VAR    ; }
"if"    { return T_IF     ; }
"else"  { return T_ELSE   ; }
"while" { return T_WHILE  ; }
":="    { return T_ASSIGN ; }
"=="    { return T_EQ     ; }
"!="    { return T_NEQ    ; }
"not"   { return T_NOT    ; }
"and"   { return T_AND    ; }
"or"    { return T_OR     ; }
"xor"   { return T_XOR    ; }
[{}()\[\]+\-*/%&><,;] { return yytext[0]; }

[a-zA-Z_][a-zA-Z_0-9] {
  size_t len = strlen(yytext);
  yylval.identifier = malloc(len + 1);
  strcpy(yylval.identifier, yytext);
  return T_IDENTIFIER; }

[0-9]+ {
  yylval.number = atof(yytext);
  return T_NUMBER; }

[ \t\n] {}
\/\*([^*]*(\*[^/])?)*\*\/ {}

%%
