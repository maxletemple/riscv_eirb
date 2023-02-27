----------------------------------------------------------------------------------
-- Company: IMS
-- Engineer: Christophe JEGO
-- 
-- Create Date: 08.11.2021 08:50:22
-- Design Name: Processor RISC-V
-- Module Name: CPU_RISC-V - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: il manque transparent 32
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

entity CPU_RISCV is
    Generic(
           Bit_Nber    : INTEGER    := 32;
           Memory_size : INTEGER    := 6 -- 2**8 values
           );
    Port ( Clk               : in STD_LOGIC;
           Reset             : in STD_LOGIC;
           CE                : in STD_LOGIC;
           Inst_Boot         : in STD_LOGIC;
           Data_Boot         : in STD_LOGIC;
           Inst_RW_Boot      : in STD_LOGIC;
           Data_RW_Boot      : in STD_LOGIC;
           Adr_Inst_boot     : in STD_LOGIC_VECTOR  ((Bit_Nber -1) downto 0);
           Adr_Data_boot     : in STD_LOGIC_VECTOR  ((Bit_Nber -1) downto 0);
           Val_Inst_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);
           Val_Data_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);           
           Val_Inst_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0);           
           Val_Data_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0)
           );
end CPU_RISCV;

architecture Behavioral of CPU_RISCV is

component Mem_Unit is
    Generic(
           Bit_Nber    : INTEGER := Bit_Nber;    -- word size
           Memory_size : INTEGER := Memory_size  -- 2**8 values
           );
    Port ( Clk         : in STD_LOGIC;
           --CE        : in STD_LOGIC;
           Boot        : in STD_LOGIC;                    
           Ena_CPU     : in STD_LOGIC;
           RW_Boot     : in STD_LOGIC;
           RW_CPU      : in STD_LOGIC_VECTOR   (3 downto 0);
           Adr_Boot    : in STD_LOGIC_VECTOR   ((Bit_Nber-1) downto 0);
           Adr_CPU     : in STD_LOGIC_VECTOR   ((Bit_Nber-1) downto 0);
           Val_In_boot : in STD_LOGIC_VECTOR   ((8-1) downto 0);
           Val_In_CPU  : in STD_LOGIC_VECTOR   ((Bit_Nber-1)downto 0);
           Val_Out_CPU  : out STD_LOGIC_VECTOR ((Bit_Nber-1)downto 0);
           Val_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0)             
         );
 end component;
 
 component Control_Unit is
    Generic(
           Bit_Nber : integer := Bit_Nber
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           boot             : in std_logic;
           Val_Inst         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Jalr_Adr         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0); 
           Jr_Adr           : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0); 
           Val_Imm_Operand  : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
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
 end component;
 
 component Processing_Unit is
    Generic(
           Bit_Nber : INTEGER := Bit_Nber
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
 end component;
 
 signal   sig_Ena_Mem_Inst  : STD_LOGIC; 
 constant sig_RW_Mem_Inst   : STD_LOGIC_VECTOR (3 downto 0):="0000";
 signal   sig_Adr_Mem_Inst  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 constant sig_Val_In_Inst   : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0):= (others => '0');
 signal   sig_Val_Out_Inst  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 
 signal   sig_Ena_Mem_Data  : STD_LOGIC; 
 signal   sig_RW_Mem_Data   : STD_LOGIC_VECTOR (3 downto 0);
 signal   sig_Adr_Mem_Data  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal   sig_Val_In_Data   : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal   sig_Val_Out_Data  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 
 signal   sig_Jalr_Adr             : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0); 
 signal   sig_Jr_Adr               : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0); 
 signal   sig_Val_Imm_Operand      : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0); 
 signal   sig_sel_func_ALU         : STD_LOGIC_VECTOR (3 downto 0); 
 signal   sig_reg_file_write       : STD_LOGIC;
 signal   sig_imm_type             : STD_LOGIC_VECTOR (2 downto 0);
 signal   sig_sel_op2              : STD_LOGIC;
 signal   sig_sel_result           : STD_LOGIC_VECTOR (1 downto 0);
 signal   sig_sel_func_ALU_connect : STD_LOGIC_VECTOR (2 downto 0);
 signal   sig_Val_connect          : STD_LOGIC;
 signal   sig_New_Adr_Inst         : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0); 

