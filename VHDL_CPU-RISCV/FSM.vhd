----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 08:45:43
-- Design Name: 
-- Module Name: FSM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
   Generic(
           Bit_Nber         : integer := 32
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           Val_Inst         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           boot             : in std_logic;
           
           Ena_Mem_Inst         : out STD_LOGIC;
           Ena_Mem_Data         : out STD_LOGIC;
           RW_Mem_Data          : out STD_LOGIC_VECTOR (1 downto 0);
           
           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : out STD_LOGIC;
           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : out STD_LOGIC;
           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
           --RW_UT_Data           : out STD_LOGIC;
           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : in STD_LOGIC;
           
           init_counter         : out STD_LOGIC;
           load_plus4           : out std_logic;
           sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0)
           );
end FSM;

architecture Behavioral of FSM is

component decoblock is
    Generic(Bit_Nber : integer := 32);
    Port(    opcode : in std_logic_vector(6 downto 0);
             funct3 : in std_logic_vector(2 downto 0);
             funct7 : in std_logic_vector(6 downto 0);
             sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
             imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
             sel_op2              : out STD_LOGIC;
             sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
             --RW_UT_Data           : out STD_LOGIC;
             sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
             sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0);
             Val_connect          : in STD_LOGIC;
             mem_rw_depth         : out std_logic_vector(1 downto 0));
end component;


type state_type is (Init, FetchIns, Decode, ExeOP, ExeOPimm, ExeAddr, ExeLoad, ExeWrite, ExeCtr, ExeJal, ExeJal2, ExeJalr, ExeLui, ExeAuipc, ExeNop); --, FetchOperand (a remettre si besoin)
signal current_state, next_state : state_type;

signal opcode : std_logic_vector(6 downto 0);
signal funct3 : std_logic_vector(2 downto 0);
signal funct7 : std_logic_vector(6 downto 0);
signal s_mem_rw_depth : std_logic_vector(1 downto 0);

signal addr : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);

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
             --RW_UT_Data => RW_UT_Data,
             sel_func_ALU_connect => sel_func_ALU_connect,
             sel_PC_Mux => sel_PC_Mux,
             Val_connect => Val_connect,
             mem_rw_depth => s_mem_rw_depth);

funct3 <= Val_Inst(14 downto 12);
funct7 <= Val_Inst(31 downto 25);

process (clk,Reset,CE)
begin
    if reset = '1' or boot = '1' then
	   current_state <= init;
	elsif CE = '0' then
	    current_state <= init;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
 end process;

process(current_state,opcode)
begin
    case current_state is    
        when Init => 
            if boot = '1' then
                next_state <= Init;
            else
                next_state <= FetchIns;       
            end if;
            
        when FetchIns => next_state <= Decode;
        
        when Decode => if    (opcode = "0110011") then next_state <= ExeOp;
                       elsif (opcode = "0010011") then next_state <= ExeOpimm;
                       elsif (opcode = "0000011") then next_state <= ExeAddr;
                       elsif (opcode = "0100011") then next_state <= ExeAddr;
                       elsif (opcode = "1100011") then next_state <= ExeCtr;
                       elsif (opcode = "1101111") then next_state <= ExeJal;
                       elsif (opcode = "1100111") then next_state <= ExeJalr;
                       elsif (opcode = "0110111") then next_state <= ExeLui;
                       elsif (opcode = "0010111") then next_state <= ExeAuipc;                     
                       else  next_state <= ExeNop;
                       end if;
                                   
        when ExeAddr => if (opcode = "0000011") then next_state <= ExeLoad;
                        elsif (opcode = "0100011") then next_state <= ExeWrite;
                        else next_state <= ExeNop;
                        end if;                
        when ExeOp => next_state <= FetchIns;           
        when ExeOpimm => next_state <= FetchIns;
        when ExeLoad => next_state <= FetchIns;
        when ExeWrite => next_state <= FetchIns;
        when ExeCtr => next_state <= FetchIns;
        when ExeJal => next_state <= ExeJal2;
        when ExeJal2 => next_state <= FetchIns;
        when ExeJalr => next_state <= FetchIns;
        when ExeLui => next_state <= FetchIns;
        when ExeAuipc => next_state <= FetchIns;
        when ExeNop => next_state <= FetchIns;
    end case;
