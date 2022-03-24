#include "ast.h"
#include "lex.yy.h"
#include "parser.tab.h"

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
    ast_traverse_translate(result, &context);
  }
  ast_free(result);
  return 0;
}
