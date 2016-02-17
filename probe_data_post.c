#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int c, char **args)
{
  execvp("post_mac_probe", NULL);
  return 0;
}

