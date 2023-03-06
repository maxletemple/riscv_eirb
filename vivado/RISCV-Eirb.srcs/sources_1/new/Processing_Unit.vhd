----------------------------------------------------------------------------------
-- Company: IMS
-- Engineer: Christophe JEGO
-- 
-- Create Date: 08.11.2021 09:29:11
-- Design Name: Processor RISC-V
-- Module Name: Processing_Unit - Behavioral
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

entity Processing_Unit is
    Generic(
           Bit_Nber : INTEGER := 32
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           Val_Mem_Inst     : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_Mem_Data     : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           New_Adr_Inst     : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           
           sel_func_ALU         : in STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : in STD_LOGIC;
           imm_type             : in STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : in STD_LOGIC;
           sel_result           : in STD_LOGIC_VECTOR (1 downto 0);
           sel_func_ALU_connect : in STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : out STD_LOGIC;
           
           Val_UT_Adr       : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_UT_Data      : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_Imm_Operand  : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Jalr_Adr         : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Jr_Adr           : out STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0)
         );
end Processing_Unit;

architecture Behavioral of Processing_Unit is

component ALU is
    Generic(
           Bit_Nber    : INTEGER := 32 -- word size
           );
    Port ( sel_func_ALU         : in STD_LOGIC_VECTOR (3 downto 0);
           sel_func_ALU_connect : in STD_LOGIC_VECTOR (2 downto 0);
           Operand1             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Operand2             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Result               : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_connect          : out STD_LOGIC
          );
end component;

component Register_File is
    Generic(
           Bit_Nber    : INTEGER := 32; -- word size
           Bit_Adr     : INTEGER := 5   -- Number bits for adresses
           );
    Port ( Clk            : in STD_LOGIC;
           Reset          : in STD_LOGIC;
           CE             : in STD_LOGIC;
           reg_file_write : in STD_LOGIC;
           Read_Adr1  : in STD_LOGIC_VECTOR ((Bit_Adr-1) downto 0);
           Read_Adr2  : in STD_LOGIC_VECTOR ((Bit_Adr-1) downto 0);
           Write_Adr  : in STD_LOGIC_VECTOR ((Bit_Adr-1) downto 0);
           Data_Read1 : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Data_Read2 : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Data_Write : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
end component;

component  Imm_Gen is
    Generic(
           Bit_Nber    : INTEGER := 32 -- word size
           );
    Port (Imm_Val     : in STD_LOGIC_VECTOR   (24 downto 0);
          imm_type    : in STD_LOGIC_VECTOR   (2 downto 0);
          Imm_Operand : out STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0)
    );
end component;

component Mux2_1 is
    Generic(
           Bit_Nber : integer := Bit_Nber 
           );
    Port ( In1    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In2    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           sel    : in   STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
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

signal sig_Operand1       : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Operand2       : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Operand2_Mux   : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Result         : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Reg_Data_Write : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Imm_Operand    : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);

constant zero : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0):= (others =>'0');

begin

 -- Arithmetic and Logical Unit        
inst_ALU : ALU
    generic map(Bit_Nber => Bit_Nber)
    port map( 
              sel_func_ALU         => sel_func_ALU,
              sel_func_ALU_connect => sel_func_ALU_connect,
              Operand1             => sig_Operand1,
              Operand2             => sig_Operand2,
              Result               => sig_Result,
              Val_connect          => Val_connect
            );
            
 Val_UT_Adr  <= sig_Result;  
 Jalr_Adr    <= sig_Result; 
 Jr_Adr      <= sig_Operand1;   
 
-- Register File       
inst_Register_File : Register_File
    generic map(Bit_Nber => Bit_Nber,
                Bit_Adr  => 5
               )
    port map(
              Clk            => Clk,
              Reset          => Reset,
              CE             => CE,
              reg_file_write => reg_file_write,
              Read_Adr1      => Val_Mem_Inst(19 downto 15),
              Read_Adr2      => Val_Mem_Inst(24 downto 20),
              Write_Adr      => Val_Mem_Inst(11 downto 7),
              Data_Read1     => sig_Operand1,
              Data_Read2     => sig_Operand2_Mux,
              Data_Write     => sig_Reg_Data_Write 
            );    
            
  Val_UT_Data <= sig_Operand2_Mux;          
            
-- Immediat Generation       
inst_Imm_Gen : Imm_Gen
    generic map(Bit_Nber => Bit_Nber)
    port map( 
               Imm_Val     => Val_Mem_Inst(31 downto 7),
               imm_type    => imm_type,
               Imm_Operand => sig_Imm_Operand
            );      
            
 Val_Imm_Operand <= sig_Imm_Operand;           
            
-- Mux Operand2 ALU            
inst_Mux_Operand2 : Mux2_1
    generic map(Bit_Nber => 32)
    port map(
                In1    => sig_Operand2_Mux, 
                In2    => sig_Imm_Operand,
                sel    => sel_op2,
                Output => sig_Operand2
             );                

-- Mux Resut ALU            
inst_Mux_Result : Mux4_1
    generic map(Bit_Nber => 32)
    port map(
                In1    => New_Adr_Inst, 
                In2    => sig_Result, 
                In3    => Val_Mem_Data,
                In4    => zero,
                sel    => sel_result,
                Output => sig_Reg_Data_Write 
             );    
             

end Behavioral;
