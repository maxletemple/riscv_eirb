#include "lib.h"

void __attribute__((section (".text.boot"))) _start(){
  int a = 4;
  int b = 12;
  char* str = "coucou_str";
  str[0] = '0';
  coucou();
}
