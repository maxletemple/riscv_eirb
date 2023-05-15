library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sequenceur is
   Generic(
           Bit_Nber             : integer := 32
           );
    Port ( Clk                  : in STD_LOGIC;
           Reset                : in STD_LOGIC;
           CE                   : in STD_LOGIC;
           Val_Inst             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
          
           Ena_Mem_Inst         : out STD_LOGIC;
           Ena_Mem_Data         : out STD_LOGIC;
           RW_Mem_Data          : out STD_LOGIC_VECTOR (3 downto 0);
          
           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : out STD_LOGIC;
           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : out STD_LOGIC;
           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : in STD_LOGIC;
           boot                 : in std_logic;
           init_counter         : out STD_LOGIC;
           load_plus4           : out std_logic;
           sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0)
           );
end sequenceur;
architecture Behavioral of sequenceur is
    type sortie1 is ARRAY(0 to 14) of std_logic;
    signal sortie_1: sortie1:=('0','1','0','0','0','0','0','0','0','0','0','0','0','0','0');

    type sortie2 is ARRAY(0 to 14) of std_logic;
    signal sortie_2: sortie2:=('0','0','0','0','0','1','0','0','0','0','0','0','1','1','0');

    type sortie3 is ARRAY(0 to 14) of std_logic_vector(3 downto 0);
    signal sortie_3: sortie3:=("0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000");

    type sortie4 is ARRAY(0 to 14) of std_logic;
    signal sortie_4: sortie4:=('0','0','0','1','1','0','0','1','1','1','1','0','1','0','0');

    type sortie5 is ARRAY(0 to 14) of std_logic;
    signal sortie_5: sortie5:=('0','0','0','1','1','0','1','0','0','0','0','0','1','1','1');

    type sortie6 is ARRAY(0 to 14) of std_logic;
    signal sortie_6: sortie6:=('0','0','0','1','1','0','1','1','1','1','1','1','1','1','0');
component decoblock is
    Generic(Bit_Nber                 : integer := 32);
    Port(opcode                  : in std_logic_vector(6 downto 0);
         funct3                  : in std_logic_vector(2 downto 0);
         funct7                  : in std_logic_vector(6 downto 0);
         sel_func_ALU            : out STD_LOGIC_VECTOR (3 downto 0);
         imm_type                : out STD_LOGIC_VECTOR (2 downto 0);
         sel_op2                 : out STD_LOGIC;
         sel_result              : out STD_LOGIC_VECTOR (1 downto 0);
         sel_func_ALU_connect    : out STD_LOGIC_VECTOR (2 downto 0);
         sel_PC_Mux              : out STD_LOGIC_VECTOR (1 downto 0);
         Val_connect             : in STD_LOGIC;
         mem_rw_depth            : out std_logic_vector(3 downto 0));
end component;

signal opcode            : std_logic_vector(6 downto 0);
signal funct3            : std_logic_vector(2 downto 0);
signal funct7            : std_logic_vector(6 downto 0);
signal s_mem_rw_depth    : std_logic_vector(3 downto 0);

signal PC : STD_LOGIC_VECTOR (4 downto 0) :="00000";
signal PC_futur : STD_LOGIC_VECTOR (4 downto 0) :="00000";

begin

decode0 : decoblock
    generic map(Bit_Nber => 32)
    port map(opcode => opcode,
             funct3 => funct3,
             funct7 => funct7,
             sel_func_ALU => sel_func_ALU,
             imm_type => imm_type,
             sel_op2 => sel_op2,
             sel_result => sel_result,
             sel_func_ALU_connect => sel_func_ALU_connect,
             sel_PC_Mux => sel_PC_Mux,
             Val_connect => Val_connect,
             mem_rw_depth => s_mem_rw_depth);

funct3 <= Val_Inst(14 downto 12);
funct7 <= Val_Inst(31 downto 25);
process(clk, reset, ce, boot)
begin
  if(reset='1') then
    PC <= "00000";
  elsif (ce='0') then
    PC <= "00000";
  elsif (boot='1') then
    PC <= "00000";
  elsif rising_edge(clk) then
    PC <= PC_futur;
  end if;
end process;
process(PC, opcode)
begin
  case PC is
    when "00000"=> PC_futur <= "00001";
    when "00001" => PC_futur <= "00010";
    when "00010" =>           if(opcode = "0110011") then PC_futur <= "00011";
          elsif(opcode="0010011") then PC_futur<="00100";
          elsif(opcode="0000011")then PC_futur<="00101";
          elsif(opcode="0100011")then PC_futur<="00101";
          elsif(opcode="1100011")then PC_futur<="00110";
          elsif(opcode="1101111")then PC_futur<="00111";
          elsif(opcode="1100111")then PC_futur<="01000";
          elsif(opcode="0110111")then PC_futur<="01001";
          elsif(opcode="0010111")then PC_futur<="01010";
          elsif(opcode="1111111")then PC_futur<="11111";
          else PC_futur <= "01011";
          end if;
      when"00101" =>             if(opcode="0000011") then PC_futur<="01100";
               elsif(opcode="0100011") then PC_futur<="01100";
          else PC_futur<="01011";
         end if;       when "00011"  =>
             PC_futur<="00001";       when "00100"  =>
             PC_futur<="00001";       when "01100"  =>
             PC_futur<="00010";       when "01101"  =>
             PC_futur<="00001";       when "00110"  =>
             PC_futur<="00001";       when "00111"  =>
             PC_futur<="01110";       when "01110"  =>
             PC_futur<="00001";       when "01000"  =>
             PC_futur<="00001";       when "01001"  =>
             PC_futur<="00001";       when "01010"  =>
             PC_futur<="00001";              when "01011"  =>
                   PC_futur<="00001";
                            when "11111"  =>
                              PC_futur<="00001";
             when others => null;
  end case;
  end process;process(PC, Val_Inst, s_mem_rw_depth)
