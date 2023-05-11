#include "lib.h"

void __printf(char* str){
    unsigned short current_size;
    asm("li t0,510;"
        "lw %0,0(t0);"
        : "=r"(current_size));
    
    unsigned short currentPtr = 512 + current_size;
    for (int i = 0; i < sizeof(str); i++){
        asm("sb %0,0(%1)"
            :
            :"r"(str[i]), "r"(currentPtr));
        currentPtr++;
    }
}

char __get8b (int adr){
    char ret;
    asm("lb %0,0(%1)"
    :
    :"r"(ret), "r"(adr));
    return ret;
}

short __get16b (int adr){
    short ret;
    asm("lh %0,0(%1)"
    :
    :"r"(ret), "r"(adr));
    return ret;
}

int __get32b (int adr){
    int ret;
    asm("lw %0,0(%1)"
    :
    :"r"(ret), "r"(adr));
    return ret;
}