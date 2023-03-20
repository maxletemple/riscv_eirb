----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 10:01:57
-- Design Name: 
-- Module Name: Imm_Gen - Behavioral
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

entity Imm_Gen is
    Generic(
           Bit_Nber    : INTEGER := 32 -- word size
           );
    Port (Imm_Val     : in STD_LOGIC_VECTOR   (24 downto 0);
          imm_type    : in STD_LOGIC_VECTOR   (2 downto 0);
          Imm_Operand : out STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0)
    );
end Imm_Gen;

architecture Behavioral of Imm_Gen is
signal S_imm_Operand : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
begin

PROCESS(Imm_Val,imm_type )
BEGIN
CASE imm_type IS
    WHEN "000" => S_imm_Operand<= (others=>'0'); -- R_Type
    WHEN "001" => S_imm_Operand <= 
    Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)&Imm_Val(24)& Imm_Val(24 downto 13); -- I_Type check
    --faire pareil              
                  
    WHEN "010" =>  S_imm_Operand<=    Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)&Imm_Val(24 downto 18) & Imm_Val(4 downto 0); -- S_Type -----------a finirrrrrrrrrrrrrrr lien sur drive 
                   
                  
                  
    WHEN "011" =>  S_imm_Operand<=  Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24) & Imm_Val(0)& Imm_Val(23 downto 18) & Imm_Val(4 downto 1) & '0'; -- b_Type 
                  
    --WHEN "100" =>  S_imm_Operand<=  Imm_Val(24 downto 5) &  Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24); -- u_Type
    WHEN "100" =>  S_imm_Operand<=  Imm_Val(24 downto 5) & std_logic_vector(to_unsigned(0,12)); -- u_Type
             
                  
    WHEN "101" =>   S_imm_Operand<=   Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(24)& Imm_Val(12 downto 5)& Imm_Val(13) & Imm_Val(23 downto 14)& '0';-- j_Type
                   
    WHEN others => S_imm_Operand<= (others=>'0');
END CASE;
END PROCESS;

Imm_Operand <= std_logic_vector(S_imm_Operand);
end Behavioral;
