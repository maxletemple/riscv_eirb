----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2021 09:09:52
-- Design Name: 
-- Module Name: Program_Counter - Behavioral
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

entity Inst_Register is
    Generic(
            Bit_Nber         : integer := 32
            );
    Port  ( Clk              : in STD_LOGIC;
            Reset            : in STD_LOGIC;
            CE               : in STD_LOGIC;
            init_counter     : in STD_LOGIC;
            Val_Counter      : in  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
            Adr_Inst         : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          );
end Inst_Register;

architecture Behavioral of Inst_Register is

signal s_addr : std_logic_vector((Bit_nber-1) downto 0);

begin

process(clk, Reset)
begin
    if Reset = '1' then
        --Adr_Inst <= x"00000000";
        Adr_Inst <= (others=>'0');
    elsif rising_edge(clk) then
        if CE = '1' then
            if init_counter = '1' then
                Adr_Inst <= Val_Counter;
            end if;
        end if;
    end if;
end process;

end Behavioral;