begin
CASE pc IS  when "00000" =>
    Ena_Mem_INST <= sortie_1(0);
    Ena_Mem_DATA <= sortie_2(0);
    rw_mem_data <= "0000";
    reg_file_write <= sortie_4(0);
    init_counter <= sortie_5(0);
    load_plus4 <= sortie_6(0);
    opcode <= Val_Inst(6 downto 0);
  when "00001" =>
    Ena_Mem_INST <= sortie_1(1);
    Ena_Mem_DATA <= sortie_2(1);
    rw_mem_data <= "0000";
    reg_file_write <= sortie_4(1);
    init_counter <= sortie_5(1);
    load_plus4 <= sortie_6(1);
    opcode <= Val_Inst(6 downto 0);
  when "00010" =>
    Ena_Mem_INST <= sortie_1(2);
    Ena_Mem_DATA <= sortie_2(2);
    rw_mem_data <= "0000";
    reg_file_write <= sortie_4(2);
    init_counter <= sortie_5(2);
    load_plus4 <= sortie_6(2);
    opcode <= Val_Inst(6 downto 0);
when "00011" => 
  Ena_Mem_INST<=sortie_1(3);
  Ena_Mem_DATA<=sortie_2(3);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(3);
  init_counter<=sortie_5(3);
  load_plus4<=sortie_6(3);
  opcode<=Val_Inst(6 downto 0);
when "00100" => 
  Ena_Mem_INST<=sortie_1(4);
  Ena_Mem_DATA<=sortie_2(4);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(4);
  init_counter<=sortie_5(4);
  load_plus4<=sortie_6(4);
  opcode<=Val_Inst(6 downto 0);
when "00101" => 
  Ena_Mem_INST<=sortie_1(5);
  Ena_Mem_DATA<=sortie_2(5);
  rw_mem_data<=s_mem_rw_depth;
  reg_file_write<=sortie_4(5);
  init_counter<=sortie_5(5);
  load_plus4<=sortie_6(5);
  opcode<=Val_Inst(6 downto 0);
when "00110" => 
  Ena_Mem_INST<=sortie_1(6);
  Ena_Mem_DATA<=sortie_2(6);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(6);
  init_counter<=sortie_5(6);
  load_plus4<=sortie_6(6);
  opcode<=Val_Inst(6 downto 0);
when "00111" => 
  Ena_Mem_INST<=sortie_1(7);
  Ena_Mem_DATA<=sortie_2(7);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(7);
  init_counter<=sortie_5(7);
  load_plus4<=sortie_6(7);
  opcode<=Val_Inst(6 downto 0);
when "01000" => 
  Ena_Mem_INST<=sortie_1(8);
  Ena_Mem_DATA<=sortie_2(8);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(8);
  init_counter<=sortie_5(8);
  load_plus4<=sortie_6(8);
  opcode<=Val_Inst(6 downto 0);
when "01001" => 
  Ena_Mem_INST<=sortie_1(9);
  Ena_Mem_DATA<=sortie_2(9);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(9);
  init_counter<=sortie_5(9);
  load_plus4<=sortie_6(9);
  opcode<=Val_Inst(6 downto 0);
when "01010" => 
  Ena_Mem_INST<=sortie_1(10);
  Ena_Mem_DATA<=sortie_2(10);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(10);
  init_counter<=sortie_5(10);
  load_plus4<=sortie_6(10);
  opcode<=Val_Inst(6 downto 0);
when "01011" => 
  Ena_Mem_INST<=sortie_1(11);
  Ena_Mem_DATA<=sortie_2(11);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(11);
  init_counter<=sortie_5(11);
  load_plus4<=sortie_6(11);
  opcode<=Val_Inst(6 downto 0);
when "01100" => 
  Ena_Mem_INST<=sortie_1(12);
  Ena_Mem_DATA<=sortie_2(12);
  rw_mem_data<=s_mem_rw_depth;
  reg_file_write<=sortie_4(12);
  init_counter<=sortie_5(12);
  load_plus4<=sortie_6(12);
  opcode<=Val_Inst(6 downto 0);
when "01101" => 
  Ena_Mem_INST<=sortie_1(13);
  Ena_Mem_DATA<=sortie_2(13);
  rw_mem_data<=s_mem_rw_depth;
  reg_file_write<=sortie_4(13);
  init_counter<=sortie_5(13);
  load_plus4<=sortie_6(13);
  opcode<=Val_Inst(6 downto 0);
when "01110" => 
  Ena_Mem_INST<=sortie_1(14);
  Ena_Mem_DATA<=sortie_2(14);
  rw_mem_data<="0000";
  reg_file_write<=sortie_4(14);
  init_counter<=sortie_5(14);
  load_plus4<=sortie_6(14);
  opcode<=Val_Inst(6 downto 0);
when "11111"  => 
  Ena_Mem_INST<=sortie_1(3);
Ena_Mem_DATA<=sortie_2(3);
rw_mem_data<="0000";
reg_file_write<=sortie_4(3);
init_counter<=sortie_5(3);
load_plus4<=sortie_6(3);
opcode<=Val_Inst(6 downto 0);
when others => null;
end case;
end process;
end behavioral;