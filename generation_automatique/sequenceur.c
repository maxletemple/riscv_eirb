#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sequenceur.h"
typedef struct instruction {
    char nom[50];
    char type[50];
    char autorisation[50];
}instruction;
void sequenceur(char* nom_fichier) {
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
    FILE* fichier2 = fopen("sequenceur.vhd", "w");
    char entity[10000]="library IEEE;\n"
"use IEEE.STD_LOGIC_1164.ALL;\n"
"use IEEE.NUMERIC_STD.ALL;\n"
"\n"
"entity sequenceur is\n"
"   Generic(\n"
"           Bit_Nber             : integer := 32\n"
"           );\n"
"    Port ( Clk                  : in STD_LOGIC;\n"
"           Reset                : in STD_LOGIC;\n"
"           CE                   : in STD_LOGIC;\n"
"           Val_Inst             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);\n"
"          \n"
"           Ena_Mem_Inst         : out STD_LOGIC;\n"
"           Ena_Mem_Data         : out STD_LOGIC;\n"
"           RW_Mem_Data          : out STD_LOGIC_VECTOR (3 downto 0);\n"
"          \n"
"           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);\n"
"           reg_file_write       : out STD_LOGIC;\n"
"           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);\n"
"           sel_op2              : out STD_LOGIC;\n"
"           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);\n"
"           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);\n"
"           Val_connect          : in STD_LOGIC;\n"
"           boot                 : in std_logic;\n"
"           init_counter         : out STD_LOGIC;\n"
"           load_plus4           : out std_logic;\n"
"           sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0)\n"
"           );\n"
"end sequenceur;\n";
fprintf(fichier2,"%s",entity);
char architecture[10000] = "architecture Behavioral of sequenceur is\n"
    "    type sortie1 is ARRAY(0 to 14) of std_logic;\n"
    "    signal sortie_1: sortie1:=('0','1','0','0','0','0','0','0','0','0','0','0','0','0','0');\n"
    "\n"
    "    type sortie2 is ARRAY(0 to 14) of std_logic;\n"
    "    signal sortie_2: sortie2:=('0','0','0','0','0','1','0','0','0','0','0','0','1','1','0');\n"
    "\n"
    "    type sortie3 is ARRAY(0 to 14) of std_logic_vector(3 downto 0);\n"
    "    signal sortie_3: sortie3:=(\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\",\"0000\");\n"
    "\n"
    "    type sortie4 is ARRAY(0 to 14) of std_logic;\n"
    "    signal sortie_4: sortie4:=('0','0','0','1','1','0','0','1','1','1','1','0','1','0','0');\n"
    "\n"
    "    type sortie5 is ARRAY(0 to 14) of std_logic;\n"
    "    signal sortie_5: sortie5:=('0','0','0','1','1','0','1','0','0','0','0','0','1','1','1');\n"
    "\n"
    "    type sortie6 is ARRAY(0 to 14) of std_logic;\n"
    "    signal sortie_6: sortie6:=('0','0','0','1','1','0','1','1','1','1','1','1','1','1','0');\n";

fprintf(fichier2,"%s",architecture);
char component[10000] = "component decoblock is\n"
    "    Generic(Bit_Nber                 : integer := 32);\n"
    "    Port(opcode                  : in std_logic_vector(6 downto 0);\n"
    "         funct3                  : in std_logic_vector(2 downto 0);\n"
    "         funct7                  : in std_logic_vector(6 downto 0);\n"
    "         sel_func_ALU            : out STD_LOGIC_VECTOR (3 downto 0);\n"
    "         imm_type                : out STD_LOGIC_VECTOR (2 downto 0);\n"
    "         sel_op2                 : out STD_LOGIC;\n"
    "         sel_result              : out STD_LOGIC_VECTOR (1 downto 0);\n"
    "         sel_func_ALU_connect    : out STD_LOGIC_VECTOR (2 downto 0);\n"
    "         sel_PC_Mux              : out STD_LOGIC_VECTOR (1 downto 0);\n"
    "         Val_connect             : in STD_LOGIC;\n"
    "         mem_rw_depth            : out std_logic_vector(3 downto 0));\n"
    "end component;\n\n";
fprintf(fichier2,"%s",component);
char signaux[10000] = "signal opcode            : std_logic_vector(6 downto 0);\n"
    "signal funct3            : std_logic_vector(2 downto 0);\n"
    "signal funct7            : std_logic_vector(6 downto 0);\n"
    "signal s_mem_rw_depth    : std_logic_vector(3 downto 0);\n\n"
    "signal PC : STD_LOGIC_VECTOR (4 downto 0) :=\"00000\";\n"
    "signal PC_futur : STD_LOGIC_VECTOR (4 downto 0) :=\"00000\";\n\n";
fprintf(fichier2,"%s",signaux);
char portmap[10000]= "begin\n\n"
    "decode0 : decoblock\n"
    "    generic map(Bit_Nber => 32)\n"
    "    port map(opcode => opcode,\n"
    "             funct3 => funct3,\n"
    "             funct7 => funct7,\n"
    "             sel_func_ALU => sel_func_ALU,\n"
    "             imm_type => imm_type,\n"
    "             sel_op2 => sel_op2,\n"
    "             sel_result => sel_result,\n"
    "             sel_func_ALU_connect => sel_func_ALU_connect,\n"
    "             sel_PC_Mux => sel_PC_Mux,\n"
    "             Val_connect => Val_connect,\n"
    "             mem_rw_depth => s_mem_rw_depth);\n\n"
    "funct3 <= Val_Inst(14 downto 12);\n"
    "funct7 <= Val_Inst(31 downto 25);\n";
fprintf(fichier2,"%s",portmap);
char process1[10000] = "process(clk, reset, ce, boot)\n"
    "begin\n"
    "  if(reset='1') then\n"
    "    PC <= \"00000\";\n"
    "  elsif (ce='0') then\n"
    "    PC <= \"00000\";\n"
    "  elsif (boot='1') then\n"
    "    PC <= \"00000\";\n"
    "  elsif rising_edge(clk) then\n"
    "    PC <= PC_futur;\n"
    "  end if;\n"
    "end process;\n";
fprintf(fichier2,"%s",process1);
char process2[10000] = "process(PC, opcode)\n"
    "begin\n"
    "  case PC is\n"
    "    when \"00000\"=> PC_futur <= \"00001\";\n"
    "    when \"00001\" => PC_futur <= \"00010\";\n"
    "    when \"00010\" => ";
fprintf(fichier2,"%s",process2);
if (count_type_R!=0)
{
   fprintf(fichier2, "          if(opcode = \"0110011\") then PC_futur <= \"00011\";\n");
}
if (count_type_I!=0)
{

    fprintf(fichier2,"          elsif(opcode=\"0010011\") then PC_futur<=\"00100\";\n");


}
if (count_type_L!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"0000011\")then PC_futur<=\"00101\";\n");

}
if (count_type_S!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"0100011\")then PC_futur<=\"00101\";\n");

}
if (count_type_B!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"1100011\")then PC_futur<=\"00110\";\n");

}
if (count_type_J!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"1101111\")then PC_futur<=\"00111\";\n");

}
if (count_JALR!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"1100111\")then PC_futur<=\"01000\";\n");

}
if (count_LUI!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"0110111\")then PC_futur<=\"01001\";\n");

}
if (count_AUIPC!=0)
{
    fprintf(fichier2,"          elsif(opcode=\"0010111\")then PC_futur<=\"01010\";\n");

}

