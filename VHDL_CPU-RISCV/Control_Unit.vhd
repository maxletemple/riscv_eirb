----------------------------------------------------------------------------------
-- Company: IMS
-- Engineer: Christophe JEGO
-- 
-- Create Date: 08.11.2021 08:55:57
-- Design Name: Processor RISC-V
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    Generic(
           Bit_Nber : integer := 32
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           boot             : in std_logic;
           Val_Inst         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Jalr_Adr         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0); 
           Jr_Adr           : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0); 
           Val_Imm_Operand  : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);           
           Adr_Inst         : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           New_Adr_Inst     : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Ena_Mem_Inst     : out STD_LOGIC;
           Ena_Mem_Data     : out STD_LOGIC;
           RW_Mem_Data      : out STD_LOGIC_VECTOR (3 downto 0);
           
           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : out STD_LOGIC;
           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : out STD_LOGIC;
           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : in STD_LOGIC
           );
end Control_Unit;

architecture Behavioral of Control_Unit is

component FSM is
   Generic(
           Bit_Nber         : integer := Bit_Nber
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           boot             : in std_logic;
           Val_Inst         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           
           Ena_Mem_Inst         : out STD_LOGIC;
           Ena_Mem_Data         : out STD_LOGIC;
           RW_Mem_Data          : out STD_LOGIC_VECTOR (3 downto 0); --3
           
           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : out STD_LOGIC;
           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : out STD_LOGIC;
           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : in STD_LOGIC;
           
           init_counter         : out STD_LOGIC;
           sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0);
           Load_plus4           : out STD_LOGIC
           );
 end component;
 
 component Inst_Register is
    Generic(
            Bit_Nber         : integer := Bit_Nber
            );
    Port  ( Clk              : in STD_LOGIC;
            Reset            : in STD_LOGIC;
            CE               : in STD_LOGIC;
            init_counter     : in STD_LOGIC;   
            Val_Counter      : in  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
            Adr_Inst         : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          );
end component;

component Inst_Incr is
    Generic(
            Bit_Nber : integer := 32
            );
    Port ( Val_Inst     : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           New_Val_Inst : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
end component;

component Mux4_1 is
    Generic(
           Bit_Nber : INTEGER := Bit_Nber
           );
    Port ( In1    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In2    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In3    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In4    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           sel    : in   STD_LOGIC_VECTOR (1 downto 0);
           Output : out  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
 end component;
 
 component Adder is
    Generic(
           Bit_Nber : integer := Bit_Nber
           );
    Port (  Operand_1 : in  STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
            Operand_2 : in  STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
            Result    : out STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0)
          );
 end component;
 
 signal sig_init_counter : STD_LOGIC;
 signal sig_Load_plus4   : STD_LOGIC;
 signal sig_sel_PC_Mux   : STD_LOGIC_VECTOR (1 downto 0);
 signal sig_Val_Counter  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Adr_Inst     : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_New_Adr_Inst : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Val_Imm_adr  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 
 constant zero : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0):= (others =>'0');
 
begin

-- Finite State Machine          
inst_FSM : FSM
    generic map(Bit_Nber => Bit_Nber)
    port map(
               Clk      => Clk, 
               Reset    => Reset,  
               CE       => CE,    
               Val_Inst => Val_Inst,
               boot => boot,
          
               Ena_Mem_Inst => Ena_Mem_Inst,
               Ena_Mem_Data => Ena_Mem_Data,  
               RW_Mem_Data  => RW_Mem_Data,
           
               sel_func_ALU         => sel_func_ALU ,
               reg_file_write       => reg_file_write, 
               imm_type             => imm_type,
               sel_op2              => sel_op2,
               sel_result           => sel_result, 
               sel_func_ALU_connect => sel_func_ALU_connect,
               Val_connect          => Val_connect,
               init_counter         => sig_init_counter,
               sel_PC_Mux           => sig_sel_PC_Mux,
               Load_plus4           => sig_Load_plus4
           ); 
  
 -- Instruction Register        
PC : Inst_Register
    generic map(Bit_Nber => Bit_Nber)
    port map(
              Clk          => Clk, 
              Reset        => Reset,  
              CE           => CE,
              init_counter => sig_init_counter,
              Val_Counter  => sig_Val_Counter,               
              Adr_Inst     => sig_Adr_Inst
            );
            
 Adr_Inst <= sig_Adr_Inst;
 
 -- Instruction incr by 4       
PC_plus_4 : Inst_Incr
    generic map(Bit_Nber => Bit_Nber)
    port map(
              Val_Inst     => sig_Adr_Inst,
              New_Val_Inst => sig_New_Adr_Inst
            );
            
   New_Adr_Inst <= sig_New_Adr_Inst;
            
 -- Input Value for Program Counter        
inst_Mux_Register : Mux4_1
    generic map(Bit_Nber => 32)
    port map(
                In1    => sig_New_Adr_Inst, 
                In2    => sig_Val_Imm_adr,
                In3    => Jr_Adr,
                In4    => Jalr_Adr,
                sel    => sig_sel_PC_Mux,
                Output => sig_Val_Counter
             );      
             
  -- Adder Operator       
inst_Adder: Adder
    generic map(Bit_Nber => Bit_Nber)
    port map(
              Operand_1 => sig_Adr_Inst,
              Operand_2 => Val_Imm_Operand,
              Result    => sig_Val_Imm_adr
            );            
             
                    

end Behavioral;
