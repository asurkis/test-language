%{
#include "ast.h"
#include <math.h>
%}

%union {
  char *identifier;
  int number;
}

%token T_PROC T_VAR T_IF T_ELSE T_WHILE T_ASSIGN T_EQ T_NEQ T_NOT T_AND T_OR T_XOR
%token T_NUMBER
%token T_IDENTIFIER

%left T_EQ T_NEQ '>' '<'
%left T_OR T_XOR
%left T_AND
%left '+' '-'
%left '*' '/' '%'
%precedence P_UNARY

%%

root: global;
global: global_item global | global_item;
global_item: proc | declare_vars;
proc: proc_header declare_vars code_block | proc_header code_block;
proc_header: T_PROC T_IDENTIFIER vars_list | T_PROC T_IDENTIFIER;
declare_vars: T_VAR vars_list;
vars_list: T_IDENTIFIER ',' vars_list | T_IDENTIFIER;
code_block: '{' operator_list '}' | '{' '}';
operator_list: operator operator_list | operator;
operator: proc_call | assignment | if_operator | while_operator | code_block;
proc_call: T_IDENTIFIER expr_list ';' | T_IDENTIFIER ';';
expr_list: expr ',' expr_list | expr;
assignment: lvalue T_ASSIGN expr ';'
if_operator: T_IF expr code_block T_ELSE code_block | T_IF expr code_block;
while_operator: T_WHILE expr code_block;

expr: '(' expr ')' | expr binop expr | unop expr %prec P_UNARY | '&' lvalue | lvalue | T_NUMBER;
binop: '-' | '+' | '*' | '/' | '%' | T_EQ | T_NEQ | '>' | '<' | T_AND | T_OR | T_XOR;
unop: '-' | '+' | '*';
lvalue: T_IDENTIFIER '[' expr ']' | T_IDENTIFIER;

%%