for (int i=0;i<count_NEW;i++)
{
    char ligne[100];
    while (strcmp(ligne,"FIN")!=0)
    {
            printf("Pouvez vous faire entrer la ligne de code correspondants au passage de l'etat decode a ce nouveau etat, pensez a associer a ce nouveaux etat une adresse libre et associer a cette nouvelle instruction un opcode qui n'est pas utilise\n");
            scanf("%s",ligne);
     if(strcmp(ligne,"FIN")!=0)
     {
        fprintf(fichier2,"%s", ligne);
     }

    }
}
fprintf(fichier2, "          else PC_futur <= \"01011\";\n          end if;\n");
if ((count_type_L!=0) || (count_type_S!=0))
{
    fprintf(fichier2,"      when\"00101\" =>");
    if (count_type_L!=0)
    {
            fprintf(fichier2,"             if(opcode=\"0000011\") then PC_futur<=\"01100\";\n");
    }
    if(count_type_S!=0)
    {

            fprintf(fichier2,"               elsif(opcode=\"0100011\") then PC_futur<=\"01100\";\n");
    }
 fprintf(fichier2,"          else PC_futur<=\"01011\";\n         end if;");

}
if(count_type_R!=0)
{
            fprintf(fichier2,"       when \"00011\"  =>\n             PC_futur<=\"00001\";");
}
if(count_type_I!=0)
{
            fprintf(fichier2,"       when \"00100\"  =>\n             PC_futur<=\"00001\";");
}
if(count_type_L!=0)
{
            fprintf(fichier2,"       when \"01100\"  =>\n             PC_futur<=\"00010\";");
}
if(count_type_S!=0)
{
            fprintf(fichier2,"       when \"01101\"  =>\n             PC_futur<=\"00001\";");
}
if(count_type_B!=0)
{
            fprintf(fichier2,"       when \"00110\"  =>\n             PC_futur<=\"00001\";");
}
if(count_type_J!=0)
{
            fprintf(fichier2,"       when \"00111\"  =>\n             PC_futur<=\"01110\";");
}
if(count_type_J!=0)
{
            fprintf(fichier2,"       when \"01110\"  =>\n             PC_futur<=\"00001\";");
}
if(count_JALR!=0)
{
            fprintf(fichier2,"       when \"01000\"  =>\n             PC_futur<=\"00001\";");
}
if(count_LUI!=0)
{
            fprintf(fichier2,"       when \"01001\"  =>\n             PC_futur<=\"00001\";");
}
if(count_AUIPC!=0)
{
            fprintf(fichier2,"       when \"01010\"  =>\n             PC_futur<=\"00001\";");
}

