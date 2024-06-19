#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void)
{
	// TODO: b)
    char *s = malloc(69);
    strcpy(s, "heard");
    reveal_passwd(s);
  // TODO: c)
    // pin > 19228
    strcpy(s, "yorkshire terrier");
    show_message(19228, s);
	return 0;
}
