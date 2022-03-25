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
%type <ast> rvalue
%type <ast> lvalue
%type <ast> code_block
%type <ast> operator_list
%type <ast> proc_call
%type <ast> push_list
%type <ast> operator
%type <ast> assignment
%type <ast> if_operator
%type <ast> while_operator

%%

root: global;

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
    T_PROC T_IDENTIFIER args { $$ = ast_new_proc_header($2, $3   ); }
  | T_PROC T_IDENTIFIER      { $$ = ast_new_proc_header($2, NULL ); };
args:
    T_IDENTIFIER ',' args { $$ = ast_new_arg_list($1, $3   ); }
  | T_IDENTIFIER          { $$ = ast_new_arg_list($1, NULL ); }
  ;

declare_vars: T_VAR vars { $$ = $2; };
vars:
  decl_var ',' vars { $$ = ast_new_var_list($1, $3   ); }
  | decl_var        { $$ = ast_new_var_list($1, NULL ); }
  ;
decl_var:
    T_IDENTIFIER '[' T_NUMBER ']' { $$ = ast_new_decl_var($1, $3 ); }
  | T_IDENTIFIER                  { $$ = ast_new_decl_var($1,  1 ); }
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
    T_IDENTIFIER push_list ';' { $$ = ast_new_proc_call($1, $2   ); }
  | T_IDENTIFIER           ';' { $$ = ast_new_proc_call($1, NULL ); }
  ;
push_list:
  rvalue ',' push_list { $$ = ast_new_push_list($1, $3); }
  | rvalue { $$ = ast_new_push_list($1, NULL); }
  ;

assignment: lvalue T_ASSIGN rvalue ';' { $$ = ast_new_assign($1, $3); };

if_operator:
  T_IF rvalue code_block T_ELSE code_block { $$ = ast_new_if($2, $3, $5); }
  | T_IF rvalue code_block { $$ = ast_new_if($2, $3, NULL); }
  ;

while_operator: T_WHILE rvalue code_block { $$ = ast_new_while($2, $3); };

rvalue:
  '(' rvalue ')' { $$ = $2; }
  | '&' lvalue {
    struct ast_lvalue *ptr = AST_CAST($2, struct ast_lvalue);
    $$ = ptr->calc_addr;
    ptr->calc_addr = NULL;
    ast_free($2);
  }
  | lvalue { $$ = ast_new_lvalue($1); }
  | T_NUMBER { $$ = ast_new_constant($1); }

  | rvalue '+'   rvalue { $$ = ast_new_binop( '+'   , $1, $3); }
  | rvalue '-'   rvalue { $$ = ast_new_binop( '-'   , $1, $3); }
  | rvalue '*'   rvalue { $$ = ast_new_binop( '*'   , $1, $3); }
  | rvalue '/'   rvalue { $$ = ast_new_binop( '/'   , $1, $3); }
  | rvalue '%'   rvalue { $$ = ast_new_binop( '%'   , $1, $3); }
  | rvalue T_EQ  rvalue { $$ = ast_new_binop( T_EQ  , $1, $3); }
  | rvalue T_NEQ rvalue { $$ = ast_new_binop( T_NEQ , $1, $3); }
  | rvalue '>'   rvalue { $$ = ast_new_binop( '>'   , $1, $3); }
  | rvalue '<'   rvalue { $$ = ast_new_binop( '<'   , $1, $3); }
  | rvalue T_AND rvalue { $$ = ast_new_binop( T_AND , $1, $3); }
  | rvalue T_OR  rvalue { $$ = ast_new_binop( T_OR  , $1, $3); }
  | rvalue T_XOR rvalue { $$ = ast_new_binop( T_XOR , $1, $3); }

  | '-'   rvalue %prec P_UNARY { $$ = ast_new_unop( '-'   , $2); }
  | '+'   rvalue %prec P_UNARY { $$ = ast_new_unop( '+'   , $2); }
  | T_NOT rvalue %prec P_UNARY { $$ = ast_new_unop( T_NOT , $2); }
  ;

lvalue:
  T_IDENTIFIER { $$ = ast_new_refname($1); }
  | '[' rvalue ']' { $$ = ast_new_lvalue($2); }
  ;

%%