begin

-- Instrustion Memory CPU
Inst_Mem_Unit_Inst : Mem_Unit
    generic map(
                  Bit_Nber    => Bit_Nber,   -- 
                  Memory_size => Memory_size --2**Memory_size values
                )
    port map(
              Clk          => Clk,
              --CE         => CE,
              Boot         => Inst_Boot,         
              Ena_CPU      => sig_Ena_Mem_Inst,
              RW_Boot      => Inst_RW_Boot, 
              RW_CPU       => sig_RW_Mem_Inst,
              Adr_Boot     => Adr_Inst_boot,
              Adr_CPU      => sig_Adr_Mem_Inst,
              Val_In_boot  => Val_Inst_In_boot,
              Val_In_CPU   => sig_Val_In_Inst,
              Val_Out_CPU  => sig_Val_Out_Inst, 
              Val_Out_Boot => Val_Inst_Out_Boot
             );                       
              
 -- Data Memory CPU
Inst_Mem_Unit_Data : Mem_Unit
    generic map(
                  Bit_Nber    => Bit_Nber,   -- 
                  Memory_size => Memory_size --2**Memory_size values
                )
    port map(
              Clk          => Clk,
              --CE         => CE,
              Boot         => Data_Boot,         
              Ena_CPU      => sig_Ena_Mem_Data,
              RW_Boot      => Data_RW_Boot, 
              RW_CPU       => sig_RW_Mem_Data,
              Adr_Boot     => Adr_Data_boot,
              Adr_CPU      => sig_Adr_Mem_Data,
              Val_In_boot  => Val_Data_In_boot,
              Val_In_CPU   => sig_Val_In_Data,
              Val_Out_CPU  => sig_Val_Out_Data, 
              Val_Out_Boot => Val_Data_Out_Boot
             );                               
             
----Control Unit
Inst_Control_Unit : Control_Unit
    generic map(
                  Bit_Nber    => Bit_Nber
                )
    port map(
              Clk               => Clk,
              Reset             => Reset,
              CE                => CE,
              boot              => Inst_Boot,
              Val_Inst          => sig_Val_Out_Inst,
              Jalr_Adr          => sig_Jalr_Adr,
              Jr_Adr            => sig_Jr_Adr,
              Val_Imm_Operand   => sig_Val_Imm_Operand,
              Adr_Inst          => sig_Adr_Mem_Inst,
              New_Adr_Inst      => sig_New_Adr_Inst,
              Ena_Mem_Inst      => sig_Ena_Mem_Inst,
              Ena_Mem_Data      => sig_Ena_Mem_Data,
              RW_Mem_Data       => open, --sig_RW_Mem_Data,
              
              sel_func_ALU         => sig_sel_func_ALU,
              reg_file_write       => sig_reg_file_write,
              imm_type             => sig_imm_type,
              sel_op2              => sig_sel_op2,
              sel_result           => sig_sel_result,
              sel_func_ALU_connect => sig_sel_func_ALU_connect,
              Val_connect          => sig_Val_connect
             );   
             
----Processing Unit
Inst_Processing_Unit : Processing_Unit
    generic map(
                  Bit_Nber    => Bit_Nber
                )
    port map(
              Clk               => Clk,
              Reset             => Reset,
              CE                => CE,             
              Val_Mem_Inst      => sig_Val_Out_Inst,
              Val_Mem_Data      => sig_Val_Out_Data,
              New_Adr_Inst      => sig_New_Adr_Inst,
              
              sel_func_ALU         => sig_sel_func_ALU,
              reg_file_write       => sig_reg_file_write,
              imm_type             => sig_imm_type,
              sel_op2              => sig_sel_op2,
              sel_result           => sig_sel_result,
              sel_func_ALU_connect => sig_sel_func_ALU_connect,
              Val_connect          => sig_Val_connect,
              
              Val_UT_Adr        => sig_Adr_Mem_Data,
              Val_UT_Data       => sig_Val_In_Data,  
              Val_Imm_Operand   => sig_Val_Imm_Operand,        
              Jalr_Adr          => sig_Jalr_Adr,
              Jr_Adr            => sig_Jr_Adr
             );                

end Behavioral;
