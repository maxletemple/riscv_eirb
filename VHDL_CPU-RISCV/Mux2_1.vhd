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
-- Additional Comments:
-- 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux2_1 is
    Generic(
           Bit_Nber : INTEGER := 1
           );
    Port ( In1    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In2    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           sel    : in   STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
end Mux2_1;

architecture Behavioral of Mux2_1 is

begin

Process(sel,In2,In1)

   Begin
    
    if sel='1' then
      Output <= In2;
    else
      Output <= In1;
   end if;
    
end Process;


end Behavioral;

