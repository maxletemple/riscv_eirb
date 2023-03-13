#include "translator.h"
#include <iostream>
#include <fstream>

int main(int argc, char *argv[]) {

    string assem_file_name = std::string(argv[1]);
    string inst_file_name = std::string(argv[2]);

    translator *instance = new translator();
    instance -> instructionToBin(assem_file_name, "temp.txt");
    if (std::string(argv[3]) == "int") {
        instance->binToInt("temp.txt", inst_file_name);
    } else{
        instance->binToUart("temp.txt", inst_file_name);
    }
    return 0;
}