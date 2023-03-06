----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 09:38:50
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
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
end ALU;

architecture Behavioral of ALU is

begin


end Behavioral;
