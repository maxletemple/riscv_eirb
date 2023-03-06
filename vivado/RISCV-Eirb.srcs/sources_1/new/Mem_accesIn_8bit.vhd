----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2021 16:38:11
-- Design Name: 
-- Module Name: Mem_acces_8bit - Behavioral
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

entity Mem_accesIn_8bit is
    Generic(
           Bit_Nber : integer := 32
           );
    Port ( Clk              : in  STD_LOGIC;
           Reset            : in  STD_LOGIC;
           CE               : in  STD_LOGIC; 
           Val_adr_in       : in  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_adr_out      : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);     
           Val_data_in      : in  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);          
           Val_data_out     : out STD_LOGIC_VECTOR ((8-1) downto 0)
          );
end Mem_accesIn_8bit;

architecture Behavioral of Mem_accesIn_8bit is

signal val_cpt : unsigned(1 downto 0);
signal result  : std_logic_vector(1 downto 0); 

begin

cpt4 : Process (Clk, Reset)
   begin
      if (Reset='1') then
             val_cpt <= to_unsigned(0,2);
      elsif Clk'event and Clk='1' then
         if (CE='1') then
             val_cpt <= val_cpt + to_unsigned(1,2);
         end if; 
       end if;  
   end Process cpt4;
   
result <= std_logic_vector(val_cpt);           
Val_adr_out <= Val_adr_in((Bit_Nber-1) downto 2)&result;  

      
mux4 : Process (result , Val_data_in)
    begin
       case result is
          when "00"   => Val_data_out <= Val_data_in(7  downto 0);
          when "01"   => Val_data_out <= Val_data_in(15 downto 8); 
          when "10"   => Val_data_out <= Val_data_in(23 downto 16); 
          when others => Val_data_out <= Val_data_in(31 downto 24); 
       end case;   
    end Process mux4; 

end Behavioral;
