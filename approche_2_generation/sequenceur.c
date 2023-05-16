#include <stdlib.h>
#include <stdio.h>

//------------------------CALCUL DES SORTIEs-----------------

void sorties ()
{
  printf(" Vous aller generer le process du calcul des sorties . \n Vous aurez besoin du nombre des etats, ainsi que les valeurs des 6 sorties de chaque instruction\n");
  printf("_________ \n");
  int nbr_etat;
  printf ("Entrer le nombre d'etats : \n");
  scanf("%d",&nbr_etat);

    FILE * fichier = NULL ;
    fichier = fopen ( " fichier1.txt" , "w");
    if ( fichier != NULL)
    {
     fputs(" library IEEE;\n",fichier);
      fputs(" use ieee.std_logic_1164.all;\n",fichier);
      fputs("use ieee.numeric_std.all; \n",fichier);
      fputs("\n",fichier);
      fputs("entity sequenceur is \n",fichier);
      fputs("Generic( \n" , fichier);
      fputs("Bit_Nber : integer :=32); \n" , fichier);
      fputs(" Port ( Clk : in STD_LOGIC; \n",fichier);
      fputs( "Reset : in STD_LOGIC;\n",fichier);
      fputs("CE : in STD_LOGIC;\n",fichier);
      fputs("Val_Inst  : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);\n",fichier);
      fputs("\n",fichier);

      fputs("Ena_Mem_Inst : out STD_LOGIC;\n",fichier);
      fputs("Ena_Mem_Data: out STD_LOGIC;\n",fichier);
      fputs(" RW_Mem_Data : out STD_LOGIC_VECTOR (3 downto 0);\n",fichier);
      fputs("sel_func_ALU : out STD_LOGIC_VECTOR (3 downto 0);\n",fichier);
      fputs(" reg_file_write       : out STD_LOGIC;\n",fichier);
      fputs("imm_type : out STD_LOGIC_VECTOR (2 downto 0);\n",fichier);
      fputs("sel_op2 : out STD_LOGIC;\n",fichier);
      fputs("sel_result: out STD_LOGIC_VECTOR (1 downto 0);\n",fichier);
      fputs("sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);\n",fichier);
      fputs("Val_connect  : in STD_LOGIC;\n",fichier);
      fputs(" boot : in std_logic;\n",fichier);
      fputs("init_counter : out STD_LOGIC;\n",fichier);
      fputs(" load_plus4  : out std_logic;\n",fichier);
      fputs("sel_PC_Mux : out STD_LOGIC_VECTOR (1 downto 0)); \n",fichier);
      fputs(" end sequenceur;\n",fichier);
      fputs("\n",fichier);
      fputs("\n",fichier);
      fputs("\n",fichier);



      fputs("architecture Behavioral of sequenceur is \n",fichier);

      int i=0 , j=0;

      /////////////////////sortie   1 /////////////////////////
      printf("la sortie 1 est : Ena_Mem_Inst \n");

      fputs("type sortie1 is array(0 to ",fichier);
      fprintf(fichier, "%d", nbr_etat-1);
      fputs(") of std_logic; \n",fichier);
        fputs("signal sortie_1: sortie1:=('",fichier);
        int s;
        for(i=1;i<nbr_etat;i++)
        {
          printf("inserer la valeur de la sortie_1 de l'etat %d \n",i);
          scanf("%d",&s);
          fprintf(fichier, "%d", s);
          fputs("','",fichier );

        }
        printf("inserer la valeur de la sortie_1 de l'etat %d\n",nbr_etat);
        scanf("%d",&s);
        fprintf(fichier, "%d", s);
        //fputc(s , fichier );
        fputs("'); \n",fichier);

        /////////////////////sortie   2 /////////////////////////
        fputs("type sortie2 is array(0 to ",fichier);
        fprintf(fichier, "%d", nbr_etat-1);
        fputs(") of std_logic; \n",fichier);
        fputs("signal sortie_2: sortie2:=('",fichier);
        printf("la sortie 2 est : Ena_Mem_DATA \n");


      for(i=1;i<nbr_etat;i++)
      {
        printf("inserer la valeur de la sortie_2 de l'etat %d\n",i);
        scanf("%d",&s);
        fprintf(fichier, "%d", s);
        //fputc(s , fichier );
        fputs("','",fichier );

      }
      printf("inserer la valeur de la sortie_2 de l'etat %d\n",nbr_etat);
      scanf("%d",&s);
      fprintf(fichier, "%d", s);
      //fputc(s , fichier );
      fputs("'); \n",fichier);
      /////////////////////sortie   3 /////////////////////////
      printf("la sortie 3 est : rw_mem_data \n");

      fputs("type sortie3 is array(0 to ",fichier);
      fprintf(fichier, "%d", nbr_etat-1);
      fputs(") of std_logic_vector(3 downto 0); \n",fichier);
      fputs("signal sortie_3: sortie3:=(\"",fichier);
        char s_vector[5] ="0000";

        for(i=1;i<nbr_etat;i++)
        {
          printf("inserer la valeur de la sortie_3 de l'etat %d\n",i);
          scanf("%s" , s_vector);
          fputs(s_vector , fichier);
          fputs("\",\"",fichier );
        }
        printf("inserer la valeur de la sortie_3 de l'etat %d\n",nbr_etat);
        scanf("%s" , s_vector);
        fputs(s_vector , fichier);
        fputs("\"); \n",fichier);

        /////////////////////sortie   4 /////////////////////////
        printf("la sortie 4 est : reg_file_write \n");

fputs("type sortie4 is array(0 to ",fichier);
fprintf(fichier, "%d", nbr_etat-1);
fputs(") of std_logic; \n",fichier);
fputs("signal sortie_4: sortie4:=('",fichier);

            for(i=1;i<nbr_etat;i++)
            {
              printf("inserer la valeur de la sortie_4 de l'etat %d\n",i);
              scanf("%d",&s);
              fprintf(fichier, "%d", s);
              //fputc(s , fichier );
              fputs("','",fichier );

            }
            printf("inserer la valeur de la sortie_4 de l'etat %d\n",nbr_etat);
            scanf("%d",&s);
            fprintf(fichier, "%d", s);
            //fputc(s , fichier );
            fputs("'); \n",fichier);
            /////////////////////sortie   5 /////////////////////////

            printf("la sortie 5 est : init_counter \n");

            fputs("type sortie5 is array(0 to ",fichier);
            fprintf(fichier, "%d", nbr_etat-1);
            fputs(") of std_logic; \n",fichier);
            fputs("signal sortie_5: sortie5:=('",fichier);

              for(i=1;i<nbr_etat;i++)
              {
                printf("inserer la valeur de la sortie_5 de l'etat %d\n",i);
                scanf("%d",&s);
                fprintf(fichier, "%d", s);
                //fputc(s , fichier );
                fputs("','",fichier );

              }
              printf("inserer la valeur de la sortie_5 de l'etat %d\n",nbr_etat);
              scanf("%d",&s);
              fprintf(fichier, "%d", s);
              //fputc(s , fichier );
              fputs("'); \n",fichier);
              /////////////////////sortie   6 /////////////////////////

              printf("la sortie 5 est : load_plus4 \n");

              fputs("type sortie6 is array(0 to ",fichier);
              fprintf(fichier, "%d", nbr_etat-1);
              fputs(") of std_logic; \n",fichier);
              fputs("signal sortie_6: sortie6:=('",fichier);
          for(i=1;i<nbr_etat  ;i++)
          {
            printf("inserer la valeur de la sortie_6 de l'etat %d\n",i);
            scanf("%d",&s);
            fprintf(fichier, "%d", s);
            //fputc(s , fichier );
            fputs("','",fichier );

          }

          printf("inserer la valeur de la sortie_6 de l'etat %d\n",nbr_etat);
          scanf("%d",&s);
          fprintf(fichier, "%d", s);
          //fputc(s , fichier );
          fputs("'); \n",fichier);


          fputs("\n",fichier);
          fputs("\n",fichier);

fputs("component decoblock is \n",fichier);
fputs("\n",fichier);

fputs("Generic(Bit_Nber:integer:=32); \n",fichier);
fputs("Port(opcode:in std_logic_vector(6 downto 0); \n", fichier);
fputs("funct3 : in std_logic_vector(2 downto 0);\n", fichier);
fputs("funct7  : in std_logic_vector(6 downto 0);\n",fichier);
fputs("sel_func_ALU: out STD_LOGIC_VECTOR (3 downto 0);\n",fichier);
fputs("imm_type: out STD_LOGIC_VECTOR (2 downto 0);\n",fichier);
fputs("sel_op2 : out STD_LOGIC;\n",fichier);
fputs("sel_result : out STD_LOGIC_VECTOR (1 downto 0);\n",fichier);
fputs(" sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);\n",fichier);
fputs(" sel_PC_Mux : out STD_LOGIC_VECTOR (1 downto 0);\n",fichier);
fputs("Val_connect: in STD_LOGIC;\n",fichier);
fputs("mem_rw_depth  : out std_logic_vector(3 downto 0));\n",fichier);
fputs(" end component; \n",fichier);
fputs("\n",fichier);


fputs("signal opcode : std_logic_vector(6 downto 0);\n",fichier);
fputs("signal funct3: std_logic_vector(2 downto 0);\n",fichier);
fputs("signal funct7 : std_logic_vector(6 downto 0);\n",fichier);
fputs("signal s_mem_rw_depth : std_logic_vector(3 downto 0);\n",fichier);
fputs("\n",fichier);


fputs("signal PC : STD_LOGIC_VECTOR (5 downto 0) :=\"00000\";\n",fichier);
fputs("signal PC_futur : STD_LOGIC_VECTOR (5 downto 0) :=\"00000\";\n",fichier);
fputs("\n",fichier);

fputs("begin\n",fichier);
fputs("decode0 : decoblock\n",fichier);
fputs("  generic map(Bit_Nber => 32) \n",fichier);
fputs("port map(opcode => opcode, \n",fichier);

fputs(" funct3 => funct3, \n",fichier);
fputs("funct7 => funct7, \n",fichier);
fputs("  sel_func_ALU => sel_func_ALU,\n",fichier);
fputs(" imm_type => imm_type, \n",fichier);
fputs(" sel_op2 => sel_op2,\n",fichier);
fputs("sel_result => sel_result, \n",fichier);
fputs("sel_func_ALU_connect => sel_func_ALU_connect,\n",fichier);
fputs("sel_PC_Mux => sel_PC_Mux,\n",fichier);
fputs("Val_connect => Val_connect,\n",fichier);
fputs(" mem_rw_depth => s_mem_rw_depth);\n",fichier);

fputs("\n",fichier);


fputs("funct3 <= Val_Inst(14 downto 12); \n",fichier);
fputs("funct7 <= Val_Inst(31 downto 25); \n",fichier);
fputs("\n",fichier);
fputs("process(clk,reset,ce,boot) \n",fichier);
fputs("\n",fichier);
fputs(" begin\n",fichier);
fputs("\n",fichier);

fputs("  if(reset='1') then \n",fichier);
fputs("PC<=\"00000\" ;\n",fichier);
fputs("  elsif (ce='0') then \n",fichier);
fputs("   PC<=\"00000\" ; \n",fichier);
fputs(" elsif (boot='1') then\n",fichier);
fputs("  PC<=\"00000\" ;\n",fichier);
fputs("  elsif rising_edge(clk) then \n",fichier);
fputs(" PC<=PC_futur; \n",fichier);
fputs(" end if; \n",fichier);
fputs("end process; \n",fichier);

fclose(fichier);

}
}

