#include "lib.h"

void __attribute__((section (".text.boot"))) _start(){
    int i = 5;
    int j = 7;
    char* str1 = "oui";
    char* str2 = "non";
    if (i < j) __printf(str1);
    else __printf(str1);
}
