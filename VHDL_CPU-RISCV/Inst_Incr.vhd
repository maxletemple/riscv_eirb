----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 15:25:44
-- Design Name: 
-- Module Name: Inst_Incr - Behavioral
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

entity Inst_Incr is
    Generic(
            Bit_Nber : integer := 32
            );
    Port ( Val_Inst     : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Load_plus4 : in STD_LOGIC;
           New_Val_Inst : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          );
end Inst_Incr;

architecture Behavioral of Inst_Incr is

--signal uns_Val_Inst     : unsigned((Bit_Nber-3) downto 0);
--signal uns_New_Val_Inst : unsigned((Bit_Nber-3) downto 0);

begin

-- The objective is to add 4. 
-- We can add 1 if we remove the 2 LSB bits of the current value
-- before the addition and then we consider "00" for the 2 LSB bits.

 
process(Val_Inst)
begin
    New_Val_Inst <= std_logic_vector(unsigned(Val_Inst) + to_unsigned(4,Bit_Nber));
end process;

end Behavioral;
