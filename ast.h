#ifndef _AST_H_
#define _AST_H_

#include <stddef.h>

int yylex(void);
void yyerror(char const *s);

struct ast;
extern struct ast *result;

struct translate_context {
  struct ast *proc_args;
  struct ast *proc_vars;
  int register_counter;
  int label_counter;
  int stack_depth;
};

struct ast_metatable {
  void (*free_node)(struct ast *);
  void (*traverse_print)(struct ast *, int);
  void (*traverse_translate)(struct ast *, struct translate_context *);
};

struct ast {
  struct ast_metatable *metatable;
};

static inline void ast_free(struct ast *node) {
  if (node)
    node->metatable->free_node(node);
}

static inline void ast_traverse_print(struct ast *node, int indent) {
  if (node)
    node->metatable->traverse_print(node, indent);
}

static inline void ast_traverse_translate(struct ast *node,
                                          struct translate_context *context) {
  if (node)
    node->metatable->traverse_translate(node, context);
}

#define AST_DECLARE_TYPE_1(type, arg1)                                         \
  struct ast_##type {                                                          \
    struct ast base;                                                           \
    arg1;                                                                      \
  };                                                                           \
  struct ast *ast_new_##type(arg1);

#define AST_DECLARE_TYPE_2(type, arg1, arg2)                                   \
  struct ast_##type {                                                          \
    struct ast base;                                                           \
    arg1;                                                                      \
    arg2;                                                                      \
  };                                                                           \
  struct ast *ast_new_##type(arg1, arg2);

#define AST_DECLARE_TYPE_3(type, arg1, arg2, arg3)                             \
  struct ast_##type {                                                          \
    struct ast base;                                                           \
    arg1;                                                                      \
    arg2;                                                                      \
    arg3;                                                                      \
  };                                                                           \
  struct ast *ast_new_##type(arg1, arg2, arg3);

#define AST_CAST(ast, type) ((type *)((char *)ast - offsetof(type, base)))

AST_DECLARE_TYPE_2(global, struct ast *item, struct ast *next)
AST_DECLARE_TYPE_3(procedure, struct ast *header, struct ast *vars, struct ast *code)
AST_DECLARE_TYPE_2(proc_header, char *name, struct ast *args)
AST_DECLARE_TYPE_2(arg_list, char *name, struct ast *next)
AST_DECLARE_TYPE_2(var_list, struct ast *decl, struct ast *next)
AST_DECLARE_TYPE_2(decl_var, char *name, int size)
AST_DECLARE_TYPE_2(op_list, struct ast *op, struct ast *next)
AST_DECLARE_TYPE_2(proc_call, char *name, struct ast *push_list)
AST_DECLARE_TYPE_2(push_list, struct ast *expr, struct ast *next)
AST_DECLARE_TYPE_2(assign, struct ast *left, struct ast *right)
AST_DECLARE_TYPE_3(if, struct ast *cond, struct ast *if_true, struct ast *if_false)
AST_DECLARE_TYPE_2(while, struct ast *cond, struct ast *body)
AST_DECLARE_TYPE_3(binop, int code, struct ast *left, struct ast *right)
AST_DECLARE_TYPE_2(unop, int code, struct ast *arg)
AST_DECLARE_TYPE_1(constant, int value)
AST_DECLARE_TYPE_1(refname, char *name)

#endif