for (int i=0;i<count_NEW;i++)
{
    char ligne[100];
    while (strcmp(ligne,"FIN")!=0)
    {
        printf("Pouvez vous faire entrer les lignes de code correspondants au passage de ce nouveau etat aux autres etats\n");
         scanf("%s",ligne);
     if(strcmp(ligne,"FIN")!=0)
     {
        fprintf(fichier2,"%s", ligne);
     }
    }
}
fprintf(fichier2,"              when \"01011\"  =>\n                   PC_futur<=\"00001\";\n             when others => null;\n  end case;\n  end process;");
fprintf(fichier2,"process(PC, Val_Inst, s_mem_rw_depth)\nbegin\nCASE pc IS");
char sorties[1000] = "  when \"00000\" =>\n"
                    "    Ena_Mem_INST <= sortie_1(0);\n"
                    "    Ena_Mem_DATA <= sortie_2(0);\n"
                    "    rw_mem_data <= \"0000\";\n"
                    "    reg_file_write <= sortie_4(0);\n"
                    "    init_counter <= sortie_5(0);\n"
                    "    load_plus4 <= sortie_6(0);\n"
                    "    opcode <= Val_Inst(6 downto 0);\n"
                    "  when \"00001\" =>\n"
                    "    Ena_Mem_INST <= sortie_1(1);\n"
                    "    Ena_Mem_DATA <= sortie_2(1);\n"
                    "    rw_mem_data <= \"0000\";\n"
                    "    reg_file_write <= sortie_4(1);\n"
                    "    init_counter <= sortie_5(1);\n"
                    "    load_plus4 <= sortie_6(1);\n"
                    "    opcode <= Val_Inst(6 downto 0);\n"
                    "  when \"00010\" =>\n"
                    "    Ena_Mem_INST <= sortie_1(2);\n"
                    "    Ena_Mem_DATA <= sortie_2(2);\n"
                    "    rw_mem_data <= \"0000\";\n"
                    "    reg_file_write <= sortie_4(2);\n"
                    "    init_counter <= sortie_5(2);\n"
                    "    load_plus4 <= sortie_6(2);\n"
                    "    opcode <= Val_Inst(6 downto 0);\n";
fprintf(fichier2,"%s",sorties);
char sortie3[1000] = "when \"00011\" => \n"
                         "  Ena_Mem_INST<=sortie_1(3);\n"
                         "  Ena_Mem_DATA<=sortie_2(3);\n"
                         "  rw_mem_data<=\"0000\";\n"
                         "  reg_file_write<=sortie_4(3);\n"
                         "  init_counter<=sortie_5(3);\n"
                         "  load_plus4<=sortie_6(3);\n"
                         "  opcode<=Val_Inst(6 downto 0);\n";
