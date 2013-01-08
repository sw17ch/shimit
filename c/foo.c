#include "foo.h"

void some_function(sometype_t t) {
  struct a_struct;
a_label:
  some_function(t);
}

void some_other_function(union a_union * u) {
}

int eek(void) {
  return 0;
}

void uses_struct(struct a_struct s) {
}

void uses_enum(enum an_enum e) {
  struct foo {
    int bar;
  };
}

int main(int argc, char * argv[]) { return 0; }
