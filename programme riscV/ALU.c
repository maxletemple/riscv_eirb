#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ALU.h"
typedef struct instruction {
    char nom[50];
    char type[50];
    char autorisation[50];
}instruction;
void ALU(char* nom_fichier) {
    FILE* fichier = fopen(nom_fichier, "r");
    if (fichier == NULL) {
        printf("Impossible d'ouvrir le fichier.\n");
    }
    instruction instructions[100];
    int indice=0;
       char ligne[100];
    while (fgets(ligne, sizeof(ligne), fichier)) {
        char nom[50];
        char type[50];
        char autorisation[50];
        sscanf(ligne, "%s %s %s", nom, type, autorisation);
        strcpy(instructions[indice].nom, nom);
        strcpy(instructions[indice].type, type);
        strcpy(instructions[indice].autorisation, autorisation);

        indice++;
    }
    for (int i = 0; i < indice; i++) {
        printf("Instruction %d:\n", i+1);
        printf("Nom : %s\n", instructions[i].nom);
        printf("Type : %s\n", instructions[i].type);
        printf("Autorisation : %s\n", instructions[i].autorisation);
        printf("---------------------\n");
    }
    int count_type_R = 0;
    int count_type_I = 0;
    int count_JALR = 0;
    int count_type_L = 0;
    int count_type_S = 0;
    int count_type_B = 0;
    int count_type_J = 0;
    int count_AUIPC = 0;
    int count_LUI = 0;
    int count_NEW=0;


for (int i = 0; i < indice; i++) {
    if ((strcmp(instructions[i].type, "R")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_R++;
    }
    if ((strcmp(instructions[i].type, "I") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_I++;
    }
    if ((strcmp(instructions[i].nom, "JALR") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_JALR++;
    }
    if ((strcmp(instructions[i].type, "L") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_L++;
    }
    if ((strcmp(instructions[i].type, "S") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_S++;
    }
    if ((strcmp(instructions[i].type, "B") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_B++;
    }
    if ((strcmp(instructions[i].type, "J") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_type_J++;
    }
    if ((strcmp(instructions[i].nom, "LUI") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_LUI++;
    }
    if ((strcmp(instructions[i].nom, "AUIPC") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_AUIPC++;
    }
    if ((strcmp(instructions[i].nom, "NEW") == 0)&& (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        count_NEW++;
    }
}
FILE* fichier2 = fopen("ALU.vhd", "w");

fprintf(fichier2, "library IEEE;\n"
                      "use IEEE.STD_LOGIC_1164.ALL;\n"
                      "use IEEE.NUMERIC_STD.ALL;\n"
                      "\n"
                      "entity ALU is\n"
                      "    Generic(\n"
                      "           Bit_Nber    : INTEGER := 32 -- word size\n"
                      "           );\n"
                      "    Port ( sel_func_ALU         : in STD_LOGIC_VECTOR (3 downto 0);\n"
                      "           sel_func_ALU_connect : in STD_LOGIC_VECTOR (2 downto 0);\n"
                      "           Operand1             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);\n"
                      "           Operand2             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);\n"
                      "           Result               : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);\n"
                      "           Val_connect          : out STD_LOGIC\n"
                      "          );\n"
                      "end ALU;\n"
                      "\n"
                      "architecture Behavioral of ALU is\n"
                      "\n"
                      "begin\n"
                      "\n"
                      "process(sel_func_ALU, sel_func_ALU_connect, Operand1, Operand2)\n"
                      "\n"
                      "variable index : integer range 0 to 31;\n"
                      "begin\n"
                    "case(sel_func_ALU) is\n");
for (int i = 0; i < indice; i++) {
    if ((strcmp(instructions[i].nom, "ADD")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "            when \"0001\" => -- add\n"
                  "                Result <= std_logic_vector(unsigned(Operand1) + unsigned(Operand2));\n"
                  "                Val_connect <= '0';\n");
    }
    if ((strcmp(instructions[i].nom, "SUB")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "            when \"0010\" => -- sub\n"
                  "                Result <= std_logic_vector(unsigned(Operand1) - unsigned(Operand2));\n"
                  "                Val_connect <= '0';\n");

    }
    if ((strcmp(instructions[i].nom, "SLLI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "                when \"1000\" => -- Decalage logique a gauche <<\n"
                  "                    case to_integer(unsigned(operand2)) is\n"
                  "                        when 0 =>\n"
                  "                            Result <= Operand1;\n"
                  "                        when 1 =>\n"
                  "                            Result <= Operand1(30 downto 0) & std_logic_vector(to_unsigned(0,1));\n"
                  "                        when 2 =>\n"
                  "                            Result <= Operand1(29 downto 0) & std_logic_vector(to_unsigned(0,2));\n"
                  "                        when 3 =>\n"
                  "                            Result <= Operand1(28 downto 0) & std_logic_vector(to_unsigned(0,3));\n"
                  "                        when 4 =>\n"
                  "                            Result <= Operand1(27 downto 0) & std_logic_vector(to_unsigned(0,4));\n"
                  "                        when 5 =>\n"
                  "                            Result <= Operand1(26 downto 0) & std_logic_vector(to_unsigned(0,5));\n"
                  "                        when 6 =>\n"
                  "                            Result <= Operand1(25 downto 0) & std_logic_vector(to_unsigned(0,6));\n"
                  "                        when 7 =>\n"
                  "                            Result <= Operand1(24 downto 0) & std_logic_vector(to_unsigned(0,7));\n"
                  "                        when 8 =>\n"
                  "                            Result <= Operand1(23 downto 0) & std_logic_vector(to_unsigned(0,8));\n"
                  "                        when 9 =>\n"
                  "                            Result <= Operand1(22 downto 0) & std_logic_vector(to_unsigned(0,9));\n"
                  "                        when 10 =>\n"
                  "                            Result <= Operand1(21 downto 0) & std_logic_vector(to_unsigned(0,10));\n"
                  "                        when 11 =>\n"
                  "                            Result <= Operand1(20 downto 0) & std_logic_vector(to_unsigned(0,11));\n"
                  "                        when 12 =>\n"
                  "                            Result <= Operand1(19 downto 0) & std_logic_vector(to_unsigned(0,12));\n"
                  "                        when 13 =>\n"
                  "                            Result <= Operand1(18 downto 0) & std_logic_vector(to_unsigned(0,13));\n"
                  "                        when 14 =>\n"
                  "                            Result <= Operand1(17 downto 0) & std_logic_vector(to_unsigned(0,14));\n"
                  "                        when 15 =>\n"
                  "                            Result <= Operand1(16 downto 0) & std_logic_vector(to_unsigned(0,15));\n"
                  "                        when 16 =>\n"
                  "                            Result <= Operand1(15 downto 0) & std_logic_vector(to_unsigned(0,16));\n"
                  "                        when 17 =>\n"
                  "                            Result <= Operand1(14 downto 0) & std_logic_vector(to_unsigned(0,17));\n"
                  "                        when 18 =>\n"
                  "                            Result <= Operand1(13 downto 0) & std_logic_vector(to_unsigned(0,18));\n"
                  "                        when 19 =>\n"
                  "                            Result <= Operand1(12 downto 0) & std_logic_vector(to_unsigned(0,19));\n"
                  "                        when 20 =>\n"
                  "                            Result <= Operand1(11 downto 0) & std_logic_vector(to_unsigned(0,20));\n"
                  "                        when 21 =>\n"
                  "                            Result <= Operand1(10 downto 0) & std_logic_vector(to_unsigned(0,21));\n"
                  "                        when 22 =>\n"
                  "                            Result <= Operand1(9 downto 0) & std_logic_vector(to_unsigned(0,22));\n"
                  "                        when 23 =>\n"
                  "                            Result <= Operand1(8 downto 0) & std_logic_vector(to_unsigned(0,23));\n"
                  "                        when 24 =>\n"
                  "                            Result <= Operand1(7 downto 0) & std_logic_vector(to_unsigned(0,24));\n"
                  "                        when 25 =>\n"
                  "                            Result <= Operand1(6 downto 0) & std_logic_vector(to_unsigned(0,25));\n"
                  "                        when 26 =>\n"
                  "                            Result <= Operand1(5 downto 0) & std_logic_vector(to_unsigned(0,26));\n"
                  "                        when 27 =>\n"
                  "                            Result <= Operand1(4 downto 0) & std_logic_vector(to_unsigned(0,27));\n"
                  "                        when 28 =>\n"
                  "                            Result <= Operand1(3 downto 0) & std_logic_vector(to_unsigned(0,28));\n"
                  "                        when 29 =>\n"
                  "                            Result <= Operand1(2 downto 0) & std_logic_vector(to_unsigned(0,29));\n"
                  "                        when 30 =>\n"
                  "                            Result <= Operand1(1 downto 0) & std_logic_vector(to_unsigned(0,30));\n"
                  "                        when 31 =>\n"
                  "                            Result <= Operand1(0) & std_logic_vector(to_unsigned(0,31));\n"
                  "                        when others =>\n"
                  "                            Result <= (others => '0');\n"
                  "                    end case;\n");

    }
    if ((strcmp(instructions[i].nom, "SRLI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
       fprintf(fichier2, "                        when \"1001\" => -- Décalage logique à droite >>u\n"
                  "                            case(to_integer(unsigned(operand2))) is\n"
                  "                                when 0 =>\n"
                  "                                    Result <= Operand1;\n"
                  "                                when 1 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,1)) & Operand1(31 downto 1);\n"
                  "                                when 2 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,2)) & Operand1(31 downto 2);\n"
                  "                                when 3 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,3)) & Operand1(31 downto 3);\n"
                  "                                when 4 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,4)) & Operand1(31 downto 4);\n"
                  "                                when 5 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,5)) & Operand1(31 downto 5);\n"
                  "                                when 6 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,6)) & Operand1(31 downto 6);\n"
                  "                                when 7 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,7)) & Operand1(31 downto 7);\n"
                  "                                when 8 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,8)) & Operand1(31 downto 8);\n"
                  "                                when 9 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,9)) & Operand1(31 downto 9);\n"
                  "                                when 10 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,10)) & Operand1(31 downto 10);\n"
                  "                                when 11 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,11)) & Operand1(31 downto 11);\n"
                  "                                when 12 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,12)) & Operand1(31 downto 12);\n"
                  "                                when 13 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,13)) & Operand1(31 downto 13);\n"
                  "                                when 14 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,14)) & Operand1(31 downto 14);\n"
                  "                                when 15 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,15)) & Operand1(31 downto 15);\n"
                  "                                when 16 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,16)) & Operand1(31 downto 16);\n"
                  "                                when 17 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,17)) & Operand1(31 downto 17);\n"
                  "                                when 18 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,18)) & Operand1(31 downto 18);\n"
                  "                                when 19 =>\n"
                  "                                     Result <= std_logic_vector(to_unsigned(0,19)) & Operand1(31 downto 19);\n"
                  "                                when 20 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,20)) & Operand1(31 downto 20);\n"
                  "                                when 21 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,21)) & Operand1(31 downto 21);\n"
                  "                                when 22 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,22)) & Operand1(31 downto 22);\n"
                  "                                when 23 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,23)) & Operand1(31 downto 23);\n"
                  "                                when 24 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,24)) & Operand1(31 downto 24);\n"
                  "                                when 25 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,25)) & Operand1(31 downto 25);\n"
                  "                                when 26 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,26)) & Operand1(31 downto 26);\n"
                  "                                when 27 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,27)) & Operand1(31 downto 27);\n"
                  "                                when 28 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,28)) & Operand1(31 downto 28);\n"
                  "                                when 29 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,29)) & Operand1(31 downto 29);\n"
                  "                                when 30 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,30)) & Operand1(31 downto 30);\n"
                  "                                when 31 =>\n"
                  "                                    Result <= std_logic_vector(to_unsigned(0,31)) & Operand1(31);\n"
                  "                                when others =>\n"
                  "                                    Result <= (others => '0');\n"
                  "                            end case;\n");

    }
    if ((strcmp(instructions[i].nom, "SRAI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
      fprintf(fichier2, "            case(to_integer(unsigned(Operand2))) is\n"
                  "                when 0 =>\n"
                  "                    Result <= Operand1;\n"
                  "                when 1 =>\n"
                  "                    Result(31) <= Operand1(31);\n"
                  "                    for i in 0 to 30 loop\n"
                  "                        Result(i) <= Operand1(1+i);\n"
                  "                    end loop;\n"
                  "                when 2 =>\n"
                  "                    Result(31 downto 30) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 29 loop\n"
                  "                        Result(i) <= Operand1(2+i);\n"
                  "                    end loop;\n"
                  "                when 3 =>\n"
                  "                    Result(31 downto 29)<= (others=>Operand1(31));\n"
                  "                    for i in 0 to 28 loop\n"
                  "                        Result(i) <= Operand1(3+i);\n"
                  "                    end loop;\n"
                  "                when 4 =>\n"
                  "                    Result(31 downto 28)<= (others=>Operand1(31));\n"
                  "                    for i in 0 to 27 loop\n"
                  "                        Result(i) <= Operand1(4+i);\n"
                  "                    end loop;\n"
                  "                when 5 =>\n"
                  "                    Result(31 downto 27)<= (others=>Operand1(31));\n"
                  "                    for i in 0 to 26 loop\n"
                  "                        Result(i) <= Operand1(5+i);\n"
                  "                    end loop;\n"
                  "                when 6 =>\n"
                  "                    Result(31 downto 26) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 25 loop\n"
                  "                        Result(i) <= Operand1(6+i);\n"
                  "                    end loop;\n"
                  "                when 7 =>\n"
                  "                    Result(31 downto 25) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 24 loop\n"
                  "                        Result(i) <= Operand1(7+i);\n"
                  "                    end loop;\n"
                  "                when 8 =>\n"
                  "                    Result(31 downto 24) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 23 loop\n"
                  "                        Result(i) <= Operand1(8+i);\n"
                  "                    end loop;\n"
                  "                when 9 =>\n"
                  "                    Result(31 downto 23) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 22 loop\n"
                  "                        Result(i) <= Operand1(9+i);\n"
                  "                    end loop;\n"
                  "                when 10 =>\n"
                  "                    Result(31 downto 22) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 21 loop\n"
                  "                        Result(i) <= Operand1(10+i);\n"
                  "                    end loop;\n"
                  "                when 11 =>\n"
                  "                    Result(31 downto 21)<= (others=>Operand1(31));\n"
                  "                    for i in 0 to 20 loop\n"
                  "                        Result(i) <= Operand1(11+i);\n"
                  "                    end loop;\n"
                  "                when 12 =>\n"
                  "                    Result(31 downto 20) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 19 loop\n"
                  "                        Result(i) <= Operand1(12+i);\n"
                  "                    end loop;\n"
                  "                when 13 =>\n"
                  "                    Result(31 downto 19) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 18 loop\n"
                  "                        Result(i) <= Operand1(13+i);\n"
                  "                    end loop;\n"
                  "                when 14 =>\n"
                  "                    Result(31 downto 18) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 17 loop\n"
                  "                        Result(i) <= Operand1(14+i);\n"
                  "                    end loop;\n"
                  "                when 15 =>\n"
                  "                    Result(31 downto 17) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 16 loop\n"
                  "                        Result(i) <= Operand1(15+i);\n"
                  "                    end loop;\n"
                  "                when 16 =>\n"
                  "                    Result(31 downto 16) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 15 loop\n"
                  "                        Result(i) <= Operand1(16+i);\n"
                  "                    end loop;\n"
                  "                when 17 =>\n"
                  "                    Result(31 downto 15) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 14 loop\n"
                  "                        Result(i) <= Operand1(17+i);\n"
                  "                    end loop;\n"
                  "                when 18 =>\n"
                  "                    Result(31 downto 14) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 13 loop\n"
                  "                        Result(i) <= Operand1(18+i);\n"
                  "                    end loop;\n"
                  "                when 19 =>\n"
                  "                    Result(31 downto 13) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 12 loop\n"
                  "                        Result(i) <= Operand1(19+i);\n"
                  "                    end loop;\n"
                  "                when 20 =>\n"
                  "                    Result(31 downto 12) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 11 loop\n"
                  "                        Result(i) <= Operand1(20+i);\n"
                  "                    end loop;\n"
                  "                when 21 =>\n"
                  "                    Result(31 downto 11) <= (others=>Operand1(31));\n"
                  "                    for i in 0 to 10 loop\n"
                  "                        Result(i) <= Operand1(21+i);\n"
                  "                    end loop;\n"
                  "when 22 =>\n"
                  "    Result(31 downto 10) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 9 loop\n"
                  "        Result(i) <= Operand1(22+i);\n"
                  "    end loop;\n"
                  "when 23 =>\n"
                  "    Result(31 downto 9) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 8 loop\n"
                  "        Result(i) <= Operand1(23+i);\n"
                  "    end loop;\n"
                  "when 24 =>\n"
                  "    Result(31 downto 8) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 7 loop\n"
                  "        Result(i) <= Operand1(24+i);\n"
                  "    end loop;\n"
                  "when 25 =>\n"
                  "    Result(31 downto 7) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 6 loop\n"
                  "        Result(i) <= Operand1(25+i);\n"
                  "    end loop;\n"
                  "when 26 =>\n"
                  "    Result(31 downto 6) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 5 loop\n"
                  "        Result(i) <= Operand1(26+i);\n"
                  "    end loop;\n"
                  "when 27 =>\n"
                  "    Result(31 downto 5) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 4 loop\n"
                  "        Result(i) <= Operand1(27+i);\n"
                  "    end loop;\n"
                  "when 28 =>\n"
                  "    Result(31 downto 4) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 3 loop\n"
                  "        Result(i) <= Operand1(28+i);\n"
                  "    end loop;\n"
                  "when 29 =>\n"
                  "    Result(31 downto 3) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 2 loop\n"
                  "        Result(i) <= Operand1(29+i);\n"
                  "    end loop;\n"
                  "when 30 =>\n"
                  "    Result(31 downto 2) <= (others=>Operand1(31));\n"
                  "    for i in 0 to 1 loop\n"
                  "        Result(i) <= Operand1(30+i);\n"
                  "    end loop;\n"
                  "when others =>\n"
                  "    Result <= (others=>Operand1(31));\n"
                  "end case;\n");
          fprintf(fichier2, "                Val_connect <= '0';\n");
    }
    if ((strcmp(instructions[i].nom, "XOR")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "        when \"0111\" => -- xor\n"
                   "            Result <= Operand1 xor Operand2;\n"
                   "            val_connect <= '0';\n");

    }
    if ((strcmp(instructions[i].nom, "OR")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "        when \"0110\" => -- or\n"
                   "            Result <= Operand1 or Operand2;\n"
                   "            val_connect <= '0';\n");

    }
if ((strcmp(instructions[i].nom, "AND") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
    fprintf(fichier2, "        when \"0101\" => -- and\n"
               "            Result <= Operand1 and Operand2;\n"
               "            val_connect <= '0';\n");
}

if ((strcmp(instructions[i].nom, "SLT") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
    fprintf(fichier2, "        when \"0011\" => -- slt = set less than\n"
               "            if (signed(Operand1) < signed(Operand2)) then\n"
               "                Result <= std_logic_vector(to_unsigned(1, Bit_Nber));\n"
               "            else\n"
               "                Result <= (others => '0');\n"
               "            end if;\n"
               "            val_connect <= '0';\n");
}

if ((strcmp(instructions[i].nom, "SLTU") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
    fprintf(fichier2, "        when \"0100\" => -- sltu = set less than unsigned\n"
               "            if (unsigned(Operand1) < unsigned(Operand2)) then\n"
               "                Result <= std_logic_vector(to_unsigned(1, Bit_Nber));\n"
               "            else\n"
               "                Result <= (others => '0');\n"
               "            end if;\n"
               "            val_connect <= '0';\n");
}

if ((strcmp(instructions[i].nom, "LUI") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
    fprintf(fichier2, "        when \"1011\" => -- lui = load immediate\n"
               "            Result <= Operand1(19 downto 0) & std_logic_vector(to_unsigned(0, 12));\n"
               "            val_connect <= '0';\n");
}
if ((strcmp(instructions[i].nom, "JALR") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "when \"1100\" =>\n"
               "Result <= std_logic_vector(unsigned(Operand1) + unsigned(Operand2)) and std_logic_vector(to_signed(-2,Bit_Nber));\n"
               "val_connect <= '0';\n");
}

}
if(count_type_B!=0){
fprintf(fichier2, "        when \"0000\" => -- a<b?1:0 signed\n"
               "            case(sel_func_ALU_connect) is\n");

    for (int i = 0; i < indice; i++)
    {
        if ((strcmp(instructions[i].nom, "BEQ") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"001\" => -- beq = branch equal\n"
               "                if(unsigned(Operand1) = unsigned(Operand2)) then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}
        if ((strcmp(instructions[i].nom, "BNE") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"010\" => -- bne = branch not equal\n"
               "                if(unsigned(Operand1) /= unsigned(Operand2))then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}

if ((strcmp(instructions[i].nom, "BLT") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"011\" => -- blt = branch less than signed\n"
               "                if(signed(Operand1) < signed(Operand2))then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}

if ((strcmp(instructions[i].nom, "BGE") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"100\" => -- bge = branch greater or equal signed\n"
               "                if(signed(Operand1) >= signed(Operand2))then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}

if ((strcmp(instructions[i].nom, "BLTU") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"101\" => -- bltu = branch less than unsigned\n"
               "                if(unsigned(Operand1) < unsigned(Operand2))then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}
if ((strcmp(instructions[i].nom, "BGEU") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
{
    fprintf(fichier2, "            when \"110\" => -- bgeu = branch greater or equal unsigned\n"
               "                if(unsigned(Operand1) >= unsigned(Operand2))then\n"
               "                    val_connect <= '1';\n"
               "                else\n"
               "                    val_connect <= '0';\n"
               "                end if;");
}
    }

 fprintf(fichier2, "            when others =>\n"
               "                Result <= (others => '0');\n"
               "            end case;\n"
               "            Result <= (others => '0');\n");


}

for (int i=0;i<count_NEW;i++)
{
    char ligne[100];
    while (strcmp(ligne,"FIN")!=0)
    {
        printf("Ecrire les lignes VHDL qui permettent de modifier l'ALU pour introduire cette nouvelle instruction\n");
         scanf("%s",ligne);
     if(strcmp(ligne,"FIN")!=0)
     {
        fprintf(fichier2,"%s\n", ligne);
     }
    }
}
fprintf(fichier2, "        when others => "
               "            Result <= (others => '0');\n"
               "            val_connect <= '0';\n"
               "    end case;\n"
               "end process;\n"
               "end Behavioral;\n");

fclose(fichier);
fclose(fichier2);
    }