char sortie4[1000] = "when \"00100\" => \n"
                         "  Ena_Mem_INST<=sortie_1(4);\n"
                         "  Ena_Mem_DATA<=sortie_2(4);\n"
                         "  rw_mem_data<=\"0000\";\n"
                         "  reg_file_write<=sortie_4(4);\n"
                         "  init_counter<=sortie_5(4);\n"
                         "  load_plus4<=sortie_6(4);\n"
                         "  opcode<=Val_Inst(6 downto 0);\n";
char sortie5[1000] = "when \"00101\" => \n"
                     "  Ena_Mem_INST<=sortie_1(5);\n"
                     "  Ena_Mem_DATA<=sortie_2(5);\n"
                     "  rw_mem_data<=s_mem_rw_depth;\n"
                     "  reg_file_write<=sortie_4(5);\n"
                     "  init_counter<=sortie_5(5);\n"
                     "  load_plus4<=sortie_6(5);\n"
                     "  opcode<=Val_Inst(6 downto 0);\n";

char sortie6[1000] = "when \"00110\" => \n"
                     "  Ena_Mem_INST<=sortie_1(6);\n"
                     "  Ena_Mem_DATA<=sortie_2(6);\n"
                     "  rw_mem_data<=\"0000\";\n"
                     "  reg_file_write<=sortie_4(6);\n"
                     "  init_counter<=sortie_5(6);\n"
                     "  load_plus4<=sortie_6(6);\n"
                     "  opcode<=Val_Inst(6 downto 0);\n";

char sortie7[1000] = "when \"00111\" => \n"
                     "  Ena_Mem_INST<=sortie_1(7);\n"
                     "  Ena_Mem_DATA<=sortie_2(7);\n"
                     "  rw_mem_data<=\"0000\";\n"
                     "  reg_file_write<=sortie_4(7);\n"
                     "  init_counter<=sortie_5(7);\n"
                     "  load_plus4<=sortie_6(7);\n"
                     "  opcode<=Val_Inst(6 downto 0);\n";

char sortie8[1000] = "when \"01000\" => \n"
                     "  Ena_Mem_INST<=sortie_1(8);\n"
                     "  Ena_Mem_DATA<=sortie_2(8);\n"
                     "  rw_mem_data<=\"0000\";\n"
                     "  reg_file_write<=sortie_4(8);\n"
                     "  init_counter<=sortie_5(8);\n"
                     "  load_plus4<=sortie_6(8);\n"
                     "  opcode<=Val_Inst(6 downto 0);\n";

char sortie9[1000] = "when \"01001\" => \n"
                     "  Ena_Mem_INST<=sortie_1(9);\n"
                     "  Ena_Mem_DATA<=sortie_2(9);\n"
                     "  rw_mem_data<=\"0000\";\n"
                     "  reg_file_write<=sortie_4(9);\n"
                     "  init_counter<=sortie_5(9);\n"
                     "  load_plus4<=sortie_6(9);\n"
                     "  opcode<=Val_Inst(6 downto 0);\n";
char sortie10[1000] = "when \"01010\" => \n"
                      "  Ena_Mem_INST<=sortie_1(10);\n"
                      "  Ena_Mem_DATA<=sortie_2(10);\n"
                      "  rw_mem_data<=\"0000\";\n"
                      "  reg_file_write<=sortie_4(10);\n"
                      "  init_counter<=sortie_5(10);\n"
                      "  load_plus4<=sortie_6(10);\n"
                      "  opcode<=Val_Inst(6 downto 0);\n";

char sortie11[1000] = "when \"01011\" => \n"
                      "  Ena_Mem_INST<=sortie_1(11);\n"
                      "  Ena_Mem_DATA<=sortie_2(11);\n"
                      "  rw_mem_data<=\"0000\";\n"
                      "  reg_file_write<=sortie_4(11);\n"
                      "  init_counter<=sortie_5(11);\n"
                      "  load_plus4<=sortie_6(11);\n"
                      "  opcode<=Val_Inst(6 downto 0);\n";

char sortie12[1000] = "when \"01100\" => \n"
                      "  Ena_Mem_INST<=sortie_1(12);\n"
                      "  Ena_Mem_DATA<=sortie_2(12);\n"
                      "  rw_mem_data<=s_mem_rw_depth;\n"
                      "  reg_file_write<=sortie_4(12);\n"
                      "  init_counter<=sortie_5(12);\n"
                      "  load_plus4<=sortie_6(12);\n"
                      "  opcode<=Val_Inst(6 downto 0);\n";

