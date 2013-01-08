#ifndef FOO_H
#define FOO_H

#include "bar.h"

struct a_struct { int x; };
enum an_enum { a, b, c };

void some_function(sometype_t t);
void some_other_function(union a_union * u);
int eek(void);
void uses_struct(struct a_struct s);
void uses_enum(enum an_enum e);

#endif /* FOO_H */