end process;

process(current_state, Val_Inst, s_mem_rw_depth)
begin
    case current_state is
        when Init =>  Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '0';
                      init_counter <= '0';
                      load_plus4 <='0';
                      opcode <= "0000000";
                      
        when FetchIns => Ena_Mem_Inst <= '1';
                         Ena_Mem_Data <= '0';
                         RW_Mem_Data <= "00";
                         reg_file_write <= '0';
                         init_counter <= '0';
                         load_plus4 <='0';
                         opcode <= Val_Inst(6 downto 0);
                         
        when Decode => Ena_Mem_Inst <= '0';
                       Ena_Mem_Data <= '0';
                       RW_Mem_Data <= "00";
                       reg_file_write <= '0';
                       init_counter <= '0'; 
                       load_plus4 <='0'; 
                       opcode <= Val_Inst(6 downto 0);                       
    
        when ExeOP => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '1';
                      init_counter <= '1';
                      load_plus4 <= '1';
                      opcode <= Val_Inst(6 downto 0);
                      
       when ExeOPimm => Ena_Mem_Inst <= '0';
                        Ena_Mem_Data <= '0';
                        RW_Mem_Data <= "00";
                        reg_file_write <= '1';
                        init_counter <= '1';
                        load_plus4 <= '1';
                        opcode <= Val_Inst(6 downto 0);
                            
      when ExeAddr => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '1';
                      RW_Mem_Data <= s_mem_rw_depth;
                      reg_file_write <= '0';
                      init_counter <= '1';   
                      load_plus4 <='0';  
                      opcode <= Val_Inst(6 downto 0);      
                       
       when ExeLoad => Ena_Mem_Inst <= '0';
                        Ena_Mem_Data <= '1';
                        RW_Mem_Data <= s_mem_rw_depth;
                        reg_file_write <= '1';
                        init_counter <= '1';
                        load_plus4 <= '1';
                        opcode <= Val_Inst(6 downto 0);
                                                            
       when ExeWrite => Ena_Mem_Inst <= '0';
                     Ena_Mem_Data <= '1';
                     RW_Mem_Data <= s_mem_rw_depth; 
                     reg_file_write <= '0';
                     init_counter <= '1';
                     load_plus4 <='1';
                     opcode <= Val_Inst(6 downto 0);
       
       when ExeCtr => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '0';
                      init_counter <= '1';
                      load_plus4 <='1';  
                      opcode <= Val_Inst(6 downto 0);                       
                     
       when ExeJal => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '1';
                      init_counter <= '1';
                      load_plus4 <='1';
                      opcode <= Val_Inst(6 downto 0);
                      
      when ExeJal2 => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '0';
                      init_counter <= '1';
                      load_plus4 <='0';
                      opcode <= Val_Inst(6 downto 0);
      
      when ExeJalr => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';                      
                      RW_Mem_Data <= "00";
                      reg_file_write <= '1';             
                      init_counter <= '1';                     
                      load_plus4 <='1'; 
                      opcode <= Val_Inst(6 downto 0);        
       
       when ExeLui => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '1';
                      init_counter <= '1'; 
                      load_plus4 <='1';
                      opcode <= Val_Inst(6 downto 0);
                      
      when ExeAuipc => Ena_Mem_Inst <= '0';
                        Ena_Mem_Data <= '0';   
                        RW_Mem_Data <= "00";   
                        reg_file_write <= '1';
                        init_counter <= '0';                    
                        load_plus4 <='1'; 
                        opcode <= Val_Inst(6 downto 0);  
                                            
       when ExeNop => Ena_Mem_Inst <= '0';
                      Ena_Mem_Data <= '0';
                      RW_Mem_Data <= "00";
                      reg_file_write <= '0';
                      init_counter <= '1';   
                      load_plus4 <='1';  
                      opcode <= "0000000";               
    end case;                  
end process;

end Behavioral;