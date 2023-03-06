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
           Bit_Nber         : integer := 31
           );
    Port ( Clk              : in STD_LOGIC;
           Reset            : in STD_LOGIC;
           CE               : in STD_LOGIC;
           Val_Inst         : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           
           Ena_Mem_Inst         : out STD_LOGIC;
           Ena_Mem_Data         : out STD_LOGIC;
           RW_Mem_Data          : out STD_LOGIC_VECTOR (3 downto 0);
           
           sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
           reg_file_write       : out STD_LOGIC;
           imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
           sel_op2              : out STD_LOGIC;
           sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
           RW_UT_Data           : out STD_LOGIC;
           sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
           Val_connect          : in STD_LOGIC;
           
           init_counter         : out STD_LOGIC;
           sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0);
           Load_plus4           : out STD_LOGIC
           );
end FSM;

architecture Behavioral of FSM is

type state_type is (Init, FetchIns, Decode, FetchOperand, Exe, Store);
signal current_state, next_state : state_type;

begin


end Behavioral;
