----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2021 08:09:34
-- Design Name: 
-- Module Name: DatatToBootLoader - Behavioral
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

entity DatatToBootLoader is
    Generic(
           Bit_Nber : INTEGER := 32
           );
    Port ( Boot      : in STD_LOGIC;
           RW_Boot   : in STD_LOGIC;
           Adr_Boot  : in STD_LOGIC_VECTOR  (1 downto 0);
           Val_In    : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_Out   : out STD_LOGIC_VECTOR ((8-1) downto 0)
         );
end DatatToBootLoader;

architecture Behavioral of DatatToBootLoader is

constant  octet_null : STD_LOGIC_VECTOR (7 downto 0) := "00000000";  

begin

Read_Ins : Process (Adr_Boot, RW_Boot, Boot, Val_In)
  begin
    if (Boot='1') then 
       if (RW_Boot ='0') then 
        case (Adr_Boot) is
           when "11"   => Val_Out <= Val_In(7 downto 0);
           when "10"   => Val_Out <= Val_In(15 downto 8);
           when "01"   => Val_Out <= Val_In(23 downto 16);
           when others => Val_Out <= Val_In(31 downto 24);
--           when "11"   => Val_Out <= Val_In(31 downto 24);
--           when "10"   => Val_Out <= Val_In(23 downto 16);
--           when "01"   => Val_Out <= Val_In(15 downto 8);
--           when others => Val_Out <= Val_In(7 downto 0);
        end case;
       else
          Val_Out <= octet_null;
       end if;
    else 
       Val_Out <= octet_null;
    end if;
end Process;

end Behavioral;
