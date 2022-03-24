#ifndef _AST_H_
#define _AST_H_

struct translate_context {
  int register_counter;
  int label_counter;
};

struct ast;
extern struct ast *result;

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

void yyerror(char const *s);

#endif
