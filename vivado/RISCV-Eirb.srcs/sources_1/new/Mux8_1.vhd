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

entity Mux8_1 is
    Generic(
           Bit_Nber : INTEGER := 1
           );
    Port ( In1    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In2    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In3    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In4    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In5    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In6    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In7    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In8    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           sel    : in   STD_LOGIC_VECTOR (2 downto 0);
           Output : out  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
end Mux8_1;

architecture Behavioral of Mux8_1 is

begin

Process(sel,In8,In7,In6,In5,In4,In3,In2,In1)

   Begin
	case sel is
          when "000" =>   Output <= In1;
          when "001" =>   Output <= In2;
          when "010" =>   Output <= In3;
          when "011" =>   Output <= In4;
          when "100" =>   Output <= In5;
          when "101" =>   Output <= In6;
          when "110" =>   Output <= In7;
          when others =>  Output <= In8;
    end case;	
end Process;


end Behavioral;

