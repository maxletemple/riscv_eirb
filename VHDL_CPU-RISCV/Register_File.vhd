----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 09:30:41
-- Design Name: 
-- Module Name: Register_File - Behavioral
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

entity Register_File is
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
           Data_Write : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Data_Read1 : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Data_Read2 : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          
           );
end Register_File;

architecture Behavioral of Register_File is
type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
signal registers : registerFile;
begin
    Data_Read1 <= registers(to_integer(unsigned(Read_Adr1)));
    Data_Read2 <= registers(to_integer(unsigned(Read_Adr2))); 
    regFile : process(Clk, Reset)
        begin
                if Reset = '1' then 
--                     registers(0) <= (others=>'0');
--                     --registers(1) <= STD_LOGIC_VECTOR(to_unsigned(2147483647,32));
--                     --registers(2) <= STD_LOGIC_VECTOR(to_unsigned(2147483647,32));
--                     registers(1) <= X"00000000";
--                     registers(2) <= X"00000000";
                    for i in 0 to 31 loop
                        registers(i) <= (others=>'0');
                    end loop;
                     
                elsif Clk'event and Clk='1' then 
                  if CE = '1' then 
                        if reg_file_write = '1' then
                            registers(to_integer(unsigned(Write_Adr))) <= Data_Write;
                        end if; 
                  end if;
               end if;
        end process;                             
end Behavioral;
