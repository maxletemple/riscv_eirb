#include <stdlib.h>
#include <stdio.h>

//------------------------CALCUL DES SORTIEs-----------------

int main()
{
  printf(" Vous allez generer le code du decoblock  adapte aux types d'instructions \n");

    FILE * fichier = NULL ;
    fichier = fopen ( " deco.txt" , "w");
    if ( fichier != NULL)
    {
      fputs("library ieee;\n",fichier);
      fputs("use ieee.std_logic_1164.all;\n",fichier);
      fputs("\n",fichier);
      fputs("entity decoblock is \n",fichier);
      fputs(" Generic(Bit_Nber : integer := 32); \n",fichier);
      fputs("Port(opcode : in std_logic_vector(6 downto 0); \n",fichier);
      fputs(" funct3 : in std_logic_vector(2 downto 0); \n",fichier);
      fputs("funct7 : in std_logic_vector(6 downto 0);",fichier);
      fputs("sel_func_ALU  : out STD_LOGIC_VECTOR (3 downto 0); \n",fichier);
      fputs("imm_type : out STD_LOGIC_VECTOR (2 downto 0); \n",fichier);
      fputs(" sel_op2 : out STD_LOGIC; \n",fichier);
      fputs(" sel_result   : out STD_LOGIC_VECTOR (1 downto 0);" ,fichier);
      fputs("sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0); \n",fichier);
      fputs("sel_PC_Mux  : out STD_LOGIC_VECTOR (1 downto 0); \n",fichier);
      fputs("Val_connect  : in STD_LOGIC; \n",fichier);
      fputs(" mem_rw_depth : out STD_LOGIC_vector(3 downto 0)); \n",fichier);
      fputs("end decoblock; \n",fichier);
      fputs("\n",fichier);
      fputs("architecture Behavioral of decoblock is \n",fichier);
      fputs("begin \n",fichier);
      fputs("process(opcode, funct3, funct7, Val_connect) \n",fichier);
      fputs("begin \n",fichier);
      fputs("  case opcode is \n",fichier);
      fputs(" \n",fichier);
      printf("1=oui , 0= non \n");
      printf("est-ce que le processeur contient des op de type reg-reg ? \n ");
      int reponse;
      scanf("%d",&reponse);
      if (reponse == 1)
      {
        fputs("when \"0110011\" => \n",fichier);
        fputs("   imm_type <= \"000\";  \n",fichier);
        fputs("sel_op2 <= '0'; -- '00' si rs2, '01' si imm, \"10\" si auipc \n",fichier);
        fputs("sel_result <= \"00\"; \n",fichier);
        fputs("sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n",fichier);
        fputs("sel_func_ALU_connect <= \"000\"; \n",fichier);
        fputs(" mem_rw_depth <= \"0000\"; \n",fichier);
        fputs("\n",fichier);
        fputs("case funct3 is \n",fichier);
        fputs("  when \"000\" => if(funct7=\"0100000\") then \n",fichier);
        fputs("  sel_func_ALU <= \"0010\"; -- sub\n",fichier);
        fputs("  elsif(funct7=\"0000000\") then\n",fichier);
        fputs("  sel_func_ALU <= \"0001\";-- add\n",fichier);
        fputs(" else \n",fichier);
        fputs("sel_func_ALU <= \"0000\"; -- nop \n",fichier);
        fputs("end if; \n",fichier);
        fputs("when \"001\" => sel_func_ALU <= \"1000\"; -- sll\n",fichier);
        fputs("when \"011\" => sel_func_ALU <= \"0100\"; -- sltu\n",fichier);
        fputs("when \"100\" => sel_func_ALU <= \"0111\"; -- xor \n",fichier);
        fputs("when \"101\" => if(funct7=\"0100000\") then\n",fichier);
        fputs("sel_func_ALU <= \"1010\"; -- sra\n",fichier);
        fputs("elsif(funct7=\"0000000\")then\n",fichier);
        fputs("sel_func_ALU <= \"1001\"; -- srl\n",fichier);
        fputs("else\n",fichier);
        fputs(" sel_func_ALU <= \"0000\"; -- nop\n",fichier);
        fputs("  end if; \n",fichier);
        fputs("  when \"110\" => sel_func_ALU <= \"0110\"; -- or\n",fichier);
        fputs("when \"111\" => sel_func_ALU <= \"0101\"; -- and\n",fichier);
        fputs("when others => sel_func_ALU <= \"0000\"; -- nop\n",fichier);
        fputs("end case;\n",fichier);
        fputs("\n",fichier);
      }
      printf("est-ce que le processeur contient des op de type reg-im ? \n ");
      scanf("%d",&reponse);
      if (reponse == 1)
      {

  fputs("   imm_type <= \"001\"; -- Type I\n",fichier);
  fputs("   sel_op2 <= '1'; \n",fichier);
  fputs(" sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon \n",fichier);
  fputs("   sel_func_ALU_connect <= \"000\"; \n",fichier);
  fputs(" mem_rw_depth <= \"0000\"; \n",fichier);
  fputs(" \n",fichier);
  fputs("   case funct3 is\n",fichier);
  fputs("  when \"000\" => -- addi \n",fichier);
  fputs(" sel_func_ALU <= \"0001\";\n",fichier);
  fputs("    when \"010\" => -- slti\n",fichier);
  fputs("   sel_func_ALU <= \"0011\";\n",fichier);
  fputs("  when \"011\" => -- sltiu \n",fichier);
  fputs("  sel_func_ALU <= \"0100\"; \n",fichier);
  fputs(" when \"111\" => -- andi \n",fichier);
  fputs(" sel_func_ALU <= \"0101\";  \n",fichier);
  fputs("   when \"110\" => -- ori \n",fichier);
  fputs("sel_func_ALU <= \"0110\"; \n",fichier);
  fputs("   when \"100\" => -- xori \n",fichier);
  fputs(" sel_func_ALU <= \"0111\"; \n",fichier);
  fputs(" when \"001\" => -- slli \n",fichier);
  fputs("  sel_func_ALU <=\"1000\"; \n",fichier);
  fputs("   when \"101\" => \n",fichier);
  fputs(" if(funct7=\"0000000\") then -- srli\n",fichier);
  fputs("  sel_func_ALU <= \"1001\"; \n",fichier);
  fputs("   elsif(funct7=\"0100000\") then -- srai\n",fichier);
  fputs(" sel_func_ALU <= \"1010\";\n",fichier);
  fputs(" else \n",fichier);
  fputs(" sel_func_ALU <= \"0000\"; -- nop \n",fichier);
  fputs("  end if; \n",fichier);
  fputs("  when others => sel_func_ALU <= \"0000\"; \n",fichier);
  fputs("   end case; \n",fichier);

      }

      printf("est-ce que le processeur contient des op de type load ? \n ");
      scanf("%d",&reponse);
      if (reponse == 1)
      {
      fputs("   imm_type <= \"001\"; -- Type I\n",fichier);
      fputs("   sel_op2 <= '1'; \n",fichier);
      fputs("   sel_result <= \"01\"; -- 00 pour l'ALU, 01 pour mï¿½moire et 10 pour PC \n",fichier);
      fputs("  sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon  \n",fichier);
      fputs("sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs("   sel_func_ALU <= \"0001\"; \n",fichier);
      fputs("   mem_rw_depth <= \"0000\";\n",fichier);
      fputs(" \n",fichier);
      fputs(" case funct3 is \n",fichier);
      fputs(" when \"000\" => -- lb \n",fichier);
      fputs("sel_func_ALU <= \"0001\"; \n",fichier);
      fputs("   mem_rw_depth <= \"0001\";\n",fichier);
      fputs(" when \"001\" => -- lh\n",fichier);
      fputs(" sel_func_ALU <= \"0001\";\n",fichier);
      fputs("   mem_rw_depth <= \"0011\"; \n",fichier);
      fputs("  when \"010\" => -- lw \n",fichier);
      fputs("   sel_func_ALU <= \"0001\"; \n",fichier);
      fputs("   mem_rw_depth <= \"1111\"; \n",fichier);
      fputs(" when \"100\" => -- lbu\n",fichier);
      fputs(" sel_func_ALU <= \"0001\";\n",fichier);
      fputs("  mem_rw_depth <= \"0001\"; \n",fichier);
      fputs(" when \"101\" => -- lhu \n",fichier);
      fputs(" sel_func_ALU <= \"0001\";\n",fichier);
      fputs("   mem_rw_depth <= \"0011\"; \n",fichier);
      fputs(" when others => sel_func_ALU <= \"0000\";\n",fichier);
      fputs("  mem_rw_depth <= \"0000\"; \n",fichier);
      fputs(" end case; \n",fichier);
    }

          printf("est-ce que le processeur contient des op de type Write ? \n ");
          scanf("%d",&reponse);
          if (reponse == 1)
          {
            fputs(" when \"1100011\"  =>" , fichier );
      fputs(" imm_type <= \"010\"; -- Type S \n",fichier);
      fputs("   sel_op2 <= '1'; \n",fichier);
      fputs(" sel_result <= \"01\" ; \n", fichier);
      fputs(" sel_PC_Mux <= \"00\"; -- 01 pour les branchements, 10 pour jal, 00 sinon \n",fichier);
      fputs(" sel_func_ALU_connect <= \"000\";\n",fichier);
      fputs(" sel_func_ALU <= \"0001\";\n",fichier);
      fputs(" \n",fichier);
      fputs("   case funct3 is \n",fichier);
      fputs("   when \"000\" => -- sb \n",fichier);
      fputs(" sel_func_ALU <= \"0001\"; \n",fichier);
      fputs("  mem_rw_depth <= \"0001\"; --01 \n",fichier);
      fputs("   when \"011\" => -- sh \n",fichier);
      fputs("  sel_func_ALU <= \"0001\"; \n",fichier);
      fputs(" mem_rw_depth <= \"0010\"; --10 \n",fichier);
      fputs("   when \"010\" => -- sw \n",fichier);
      fputs(" sel_func_ALU <= \"0001\"; \n",fichier);
      fputs(" mem_rw_depth <= \"1111\"; -- 11 \n",fichier);
      fputs("   when others => sel_func_ALU <= \"0000\"; \n",fichier);
      fputs("  mem_rw_depth <= \"0001\";\n",fichier);
      fputs("   end case;\n",fichier);

    }
    printf("est-ce que le processeur contient des op de type control ? \n ");
    scanf("%d",&reponse);
    if (reponse == 1)
    {
      fputs("   when \"1100011\" => \n",fichier);
      fputs("  imm_type <= \"011\"; -- Type B \n",fichier);
      fputs("  sel_op2 <= '0'; \n",fichier);
      fputs("   sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour mï¿½moire et 10 pour PC \n",fichier);
      fputs(" sel_func_ALU <= \"0000\"; \n",fichier);
      fputs("   mem_rw_depth <= \"0000\"; \n",fichier);
      fputs(" \n",fichier);
      fputs(" case funct3 is \n",fichier);
      fputs(" when \"000\" => -- beq \n",fichier);
      fputs(" sel_func_ALU_connect <= \"001\"; \n",fichier);
      fputs("  when \"001\" => -- bne\n",fichier);
      fputs("   sel_func_ALU_connect <= \"010\"; \n",fichier);
      fputs(" when \"100\" => -- blt \n",fichier);
      fputs(" sel_func_ALU_connect <= \"011\"; \n",fichier);
      fputs(" when \"101\" => -- bge \n",fichier);
      fputs("   sel_func_ALU_connect <= \"100\"; \n",fichier);
      fputs(" when \"110\" => -- bltu \n",fichier);
      fputs("   sel_func_ALU_connect <= \"101\"; \n",fichier);
      fputs("  when \"111\" => -- bgeu \n",fichier);
      fputs(" sel_func_ALU_connect <= \"110\"; \n",fichier);
      fputs("   when others => sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs("   end case; \n",fichier);
      fputs("   if(Val_connect = '1') then \n",fichier);
      fputs("   sel_PC_Mux <= \"01\"; -- 01 pour les branchements, 10 pour jal, 00 sinon  \n",fichier);
      fputs(" else \n",fichier);
      fputs("sel_PC_Mux <= \"00\"; -- on continue normalement \n",fichier);
      fputs("   end if; \n",fichier);
    }
    printf("est-ce que le processeur contient des op de type Jal ? \n ");
    scanf("%d",&reponse);
    if( reponse ==1 )
    {
      fputs(" imm_type <= \"101\"; -- Type J \n ", fichier);
      fputs("   sel_op2 <= '0'; \n",fichier);
      fputs("   sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC\n",fichier);
      fputs("sel_PC_Mux <= \"01\"; -- 01 pour les branchementset jal, 10 pour mettre le pc a 0, 11 pour jalr, 00 sinon \n",fichier);
      fputs("   sel_func_ALU_connect <= \"000\";  \n",fichier);
      fputs("   sel_func_ALU <= \"0000\";\n",fichier);
      fputs("   mem_rw_depth <= \"0000\"; \n",fichier);
    }
    printf("est-ce que le processeur contient des op de type Jalr ? \n ");
    scanf("%d",&reponse);
    if( reponse ==1 )
    {
      fputs(" imm_type <= \"001\"; -- Type I \n",fichier);
      fputs("   sel_op2 <= '1'; \n",fichier);
      fputs("  sel_result <= \"10\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder \n",fichier);
      fputs("  sel_PC_Mux <= \"11\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon \n",fichier);
      fputs("   sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs(" sel_func_ALU <= \"1100\"; \n",fichier);
      fputs("mem_rw_depth <= \"0000\"; \n",fichier);
    }
    printf("est-ce que le processeur contient des op de type Lui ? \n ");
    scanf("%d",&reponse);
    if( reponse ==1 )
    {
      fputs("  imm_type <= \"100\"; -- Type U \n",fichier);
      fputs(" sel_op2 <= '1';\n",fichier);
      fputs(" sel_result <= \"00\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder\n",fichier);
      fputs(" sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon \n",fichier);
      fputs("   sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs("   sel_func_ALU <= \"1011\"; \n",fichier);
      fputs(" mem_rw_depth <= \"0000\";\n",fichier);
    }
    printf("est-ce que le processeur contient des op de type Auipc ? \n ");
    scanf("%d",&reponse);
    if( reponse ==1 )
    {

      fputs("   when \"0010111\" =>   \n",fichier);
      fputs("   imm_type <= \"100\"; -- Type U\n",fichier);
      fputs("   sel_op2 <= '0';\n",fichier);
      fputs(" sel_result <= \"11\"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder\n",fichier);
      fputs("   sel_PC_Mux <= \"00\"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon\n",fichier);
      fputs(" sel_func_ALU_connect <= \"000\";\n",fichier);
      fputs("   sel_func_ALU <= \"1011\"; -- Mais on s'en cogne de ca en vrai nan ???? G pas raison ?\n",fichier);
      fputs("   mem_rw_depth <= \"0000\";\n",fichier);
    }

      fputs(" \n",fichier);
      fputs("   when others =>\n",fichier);
      fputs("  imm_type <= \"000\"; \n",fichier);
      fputs("   sel_op2 <= '0'; \n",fichier);
      fputs("sel_result <= \"00\"; \n",fichier);
      fputs("sel_PC_Mux <= \"00\"; \n",fichier);
      fputs("sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs("sel_func_ALU_connect <= \"000\"; \n",fichier);
      fputs("  mem_rw_depth <= \"0000\"; \n",fichier);
      fputs("  end case; \n",fichier);
      fputs("end process; \n",fichier);
      fputs(" end Behavioral;\n",fichier);
      fputs(" \n",fichier);
      fputs(" \n",fichier);
      fputs(" \n",fichier);
      return 1;
    }}
