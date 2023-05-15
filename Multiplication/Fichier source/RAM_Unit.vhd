----------------------------------------------------------------------------------
-- Company: IMS
-- Engineer: Christophe JEGO
-- 
-- Create Date: 08.11.2021 09:11:51
-- Design Name: Processor RISC-V
-- Module Name: Mem_Unit - Behavioral
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
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-- 
--   Fonctionnement 4 bits pour le signal RW_Mem pour permmettre l'écriture par octects
--   La mémoire mémorise des données sur 32 bits mais écriture possible par octects
--   15 combinaisons possibles pour les écritures
--   si le signal RW="000" alors lecture des 32 bits mémorisés
-----------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM_Unit is 
    Generic(
           Bit_Nber    : INTEGER := 32; -- word size
           Memory_size : INTEGER := 6   -- 2**6 values
           );
    Port ( Clk     : in STD_LOGIC;
           --CE      : in STD_LOGIC;
           Ena_Mem : in STD_LOGIC;
           RW_Mem  : in STD_LOGIC_VECTOR  (3 downto 0);
           Adr     : in STD_LOGIC_VECTOR  ((Memory_size-3) downto 0);
           Val_In  : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_Out : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)        
         );
end RAM_Unit;

architecture Behavioral of RAM_Unit is

   subtype Word is STD_LOGIC_VECTOR((Bit_Nber-1) downto 0);
   type TAB is array (integer range 0 to ((2**(Memory_size-2)-1))) of Word;
   
   signal Mem : TAB;
   signal Val_tmp : Word := (others=> '0'); 
   
   constant  octet_null : STD_LOGIC_VECTOR (7 downto 0) := "00000000";    
            
begin
   
 RAM : process (Clk )
     begin  -- process RAM
       if (Clk'event and Clk='0') then
         --if (CE= '1')  then
               if (Ena_Mem='1') then 
                     case RW_Mem is
                       when "1111" => mem(TO_INTEGER(UNSIGNED(Adr))) <= Val_In;                               --write 32 bits
                       when "1110" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 8)  <= Val_In(31 downto 8);    --write 24 bits
                       when "1101" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 16) <= Val_In(31 downto 16);   --write 16 bits
                                      mem(TO_INTEGER(UNSIGNED(Adr)))(7 downto 0 )  <= Val_In(7 downto 0);     --write 8 bits
                       when "1100" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 16) <= Val_In(31 downto 16);   --write 16 bits
                       
                       when "1011" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 24) <= Val_In(31 downto 24);   --write 8 bits
                                      mem(TO_INTEGER(UNSIGNED(Adr)))(15 downto 0)  <= Val_In(15 downto 0);    --write 16 bits
                       when "1010" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 24) <= Val_In(31 downto 24);   --write 8 bits
                                      mem(TO_INTEGER(UNSIGNED(Adr)))(15 downto 8)  <= Val_In(15 downto 8);    --write 8 bits
                       when "1001" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 24) <= Val_In(31 downto 24);   --write 8 bits
                                      mem(TO_INTEGER(UNSIGNED(Adr)))(7 downto 0)   <= Val_In(7 downto 0);     --write 8 bits
                       when "1000" => mem(TO_INTEGER(UNSIGNED(Adr)))(31 downto 24) <= Val_In(31 downto 24);   --write 08 bits    
                                          
                       when "0111" => mem(TO_INTEGER(UNSIGNED(Adr)))(23 downto 0)  <= Val_In(23 downto 0);    --write 24 bits
                       when "0110" => mem(TO_INTEGER(UNSIGNED(Adr)))(23 downto 8)  <= Val_In(23 downto 8);    --write 16 bits
                       when "0101" => mem(TO_INTEGER(UNSIGNED(Adr)))(23 downto 16) <= Val_In(23 downto 16);   --write 8 bits
                                      mem(TO_INTEGER(UNSIGNED(Adr)))(7 downto 0)   <= Val_In(7 downto 0);     --write 8 bits
                       when "0100" => mem(TO_INTEGER(UNSIGNED(Adr)))(23 downto 16) <= Val_In(23 downto 16);   --write 08 bits         
                                 
                       when "0011" => mem(TO_INTEGER(UNSIGNED(Adr)))(15 downto 0) <= Val_In(15 downto 0);     --write 16 bits
                       when "0010" => mem(TO_INTEGER(UNSIGNED(Adr)))(15 downto 8) <= Val_In(15 downto 8);     --write 08 bits
                       when "0001" => mem(TO_INTEGER(UNSIGNED(Adr)))(7 downto 0)  <= Val_In(7 downto 0);      --write 08 bits
                       when others => Val_tmp  <= mem(TO_INTEGER(UNSIGNED(Adr)));                             --read 32 bits
                     end case;
               end if;       
        --end if;
      end if;
   end process RAM;
   
   Val_Out <= Val_tmp;

end Behavioral;
