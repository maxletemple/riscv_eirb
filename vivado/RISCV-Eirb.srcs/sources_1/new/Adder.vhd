----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 14:51:03
-- Design Name: 
-- Module Name: Adder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Adder is
    Generic(
           Bit_Nber : integer := 32
           );
    Port (  Operand_1 : in  STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
            Operand_2 : in  STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
            Result    : out STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0)
          );
end Adder;

architecture Behavioral of Adder is

--signal op1, op2 : signed((Bit_Nber-1) downto 0);

begin

--op1 <= signed(Operand_1);
--op2 <= signed(Operand_2);
 
Result <= std_logic_vector(signed(Operand_1) + signed(Operand_2));

end Behavioral;
