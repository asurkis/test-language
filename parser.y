%{
#include "ast.h"
#include <math.h>
#include <stddef.h>
%}

%union {
  struct ast *ast;
  char *identifier;
  int number;
}

%token T_PROC T_VAR T_IF T_ELSE T_WHILE T_ASSIGN T_EQ T_NEQ T_NOT T_AND T_OR T_XOR
%token <number> T_NUMBER
%token <identifier> T_IDENTIFIER

%left T_EQ T_NEQ '>' '<'
%left T_OR T_XOR
%left T_AND
%left '+' '-'
%left '*' '/' '%'
%precedence P_UNARY

%type <ast> global
%type <ast> global_item
%type <ast> proc
%type <ast> proc_header
%type <ast> args
%type <ast> declare_vars
%type <ast> vars
%type <ast> decl_var
%type <ast> expr
%type <ast> code_block
%type <ast> operator_list
%type <ast> proc_call
%type <ast> push_list
%type <ast> operator
%type <ast> assignment
%type <ast> if_operator
%type <ast> while_operator

%%

root: global { result = $1; };

global:
    global_item global { $$ = ast_new_global($1, $2   ); }
  | global_item        { $$ = ast_new_global($1, NULL ); }
  ;
global_item: proc | declare_vars;

proc:
    proc_header declare_vars code_block { $$ = ast_new_procedure($1, $2   , $3); }
  | proc_header              code_block { $$ = ast_new_procedure($1, NULL , $2); }
  ;
proc_header:
    T_PROC T_IDENTIFIER '(' args ')' { $$ = ast_new_proc_header(copy_str($2), $4   ); }
  | T_PROC T_IDENTIFIER '('      ')' { $$ = ast_new_proc_header(copy_str($2), NULL ); };
args:
    T_IDENTIFIER ',' args { $$ = ast_new_arg_list(copy_str($1), $3   ); }
  | T_IDENTIFIER          { $$ = ast_new_arg_list(copy_str($1), NULL ); }
  ;

declare_vars: T_VAR vars { $$ = $2; };
vars:
    decl_var ',' vars { $$ = ast_new_var_list($1, $3   ); }
  | decl_var          { $$ = ast_new_var_list($1, NULL ); }
  ;
decl_var:
    T_IDENTIFIER '[' T_NUMBER ']' { $$ = ast_new_decl_var(copy_str($1), $3 ); }
  | T_IDENTIFIER                  { $$ = ast_new_decl_var(copy_str($1),  1 ); }
  ;

code_block:
    '{' operator_list '}' { $$ = $2   ; }
  | '{'               '}' { $$ = NULL ; }
  ;
operator_list:
    operator operator_list { $$ = ast_new_op_list($1, $2   ); }
  | operator               { $$ = ast_new_op_list($1, NULL ); }
  ;
operator: proc_call | assignment | if_operator | while_operator | code_block;

proc_call:
    T_IDENTIFIER '(' push_list ')' ';' { $$ = ast_new_proc_call(copy_str($1), $3   ); }
  | T_IDENTIFIER '('           ')' ';' { $$ = ast_new_proc_call(copy_str($1), NULL ); }
  ;
push_list:
  expr ',' push_list { $$ = ast_new_push_list($1, $3); }
  | expr { $$ = ast_new_push_list($1, NULL); }
  ;

assignment: expr T_ASSIGN expr ';' { $$ = ast_new_assign($1, $3); };

if_operator:
  T_IF expr code_block T_ELSE code_block { $$ = ast_new_if($2, $3, $5); }
  | T_IF expr code_block { $$ = ast_new_if($2, $3, NULL); }
  ;

while_operator: T_WHILE expr code_block { $$ = ast_new_while($2, $3); };

expr:
  T_NUMBER { $$ = ast_new_constant($1); }
  | T_IDENTIFIER { $$ = ast_new_refname(copy_str($1)); }
  |  '(' expr ')' { $$ = $2; }

  | expr '+'   expr { $$ = ast_new_binop( '+'   , $1, $3); }
  | expr '-'   expr { $$ = ast_new_binop( '-'   , $1, $3); }
  | expr '*'   expr { $$ = ast_new_binop( '*'   , $1, $3); }
  | expr '/'   expr { $$ = ast_new_binop( '/'   , $1, $3); }
  | expr '%'   expr { $$ = ast_new_binop( '%'   , $1, $3); }
  | expr T_EQ  expr { $$ = ast_new_binop( T_EQ  , $1, $3); }
  | expr T_NEQ expr { $$ = ast_new_binop( T_NEQ , $1, $3); }
  | expr '>'   expr { $$ = ast_new_binop( '>'   , $1, $3); }
  | expr '<'   expr { $$ = ast_new_binop( '<'   , $1, $3); }
  | expr T_AND expr { $$ = ast_new_binop( T_AND , $1, $3); }
  | expr T_OR  expr { $$ = ast_new_binop( T_OR  , $1, $3); }
  | expr T_XOR expr { $$ = ast_new_binop( T_XOR , $1, $3); }

  | '-'   expr %prec P_UNARY { $$ = ast_new_unop( '-'   , $2); }
  | '+'   expr %prec P_UNARY { $$ = ast_new_unop( '+'   , $2); }
  | T_NOT expr %prec P_UNARY { $$ = ast_new_unop( T_NOT , $2); }
  | '*'   expr %prec P_UNARY { $$ = ast_new_unop( '*'   , $2); }
  ;

%%
