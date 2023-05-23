#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "decoblock.h"
typedef struct instruction {
    char nom[50];
    char type[50];
    char autorisation[50];
}instruction;
void decoblock(char* nom_fichier) {
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
FILE* fichier2 = fopen("decoblock.vhd", "w");
char entity[10000] = "library IEEE;\n"
"use IEEE.STD_LOGIC_1164.ALL;\n"
"use IEEE.NUMERIC_STD.ALL;\n"
"\n"
"entity decoblock is\n"
"    Generic(Bit_Nber : integer := 32);\n"
"    Port(opcode : in std_logic_vector(6 downto 0);\n"
"         funct3 : in std_logic_vector(2 downto 0);\n"
"         funct7 : in std_logic_vector(6 downto 0);\n"
"         sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);\n"
"         --reg_file_write       : out STD_LOGIC;\n"
"         imm_type             : out STD_LOGIC_VECTOR (2 downto 0);\n"
"         sel_op2              : out STD_LOGIC;\n"
"         sel_result           : out STD_LOGIC_VECTOR (1 downto 0);\n"
"         --RW_UT_Data           : out STD_LOGIC;\n"
"         sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);\n"
"         sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0);\n"
"         Val_connect          : in STD_LOGIC;\n"
"         mem_rw_depth : out STD_LOGIC_vector(3 downto 0));\n"
"end decoblock;\n";
fprintf(fichier2, "%s", entity);
char architecture[10000] = "architecture Behavioral of decoblock is\n"
    "begin\n"
    "\n"
    "    process(opcode, funct3, funct7, Val_connect) is\n"
    "    begin\n"
    "        case opcode is\n";

fprintf(fichier2, "%s", architecture);
if (count_type_R != 0)
{
    fprintf(fichier2, "          when \"0110011\" => -- Op reg-reg\n"
    "            -- signaux communs a chaque instruction reg-reg\n"
    "            imm_type <= \"000\"; -- Type R\n"
    "            sel_op2 <= '0'; -- '00' si rs2, '01' si imm, \"10\" si auipc\n"
    "            sel_result <= \"00\";\n"
    "            sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n"
    "            sel_func_ALU_connect <= \"000\";\n"
    "            mem_rw_depth <= \"0000\";\n"
    "\n"
    "            -- calcul du signal pour chaque instruction\n"
    "            case funct3 is\n");
    for (int i = 0; i < indice; i++) {
    if ((strcmp(instructions[i].nom, "SUB")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "    when \"000\" =>\n"
                  "        if (funct7 = \"0100000\") then\n"
                  "            sel_func_ALU <= \"0010\"; -- sub\n");
    for (int j=0;j<indice;j++)
    {
        if ((strcmp(instructions[j].nom, "ADD")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    elsif (funct7 = \"0000000\") then\n"
                  "        sel_func_ALU <= \"0001\"; -- add\n");
        fprintf(fichier2, "    else\n"
                  "        sel_func_ALU <= \"0000\"; -- nop\n"
                  "    end if;\n");
    }
    if ((strcmp(instructions[j].nom, "ADD")==0) && (strcmp(instructions[j].autorisation, "NON") == 0))
    {
        fprintf(fichier2, "    else\n"
                  "        sel_func_ALU <= \"0000\"; -- nop\n"
                  "    end if;\n");
    }
    }

    }
    if ((strcmp(instructions[i].nom, "SUB")==0) && (strcmp(instructions[i].autorisation, "NON") == 0)){
            for (int j=0;j<indice;j++){

                if ((strcmp(instructions[j].nom, "ADD")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0))
                {
        fprintf(fichier2, "    when \"000\" =>\n"
                  "        if (funct7 = \"0000000\") then\n"
                  "            sel_func_ALU <= \"0001\"; -- add\n");
        fprintf(fichier2, "    else\n"
                  "        sel_func_ALU <= \"0000\"; -- nop\n"
                  "    end if;\n");

                }
            }
    }
    if ((strcmp(instructions[i].nom, "SLL")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "    when \"001\" =>\n       sel_func_ALU <= \"1000\"; -- sll\n");

    }
      if ((strcmp(instructions[i].nom, "SLT")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "    when \"010\" =>\n       sel_func_ALU <= \"0011\"; -- slt\n");
    }
      if ((strcmp(instructions[i].nom, "SLTU")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
       fprintf(fichier2, "     when \"011\" =>\n     sel_func_ALU <= \"0100\"; -- sltu\n");
    }
      if ((strcmp(instructions[i].nom, "XOR")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
        fprintf(fichier2, "    when \"100\" =>\n      sel_func_ALU <= \"0111\"; -- xor\n");
    }
      if ((strcmp(instructions[i].nom, "SRA")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
      {
          fprintf(fichier2, "    when \"101\" =>\n"
                  "        if (funct7 = \"0100000\") then\n"
                  "            sel_func_ALU <= \"1010\"; -- sra\n");
        for (int j=0;j<indice;j++){
        if ((strcmp(instructions[j].nom, "SRL")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0))
            {
                fprintf(fichier2, "        elsif (funct7 = \"0000000\") then\n"
                  "            sel_func_ALU <= \"1001\"; -- srl\n"
                  "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");

            }
        if ((strcmp(instructions[j].nom, "SRL")==0) && (strcmp(instructions[j].autorisation, "NON") == 0))
            {
                fprintf(fichier2, "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");

            }
        }

      }
  if ((strcmp(instructions[i].nom, "SRA")==0) && (strcmp(instructions[i].autorisation, "NON") == 0))
  {              for (int j=0;j<indice;j++){
        if ((strcmp(instructions[j].nom, "SRL")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0))
            {
                fprintf(fichier2,  "    when \"101\" =>\n"
                  "        if (funct7 = \"0000000\") then\n"
                  "            sel_func_ALU <= \"1001\"; -- srl\n"
                  "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");
            }
  }
  }
  if ((strcmp(instructions[i].nom, "OR")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "when \"110\" => sel_func_ALU <= \"0110\"; -- or\n");
    }
  if ((strcmp(instructions[i].nom, "AND")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
  {
     fprintf(fichier2, "when \"111\" => sel_func_ALU <= \"0101\"; -- and\n");
  }
    }
    fprintf(fichier2, "    when others => sel_func_ALU <= \"0000\";\n"
                  "end case;");
}
if (count_type_I != 0)
{
    fprintf(fichier2, "    when \"0010011\" => -- Op reg-imm\n"
                  "        -- signaux communs a chaque instruction reg-imm\n"
                  "        imm_type <= \"001\"; -- Type I\n"
                  "        sel_op2 <= '1';\n"
                  "        sel_result <= \"00\";\n"
                  "        sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon\n"
                  "        sel_func_ALU_connect <= \"000\";\n"
                  "        mem_rw_depth <= \"0000\";\n"
                  "\n"
                  "        -- signal a modifier pour chaque instruction\n"
                  "        case funct3 is\n");
    for (int i = 0; i < indice; i++) {
  if ((strcmp(instructions[i].nom, "ADDI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
      fprintf(fichier2, "    when \"000\" => -- addi\n"
                  "        sel_func_ALU <= \"0001\";\n");
    }
  if ((strcmp(instructions[i].nom, "SLTI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
      fprintf(fichier2, "    when \"010\" => -- slti\n"
                  "        sel_func_ALU <= \"0011\";\n");
    }
  if ((strcmp(instructions[i].nom, "SLTIU")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"011\" => -- sltiu\n"
                  "        sel_func_ALU <= \"0100\";\n");
    }
  if ((strcmp(instructions[i].nom, "ANDI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"111\" => -- andi\n"
                  "        sel_func_ALU <= \"0101\";\n");
    }
  if ((strcmp(instructions[i].nom, "ORI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"110\" => -- ori\n"
                  "        sel_func_ALU <= \"0110\";\n");
    }
  if ((strcmp(instructions[i].nom, "XORI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"100\" => -- xori\n"
                  "        sel_func_ALU <= \"0111\";\n");
    }
  if ((strcmp(instructions[i].nom, "SLLI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"001\" => -- slli\n"
                  "        sel_func_ALU <= \"1000\";\n");
    }
  if ((strcmp(instructions[i].nom, "SRLI")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0))
    {
     fprintf(fichier2, "    when \"101\" =>\n"
                  "        if (funct7 = \"0000000\") then -- srli\n"
                  "            sel_func_ALU <= \"1001\";\n");
                for (int j=0;j<indice;j++){
  if ((strcmp(instructions[j].nom, "SRAI")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0))
  {
      fprintf(fichier2, "        elsif (funct7 = \"0100000\") then -- srai\n"
                  "            sel_func_ALU <= \"1010\";\n"
                  "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");

  }

 if ((strcmp(instructions[j].nom, "SRAI")==0) && (strcmp(instructions[j].autorisation, "NON") == 0))
  {
    fprintf(fichier2, "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");
  }
    }
    }
  if ((strcmp(instructions[i].nom, "SRLI")==0) && (strcmp(instructions[i].autorisation, "NON") == 0))
    {
                 for (int j=0;j<indice;j++){
      if ((strcmp(instructions[j].nom, "SRAI")==0) && (strcmp(instructions[j].autorisation, "OUI") == 0))
      {
          fprintf(fichier2, "    when \"101\" =>\n"
                  "        if (funct7 = \"0100000\") then -- srli\n"
                  "            sel_func_ALU <= \"1010\";\n"
                  "        else\n"
                  "            sel_func_ALU <= \"0000\"; -- nop\n"
                  "        end if;\n");
      }
    }
    }
  }
  fprintf(fichier2,"    when others =>\n"
                  "        sel_func_ALU <= \"0000\";\n"
                  "    end case;\n");
}
if (count_type_L != 0)
{
  fprintf(fichier2,    "when \"0000011\" => -- Op load"
                  "        imm_type <= \"001\"; -- Type I\n"
                  "        sel_op2 <= '1';\n"
                  "        sel_result <= \"01\"; -- 00 pour l'ALU, 01 pour mémoire et 10 pour PC\n"
                  "        sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon\n"
                  "        sel_func_ALU_connect <= \"000\";\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"0000\";\n"
                  "        case funct3 is \n");

  for (int i = 0; i < indice; i++) {
      if ((strcmp(instructions[i].nom, "LB")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    when \"000\" =>\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"0001\";\n");
      }
       if ((strcmp(instructions[i].nom, "LH")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    when \"001\" =>\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"0011\";\n");
      }
    if ((strcmp(instructions[i].nom, "LW")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    when \"010\" =>\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"1111\";\n");
      }
    if ((strcmp(instructions[i].nom, "LBU")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    when \"100\" =>\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"0001\";\n");
      }
    if ((strcmp(instructions[i].nom, "LHU")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "    when \"101\" =>\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        mem_rw_depth <= \"0011\";\n");
      }
  }
  fprintf(fichier2, "    when others =>\n"
                  "        sel_func_ALU <= \"0000\";\n"
                  "        mem_rw_depth <= \"0000\";\n"
                  "end case;\n");
}
if (count_type_S != 0)
{
    fprintf(fichier2, "    when \"0100011\" =>\n"
                  "        imm_type <= \"010\"; -- Type S\n"
                  "        sel_op2 <= '1';\n"
                  "        sel_result <= \"01\"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC\n"
                  "        sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon\n"
                  "        sel_func_ALU_connect <= \"000\";\n"
                  "        sel_func_ALU <= \"0001\";\n"
                  "        case funct3 is\n");
  for (int i = 0; i < indice; i++) {
      if ((strcmp(instructions[i].nom, "SB")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
        fprintf(fichier2, "        when \"000\" => -- sb\n"
                  "            sel_func_ALU <= \"0001\";\n"
                  "            mem_rw_depth <= \"0001\"; -- 01\n");
      }
      if ((strcmp(instructions[i].nom, "SH")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
         fprintf(fichier2, "        when \"001\" => -- sh\n"
                  "            sel_func_ALU <= \"0001\";\n"
                  "            mem_rw_depth <= \"0011\"; -- 10\n");
      }
      if ((strcmp(instructions[i].nom, "SW")==0) && (strcmp(instructions[i].autorisation, "OUI") == 0)){
         fprintf(fichier2, "        when \"010\" => -- sw\n"
                  "            sel_func_ALU <= \"0001\";\n"
                  "            mem_rw_depth <= \"1111\"; -- 11\n");

      }
}
fprintf(fichier2, "    when others =>\n"
                  "        sel_func_ALU <= \"0000\";\n"
                  "        mem_rw_depth <= \"0001\";\n"
                  "    end case;\n");

}
if (count_type_B != 0)
{
    fprintf(fichier2, "        when \"1100011\" =>\n"
                  "            imm_type <= \"011\"; -- Type B\n"
                  "            sel_op2 <= '0';\n"
                  "            sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour mémoire et 10 pour PC\n"
                  "            sel_func_ALU <= \"0000\";\n"
                  "            mem_rw_depth <= \"0000\";\n"
                  "            case funct3 is");
  for (int i = 0; i < indice; i++)
    {
    if ((strcmp(instructions[i].nom, "BEQ") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"000\" => -- beq\n"
                  "            sel_func_ALU_connect <= \"001\";\n");
    }

    if ((strcmp(instructions[i].nom, "BNE") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"001\" => -- bne\n"
                  "            sel_func_ALU_connect <= \"010\";\n");
    }

    if ((strcmp(instructions[i].nom, "BLT") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"100\" => -- blt\n"
                  "            sel_func_ALU_connect <= \"011\";\n");
    }

    if ((strcmp(instructions[i].nom, "BGE") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"101\" => -- bge\n"
                  "            sel_func_ALU_connect <= \"100\";\n");
    }

    if ((strcmp(instructions[i].nom, "BLTU") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"110\" => -- bltu\n"
                  "            sel_func_ALU_connect <= \"101\";\n");
    }

    if ((strcmp(instructions[i].nom, "BGEU") == 0) && (strcmp(instructions[i].autorisation, "OUI") == 0)) {
        fprintf(fichier2, "        when \"111\" => -- bgeu\n"
                  "            sel_func_ALU_connect <= \"110\";\n");
    }


    }
fprintf(fichier2, "        when others =>\n"
                  "            sel_func_ALU_connect <= \"000\";\n"
                  "    end case;\n"
                  "\n"
                  "    -- branchement\n"
                  "    if (Val_connect = '1') then\n"
                  "        sel_PC_Mux <= \"01\"; -- 01 pour les branchements, 10 pour jal, 00 sinon\n"
                  "    else\n"
                  "        sel_PC_Mux <= \"00\"; -- on continue normalement\n"
                  "    end if;\n");

}
if (count_type_J != 0)
{
    fprintf(fichier2, "        when \"1101111\" => -- Op Jal\n"
                  "            imm_type <= \"101\"; -- Type J\n"
                  "            sel_op2 <= '0';\n"
                  "            sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC\n"
                  "            sel_PC_Mux <= \"01\"; -- 01 pour les branchementset jal, 10 pour mettre le pc a 0, 11 pour jalr, 00 sinon\n"
                  "            sel_func_ALU_connect <= \"000\";\n"
                  "            sel_func_ALU <= \"0000\";\n"
                  "            mem_rw_depth <= \"0000\";\n");

}
if (count_JALR != 0)
{
    fprintf(fichier2, "        when \"1100111\" => -- Op Jalr\n"
                  "            imm_type <= \"001\"; -- Type I\n"
                  "            sel_op2 <= '1';\n"
                  "            sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder\n"
                  "            sel_PC_Mux <= \"11\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n"
                  "            sel_func_ALU_connect <= \"000\";\n"
                  "            sel_func_ALU <= \"1100\";\n"
                  "            mem_rw_depth <= \"0000\";\n");

}
if (count_LUI != 0)
{
   fprintf(fichier2, "        when \"0110111\" => -- Op Lui\n"
                  "            imm_type <= \"100\"; -- Type U\n"
                  "            sel_op2 <= '1';\n"
                  "            sel_result <= \"00\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder\n"
                  "            sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n"
                  "            sel_func_ALU_connect <= \"000\";\n"
                  "            sel_func_ALU <= \"1011\";\n"
                  "            mem_rw_depth <= \"0000\";\n");
}
if (count_AUIPC != 0)
{
    fprintf(fichier2, "        when \"0010111\" => -- Op Auipc\n"
                  "            imm_type <= \"100\"; -- Type U\n"
                  "            sel_op2 <= '0';\n"
                  "            sel_result <= \"11\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder\n"
                  "            sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n"
                  "            sel_func_ALU_connect <= \"000\";\n"
                  "            sel_func_ALU <= \"1011\";\n"
                  "            mem_rw_depth <= \"0000\";\n");
}
for (int i=0;i<count_NEW;i++)
{
    char ligne[100];
    while (strcmp(ligne,"FIN")!=0)
    {
        printf("Ecrire les lignes VHDL qui permettent de modifier le Decoblock pour introduire cette nouvelle instruction\n");
         scanf("%s",ligne);
     if(strcmp(ligne,"FIN")!=0)
     {
        fprintf(fichier2,"%s\n", ligne);
     }
    }
}
fprintf(fichier2, "    when others =>\n"
                  "        imm_type <= \"000\";\n"
                  "        sel_op2 <= '0';\n"
                  "        sel_result <= \"00\";\n"
                  "        sel_PC_Mux <= \"00\";\n"
                  "        sel_func_ALU_connect <= \"000\";\n"
                  "        sel_func_ALU <= \"0000\";\n"
                  "        mem_rw_depth <= \"0000\";\n"
                  "    end case;\n"
                  "end process;\n"
                  "end Behavioral;\n");
fclose(fichier);
fclose(fichier2);
}