void etat_futur ()
{
  printf("Vous etes sur le pint d'ecrire le process de l'etat futur.\n Pour ce , vous aurez besoin des codes etats ,des opcodes et des etats futurs correspondants.\n");
  int i;
  int nbr_etat;
  printf("\n");
  printf ("Y a combien d'etats dans ce sequenceur? \n");
  scanf("%d",&nbr_etat);

    FILE * fichier = NULL ;
    fichier = fopen ( "fichier2.txt" , "w");
    if ( fichier != NULL)
    {

fputs(" process(PC,opcode) \n",fichier);
fputs("  begin \n",fichier);
fputs("  case PC is \n",fichier);

int k;
for (k=0; k<nbr_etat ;k++)
{
      char opcode[9];
      char PC[6]="";
      char PC_futur[6]="";

      printf("inserer l'etat present numero %d ",k+1);
      scanf("%s",PC);

      fputs("when\"",fichier);
      fputs(PC,fichier);
      fputs("\"=>" , fichier );

      int nbr_opcodes;
      printf("combien d'opcodes menent a l'etat suivant?\n ");
      scanf("%d",&nbr_opcodes);
      if(nbr_opcodes ==1)
      {
          fputs("\n",fichier);
            printf("c'est quoi l'etat futur correspondant?\n");
            scanf("%s",PC_futur);

            fputs("PC_futur<=\"",fichier);
            fputs(PC_futur,fichier);
            fputs("\"; \n",fichier);
      }
      else if (nbr_opcodes ==2)
      {
        fputs("\n",fichier);
        printf("inserer le premier opcode:\n ");
        scanf("%s",opcode);
        fputs("if(opcode=\"",fichier);
        fputs(opcode,fichier);
        fputs("\") then PC_futur<=\"",fichier);
        printf("c'est quoi l'etat futur correspondant?\n");
        scanf("%s",PC_futur);
        fputs(PC_futur,fichier);
        fputs("\"; \n",fichier);

         fputs("elsif(opcode = \" ",fichier);
         printf(" le deuxieme opcode est : \n");
         scanf("%s",opcode);
         fputs(opcode,fichier);
         fputs("\") then PC_futur<=\"" , fichier);

         printf("l'etat futur correspondant : \n");
         scanf("%s", PC_futur);
         fputs(PC_futur , fichier);
         fputs("\"; \n",fichier);

         fputs("else PC_futur<=\"",fichier);
         printf("c'est quoi l'etat futur dans les autres cas?");
         scanf("%s",PC_futur);
         fputs(PC_futur,fichier);
         fputs("\"; \n",fichier);
         fputs("end if ; \n",fichier);

      }
      else if( nbr_opcodes > 2 )
      {
        fputs("\n",fichier);
        printf("inserer l'opcode:\n ");
        scanf("%s",opcode);
        fputs("if(opcode=\"",fichier);
        fputs(opcode,fichier);
        fputs("\") then PC_futur<=\"",fichier);
        printf("c'est quoi l'etat futur correspondant?\n");
        scanf("%s",PC_futur);
        fputs(PC_futur,fichier);
        fputs("\"; \n",fichier);

          int j=0;
          for(j=2;j<nbr_opcodes;j++)
          {
            fputs("elsif(opcode=\"",fichier);
            printf("inserer l'opcode:\n ");
            scanf("%s",opcode);
            fputs(opcode ,fichier);
          //  fputs("if(opcode=\"",fichier);
          //  fputs(opcode,fichier);
            fputs("\") then PC_futur<=\"",fichier);
            printf("c'est quoi l'etat futur correspondant?\n");
            scanf("%s",PC_futur);
            fputs(PC_futur,fichier);
            fputs("\"; \n",fichier);

          }

          fputs("else PC_futur<=\"",fichier);
          printf("l'etat futur restant est= \n");
          scanf("%s",PC_futur);
          fputs(PC_futur,fichier);
          fputs("\"; \n",fichier);
          fputs("end if ; \n",fichier);
       }
}

fputs("when others=> null; \n",fichier);
fputs("\n",fichier);
fputs("end case; \n",fichier);
fputs("end process ;\n",fichier);
fputs("\n",fichier);
printf("Vous allez generer le dernier process du sequenceur, vous aurez besoin alors des codes de chaque etat(instruction) . \n ");

fputs("process(PC, Val_Inst , s_mem_rw_depth) \n",fichier);
fputs("begin \n", fichier);
fputs("case pc is \n", fichier);

for(i=0;i<nbr_etat ;i++)
{
  char etat[6];
  printf("taper le code de l'etat  %d ",i+1);
  scanf("%s",etat);

  fputs("when \"",fichier);
  fputs(etat,fichier);
  fputs("\" => Ena_Mem_Data<= sortie_1(",fichier);
  fprintf(fichier, "%d", i);
  fputs("); Ena_Mem_Data<=sortie_2(",fichier);
  fprintf(fichier, "%d", i);
  fputs("); RW_Mem_Data<=\"0000\" ;reg_file_write<=sortie_4(",fichier);
  fprintf(fichier, "%d", i);
  fputs(");init_counter<=sortie_5(",fichier);
  fprintf(fichier, "%d", i);
  fputs(");load_plus4<=sortie_6(",fichier);
  fprintf(fichier, "%d", i);
  fputs(");opcode<=Val_Inst(6 downto 0);",fichier);
  fputs("\n",fichier);
}
fputs("when others => null ;\n",fichier);
fputs("end case;\n",fichier);
fputs("end process;\n" ,fichier);
fputs("end Behavioral;\n",fichier);

fclose(fichier);
}}

int main()
{
  printf("Cette application vous permettera de generer un sequneceur selon le nombre d'instructions que vous avez dans le processeur . \n");
  printf("_________ \n");
  printf("la generation se fait en trois phases \n");
  printf("\n");
   sorties();
   etat_futur();

   printf("Vous  pouvez recuperer la premiere partie du code dans fichier1.txt , et la deuxieme dans fichier2.txt \n ");

  return 1;
}