char sortie13[1000] = "when \"01101\" => \n"
                      "  Ena_Mem_INST<=sortie_1(13);\n"
                      "  Ena_Mem_DATA<=sortie_2(13);\n"
                      "  rw_mem_data<=s_mem_rw_depth;\n"
                      "  reg_file_write<=sortie_4(13);\n"
                      "  init_counter<=sortie_5(13);\n"
                      "  load_plus4<=sortie_6(13);\n"
                      "  opcode<=Val_Inst(6 downto 0);\n";

char sortie14[1000] = "when \"01110\" => \n"
                      "  Ena_Mem_INST<=sortie_1(14);\n"
                      "  Ena_Mem_DATA<=sortie_2(14);\n"
                      "  rw_mem_data<=\"0000\";\n"
                      "  reg_file_write<=sortie_4(14);\n"
                      "  init_counter<=sortie_5(14);\n"
                      "  load_plus4<=sortie_6(14);\n"
                      "  opcode<=Val_Inst(6 downto 0);\n";
if (count_type_R!=0)
{
  fprintf(fichier2,"%s",sortie3);
}
if (count_type_I!=0)
{
  fprintf(fichier2,"%s",sortie4);
}
if ((count_type_L!=0)||(count_type_S!=0))
{
  fprintf(fichier2,"%s",sortie5);
}
if (count_type_L!=0)
{
  fprintf(fichier2,"%s",sortie6);
}
if (count_type_S!=0)
{
  fprintf(fichier2,"%s",sortie7);
}
if (count_type_B!=0)
{
  fprintf(fichier2,"%s",sortie8);
}
if (count_type_J!=0)
{
  fprintf(fichier2,"%s",sortie9);
}
if (count_type_J!=0)
{
  fprintf(fichier2,"%s",sortie10);
}
if (count_JALR!=0)
{
  fprintf(fichier2,"%s",sortie11);
}
if (count_LUI!=0)
{
  fprintf(fichier2,"%s",sortie12);
}
if (count_AUIPC!=0)
{
  fprintf(fichier2,"%s",sortie13);
}
for (int i=0;i<count_NEW;i++)
{
    char etat[500];
    char ena_Mem_Inst[500];
    char ena_Mem_Data[500];
    char rw_Mem_Data[500] ;
    char reg_File_Write[500];
    char init_Counter[500];
    char load_Plus4[500];
    char opcode[500] ;
    printf("Entrez l'adresse de l'etat actuel!");
    scanf("%s",ena_Mem_Inst);
    printf("Entrez la valeur de la sortie ena_Mem_Ins!");
    scanf("%s",ena_Mem_Inst);
    printf("Entrez la valeur de la sortie ena_Mem_Data!");
    scanf("%s",ena_Mem_Data);
    printf("Entrez la valeur de la sortie rw_Mem_Data!");
    scanf("%s",rw_Mem_Data);
    printf("Entrez la valeur de la sortie reg_File_Write!");
    scanf("%s",reg_File_Write);
    printf("Entrez la valeur de la sortie init_counter!");
    scanf("%s",init_Counter);
    printf("Entrez la valeur de la sortie load_Plus4!");
    scanf("%s",load_Plus4);
    printf("Entrez la valeur de la sortie opcode!");
    scanf("%s",opcode);
  fprintf(fichier2,"when %s => \n"
                      "  Ena_Mem_INST<=%s;\n"
                      "  Ena_Mem_DATA<=%s);\n"
                      "  rw_mem_data<=%s;\n"
                      "  reg_file_write<=%s;\n"
                      "  init_counter<=%s;\n"
                      "  load_plus4<=%s;\n"
                      "  opcode<=%s;\n",etat,ena_Mem_Inst,ena_Mem_Data,rw_Mem_Data,reg_File_Write,init_Counter,load_Plus4,opcode);
}
fprintf(fichier2,"%s",sortie14);
char fin[100] = "when others => null;\n"
                      "end case;\n"
                      "end process;\n"
                      "end behavioral;";
fprintf(fichier2,"%s",fin);
fclose(fichier);
fclose(fichier2);
}

