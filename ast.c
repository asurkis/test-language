#include "ast.h"
#include "lex.yy.h"
#include "parser.tab.h"

#define AST_CAST_SELF(type)                                                    \
  struct ast_##type *self = AST_CAST(node, struct ast_##type);

#define TRAVERSE_PRINT_INDENT                                                  \
  do {                                                                         \
    for (i = 0; i < indent; ++i)                                               \
      fputs("|   ", stdout);                                                   \
  } while (0)

#define TRAVERSE_PRINT_HEADER(type)                                            \
  AST_CAST_SELF(type)                                                          \
  int i;                                                                       \
  TRAVERSE_PRINT_INDENT;                                                       \
  fputs(#type, stdout);

static void ast_traverse_print_global(struct ast *node, int indent) {
  AST_CAST_SELF(global)
  ast_traverse_print(self->item, indent);
  ast_traverse_print(self->next, indent);
}

static void ast_traverse_print_procedure(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(procedure)
  fputc('\n', stdout);
  ast_traverse_print(self->header, indent + 1);
  ast_traverse_print(self->vars, indent + 1);
  ast_traverse_print(self->code, indent + 1);
}

static void ast_traverse_print_proc_header(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(proc_header)
  printf(" %s\n", self->name);
  ast_traverse_print(self->args, indent + 1);
}

static void ast_traverse_print_arg_list(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(arg_list)
  printf(" %s\n", self->name);
  ast_traverse_print(self->next, indent);
}

static void ast_traverse_print_var_list(struct ast *node, int indent) {
  AST_CAST_SELF(var_list)
  ast_traverse_print(self->decl, indent);
  ast_traverse_print(self->next, indent);
}

static void ast_traverse_print_decl_var(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(decl_var)
  printf(" %s [ %d ]\n", self->name, self->size);
}

static void ast_traverse_print_op_list(struct ast *node, int indent) {
  AST_CAST_SELF(op_list)
  ast_traverse_print(self->op, indent);
  ast_traverse_print(self->next, indent);
}

static void ast_traverse_print_proc_call(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(proc_call)
  printf(" %s\n", self->name);
  ast_traverse_print(self->push_list, indent + 1);
}

static void ast_traverse_print_push_list(struct ast *node, int indent) {
  AST_CAST_SELF(push_list)
  ast_traverse_print(self->expr, indent);
  ast_traverse_print(self->next, indent);
}

static void ast_traverse_print_assign(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(assign)
  fputc('\n', stdout);
  ast_traverse_print(self->left, indent + 1);
  ast_traverse_print(self->right, indent + 1);
}

static void ast_traverse_print_if(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(if)
  ast_traverse_print(self->cond, indent + 1);
  ast_traverse_print(self->if_true, indent + 1);
  ast_traverse_print(self->if_false, indent + 1);
}

static void ast_traverse_print_while(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(while)
  ast_traverse_print(self->cond, indent + 1);
  ast_traverse_print(self->body, indent + 1);
}

static void ast_traverse_print_binop(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(binop)
  switch (self->code) {
  case '+':
    puts(" +");
    break;
  case '-':
    puts(" -");
    break;
  case '*':
    puts(" *");
    break;
  case '/':
    puts(" /");
    break;
  case '%':
    puts(" %");
    break;
  case T_EQ:
    puts(" ==");
    break;
  case T_NEQ:
    puts(" !=");
    break;
  case '>':
    puts(" >");
    break;
  case '<':
    puts(" <");
    break;
  case T_AND:
    puts(" and");
    break;
  case T_OR:
    puts(" or");
    break;
  case T_XOR:
    puts(" xor");
    break;
  }
  ast_traverse_print(self->left, indent + 1);
  ast_traverse_print(self->right, indent + 1);
}

static void ast_traverse_print_unop(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(unop)
  switch (self->code) {
  case '+':
    puts(" +");
    break;
  case '-':
    puts(" -");
    break;
  case T_NOT:
    puts(" not");
    break;
  }
  ast_traverse_print(self->arg, indent + 1);
}

static void ast_traverse_print_constant(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(constant)
  printf(" %d\n", self->value);
}

static void ast_traverse_print_refname(struct ast *node, int indent) {
  TRAVERSE_PRINT_HEADER(refname)
  printf(" %s\n", self->name);
}

static void ast_traverse_translate_global(struct ast *node,
                                          struct translate_context *context) {
  AST_CAST_SELF(global)
  ast_traverse_translate(self->item, context);
  ast_traverse_translate(self->next, context);
}

static void
ast_traverse_translate_procedure(struct ast *node,
                                 struct translate_context *context) {
  AST_CAST_SELF(procedure)
  ast_traverse_translate(self->header, context);
  context->proc_vars = self->vars;
  ast_traverse_translate(self->code, context);
}

static void
ast_traverse_translate_proc_header(struct ast *node,
                                   struct translate_context *context) {
  AST_CAST_SELF(proc_header)
  printf("p_%s:\n", self->name);
  context->proc_args = self->args;
}

static void ast_traverse_translate_arg_list(struct ast *node,
                                            struct translate_context *context) {
  AST_CAST_SELF(arg_list)
}

static void ast_traverse_translate_var_list(struct ast *node,
                                            struct translate_context *context) {
  AST_CAST_SELF(var_list)
  ast_traverse_translate(self->decl, context);
  ast_traverse_translate(self->next, context);
}

static void ast_traverse_translate_decl_var(struct ast *node,
                                            struct translate_context *context) {
  AST_CAST_SELF(decl_var)
  printf("g_%s:\n", self->name);
  printf("\tdata 0 %d\n", self->size);
}

static void ast_traverse_translate_op_list(struct ast *node,
                                           struct translate_context *context) {
  AST_CAST_SELF(op_list)
  ast_traverse_translate(self->op, context);
  ast_traverse_translate(self->next, context);
}

static void translate_push(int reg) {
  printf("\tli x%d 1\n", reg + 1);
  printf("\tadd x1 x1 x%d\n", reg + 1);
  printf("\ts x%d x1\n", reg);
}

static void translate_pop(int reg) {
  printf("\tli x%d 1\n", reg + 1);
  printf("\tl x%d x1\n", reg);
  printf("\tsub x1 x1 x%d\n", reg + 1);
}

static void
ast_traverse_translate_proc_call(struct ast *node,
                                 struct translate_context *context) {
  AST_CAST_SELF(proc_call)
  if (strcmp("read", self->name) == 0) {
    struct ast_push_list *first =
        AST_CAST(self->push_list, struct ast_push_list);
    context->register_counter = 3;
    ast_traverse_translate(first->expr, context);
    printf("\teread x4\n");
    printf("\ts x4 x3\n");
  } else if (strcmp("write", self->name) == 0) {
    struct ast_push_list *first =
        AST_CAST(self->push_list, struct ast_push_list);
    context->register_counter = 3;
    ast_traverse_translate(first->expr, context);
    printf("\tewrite x3\n");
  } else {
    translate_push(2);
    context->stack_depth = 0;
    ast_traverse_translate(self->push_list, context);
    printf("\tli x2 p_%s\n", self->name);
    printf("\tjal x2 x2\n");
    printf("\tli x2 %d\n", context->stack_depth);
    printf("\tsub x1 x1 x2\n");
    translate_pop(2);
  }
}

static void
ast_traverse_translate_push_list(struct ast *node,
                                 struct translate_context *context) {
  AST_CAST_SELF(push_list)
  context->register_counter = 3;
  ast_traverse_translate(self->expr, context);
  translate_push(context->register_counter);
  ast_traverse_translate(self->next, context);
}

static void ast_traverse_translate_assign(struct ast *node,
                                          struct translate_context *context) {
  AST_CAST_SELF(assign)
  context->register_counter = 3;
  ast_traverse_translate(self->left, context);
  context->register_counter++;
  ast_traverse_translate(self->right, context);
  printf("\ts x4 x3\n");
}

static void ast_traverse_translate_if(struct ast *node,
                                      struct translate_context *context) {
  AST_CAST_SELF(if)
  context->register_counter = 3;
  ast_traverse_translate(self->cond, context);
  int label = context->label_counter++;
  printf("\tli x4 if_%d_false\n", label);
  printf("\tbeq x0 x3 x4\n");
  ast_traverse_translate(self->if_true, context);
  if (self->if_false) {
    printf("\tli x3 if_%d_end\n", label);
    printf("\tjal x0 x3\n");
  }
  printf("if_%d_false:\n", label);
  ast_traverse_translate(self->if_false, context);
  printf("if_%d_end:\n");
}

static void ast_traverse_translate_while(struct ast *node,
                                         struct translate_context *context) {
  AST_CAST_SELF(while)
  context->register_counter = 3;
  ast_traverse_translate(self->cond, context);
  int label = context->label_counter++;
  printf("\tli x4 while_%d_end\n", label);
  printf("\tbeq x0 x3 x4\n");
  ast_traverse_translate(self->body, context);
  printf("while_%d_end:\n", label);
}

static void ast_traverse_translate_binop(struct ast *node,
                                         struct translate_context *context) {
  AST_CAST_SELF(binop)
  ast_traverse_translate(self->left, context);
  context->register_counter++;
  ast_traverse_translate(self->right, context);
  context->register_counter--;
  switch (self->code) {
  case '+':
    printf("\tadd x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '-':
    printf("\tsub x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '*':
    printf("\tmul x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '/':
    printf("\tdiv x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '%':
    printf("\tmod x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case T_EQ:
    printf("\teq x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case T_NEQ:
    printf("\tneq x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '>':
    printf("\tgt x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case '<':
    printf("\tlt x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case T_AND:
    printf("\tand x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case T_OR:
    printf("\tor x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  case T_XOR:
    printf("\txor x%d x%d x%d\n", context->register_counter,
           context->register_counter, context->register_counter + 1);
    break;
  }
}

static void ast_traverse_translate_unop(struct ast *node,
                                        struct translate_context *context) {
  AST_CAST_SELF(unop)
  ast_traverse_translate(self->arg, context);
  switch (self->code) {
  case '-':
    printf("\tneg x%d x%d\n", context->register_counter,
           context->register_counter);
    break;
  case '+':
    printf("\t x%d x%d\n", context->register_counter,
           context->register_counter);
    break;
  case T_NOT:
    printf("\tnot x%d x%d\n", context->register_counter,
           context->register_counter);
    break;
  case '*':
    printf("\tl x%d x%d\n", context->register_counter,
           context->register_counter);
    break;
  }
}

static void ast_traverse_translate_constant(struct ast *node,
                                            struct translate_context *context) {
  AST_CAST_SELF(constant)
  printf("\tli x%d %d\n", context->register_counter, self->value);
}

static void ast_traverse_translate_refname(struct ast *node,
                                           struct translate_context *context) {
  AST_CAST_SELF(refname)

}

static void ast_free_global(struct ast *node) {
  AST_CAST_SELF(global);
  ast_free(self->item);
  ast_free(self->next);
  free(self);
}

static void ast_free_procedure(struct ast *node) {
  AST_CAST_SELF(procedure);
  ast_free(self->header);
  ast_free(self->vars);
  ast_free(self->code);
  free(self);
}

static void ast_free_proc_header(struct ast *node) {
  AST_CAST_SELF(proc_header);
  free(self->name);
  ast_free(self->args);
  free(self);
}

static void ast_free_arg_list(struct ast *node) {
  AST_CAST_SELF(arg_list);
  free(self->name);
  ast_free(self->next);
  free(self);
}

static void ast_free_var_list(struct ast *node) {
  AST_CAST_SELF(var_list);
  ast_free(self->decl);
  ast_free(self->next);
  free(self);
}

static void ast_free_decl_var(struct ast *node) {
  AST_CAST_SELF(decl_var);
  free(self->name);
  free(self);
}

static void ast_free_op_list(struct ast *node) {
  AST_CAST_SELF(op_list);
  ast_free(self->op);
  ast_free(self->next);
  free(self);
}

static void ast_free_proc_call(struct ast *node) {
  AST_CAST_SELF(proc_call);
  free(self->name);
  ast_free(self->push_list);
  free(self);
}

static void ast_free_push_list(struct ast *node) {
  AST_CAST_SELF(push_list);
  ast_free(self->expr);
  ast_free(self->next);
  free(self);
}

static void ast_free_assign(struct ast *node) {
  AST_CAST_SELF(assign);
  ast_free(self->left);
  ast_free(self->right);
  free(self);
}

static void ast_free_if(struct ast *node) {
  AST_CAST_SELF(if);
  ast_free(self->cond);
  ast_free(self->if_true);
  ast_free(self->if_false);
  free(self);
}

static void ast_free_while(struct ast *node) {
  AST_CAST_SELF(while);
  ast_free(self->cond);
  ast_free(self->body);
  free(self);
}

static void ast_free_binop(struct ast *node) {
  AST_CAST_SELF(binop);
  ast_free(self->left);
  ast_free(self->right);
  free(self);
}

static void ast_free_unop(struct ast *node) {
  AST_CAST_SELF(unop);
  ast_free(self->arg);
  free(self);
}

static void ast_free_constant(struct ast *node) {
  AST_CAST_SELF(constant);
  free(self);
}

static void ast_free_refname(struct ast *node) {
  AST_CAST_SELF(refname);
  free(self->name);
  free(self);
}

#define AST_DEFINE_TYPE_1(type, type1, arg1)                                   \
  static struct ast_metatable ast_metatable_##type = {                         \
      &ast_free_##type,                                                        \
      &ast_traverse_print_##type,                                              \
      &ast_traverse_translate_##type,                                          \
  };                                                                           \
  struct ast *ast_new_##type(type1 arg1) {                                     \
    struct ast_##type *new_ = malloc(sizeof(struct ast_##type));               \
    if (!new_)                                                                 \
      return NULL;                                                             \
    new_->base.metatable = &ast_metatable_##type;                              \
    new_->arg1 = arg1;                                                         \
    return &new_->base;                                                        \
  }

#define AST_DEFINE_TYPE_2(type, type1, arg1, type2, arg2)                      \
  static struct ast_metatable ast_metatable_##type = {                         \
      &ast_free_##type,                                                        \
      &ast_traverse_print_##type,                                              \
      &ast_traverse_translate_##type,                                          \
  };                                                                           \
  struct ast *ast_new_##type(type1 arg1, type2 arg2) {                         \
    struct ast_##type *new_ = malloc(sizeof(struct ast_##type));               \
    if (!new_)                                                                 \
      return NULL;                                                             \
    new_->base.metatable = &ast_metatable_##type;                              \
    new_->arg1 = arg1;                                                         \
    new_->arg2 = arg2;                                                         \
    return &new_->base;                                                        \
  }

#define AST_DEFINE_TYPE_3(type, type1, arg1, type2, arg2, type3, arg3)         \
  static struct ast_metatable ast_metatable_##type = {                         \
      &ast_free_##type,                                                        \
      &ast_traverse_print_##type,                                              \
      &ast_traverse_translate_##type,                                          \
  };                                                                           \
  struct ast *ast_new_##type(type1 arg1, type2 arg2, type3 arg3) {             \
    struct ast_##type *new_ = malloc(sizeof(struct ast_##type));               \
    if (!new_)                                                                 \
      return NULL;                                                             \
    new_->base.metatable = &ast_metatable_##type;                              \
    new_->arg1 = arg1;                                                         \
    new_->arg2 = arg2;                                                         \
    new_->arg3 = arg3;                                                         \
    return &new_->base;                                                        \
  }

AST_DEFINE_TYPE_2(global, struct ast *, item, struct ast *, next);
AST_DEFINE_TYPE_3(procedure, struct ast *, header, struct ast *, vars,
                  struct ast *, code);
AST_DEFINE_TYPE_2(proc_header, char *, name, struct ast *, args);
AST_DEFINE_TYPE_2(arg_list, char *, name, struct ast *, next);
AST_DEFINE_TYPE_2(var_list, struct ast *, decl, struct ast *, next);
AST_DEFINE_TYPE_2(decl_var, char *, name, int, size);
AST_DEFINE_TYPE_2(op_list, struct ast *, op, struct ast *, next);
AST_DEFINE_TYPE_2(proc_call, char *, name, struct ast *, push_list);
AST_DEFINE_TYPE_2(push_list, struct ast *, expr, struct ast *, next);
AST_DEFINE_TYPE_2(assign, struct ast *, left, struct ast *, right);
AST_DEFINE_TYPE_3(if, struct ast *, cond, struct ast *, if_true, struct ast *,
                  if_false);
AST_DEFINE_TYPE_2(while, struct ast *, cond, struct ast *, body);
AST_DEFINE_TYPE_3(binop, int, code, struct ast *, left, struct ast *, right);
AST_DEFINE_TYPE_2(unop, int, code, struct ast *, arg);
AST_DEFINE_TYPE_1(constant, int, value);
AST_DEFINE_TYPE_1(refname, char *, name);

void yyerror(char const *s) { fprintf(stderr, "%s\n", s); }

struct ast *result;

int main(int argc, char **argv) {
  int retcode = yyparse();
  if (retcode)
    return retcode;
  if (argc > 1 && argv[1][0] == 't') {
    ast_traverse_print(result, 0);
  } else {
    struct translate_context context;
    context.register_counter = 0;
    context.label_counter = 0;
    printf("\tli x1 l_stack_begin\n");
    printf("\tli x2 p_main\n");
    printf("\tjal x2 x2\n");
    printf("\tehlt\n");
    ast_traverse_translate(result, &context);
    printf("l_stack_begin:\n");
  }
  ast_free(result);
  return 0;
}
