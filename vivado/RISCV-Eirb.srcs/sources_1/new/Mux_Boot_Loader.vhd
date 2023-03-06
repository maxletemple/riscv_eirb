----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2021 16:21:53
-- Design Name: 
-- Module Name: Mux_Boot_Loader - Behavioral
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

entity Mux_Boot_Loader is
    Generic(
           Bit_Nber : INTEGER := 32
           );
    Port ( Boot     : in STD_LOGIC;  
           Ena_CPU  : in STD_LOGIC;
           Ena_Mem  : out STD_LOGIC;
           RW_CPU   : in STD_LOGIC_VECTOR (3 downto 0);
           RW_Boot  : in STD_LOGIC; 
           RW_Mem   : out STD_LOGIC_VECTOR (3 downto 0);
 
           Adr_Boot    : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Adr_CPU     : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Adr_Mem     : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
   
           Val_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);
           Val_In_CPU   : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_In_Mem   : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          );
end Mux_Boot_Loader;

architecture Behavioral of Mux_Boot_Loader is

 component Mux2_1 is
    Generic(
           Bit_Nber : integer := Bit_Nber 
           );
    Port ( In1    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           In2    : in   STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           sel    : in   STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
           );
 end component;
 
 signal sig_Boot     : STD_LOGIC_VECTOR (0 downto 0);  
 signal sig_Ena_CPU  : STD_LOGIC_VECTOR (0 downto 0); 
 signal sig_Ena_Mem  : STD_LOGIC_VECTOR (0 downto 0);
 
 signal sig_RW_CPU   : STD_LOGIC_VECTOR (3 downto 0);  
 signal sig_RW_Boot  : STD_LOGIC_VECTOR (3 downto 0); 
 signal sig_RW_Mem   : STD_LOGIC_VECTOR (3 downto 0); 
 
 signal sig_Adr_Boot    : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Adr_CPU     : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Adr_Mem     : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
   
 signal sig_Val_In_boot  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Val_In_CPU   : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 signal sig_Val_In_Mem   : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
 
 constant  octet_null : STD_LOGIC_VECTOR (7 downto 0) := "00000000";  

begin

 sig_Boot(0)    <= Boot;
 sig_Ena_CPU(0) <= Ena_CPU;
 Ena_Mem        <= sig_Ena_Mem(0);
 sig_RW_CPU     <= RW_CPU;
 RW_Mem         <= sig_RW_Mem;
 
 sig_Adr_CPU    <= Adr_CPU;
 Adr_Mem        <= sig_Adr_Mem;
 
 sig_Val_In_CPU  <= Val_In_CPU;
 Val_In_Mem      <= sig_Val_In_Mem;
 
-- Memory 32 bits gestion for Boot
 Process(Adr_Boot,RW_Boot,Boot,Val_In_boot)
  begin
    if (Boot='1') then 
       if (RW_Boot ='1') then 
        case (Adr_Boot(1 downto 0)) is
           when "11"   => sig_RW_Boot<="1000";
                          sig_Val_In_boot <= Val_In_boot&octet_null&octet_null&octet_null;
           when "10"   => sig_RW_Boot<="0100";
                          sig_Val_In_boot <= octet_null&Val_In_boot&octet_null&octet_null;
           when "01"   => sig_RW_Boot<="0010";
                          sig_Val_In_boot <= octet_null&octet_null&Val_In_boot&octet_null;
           when others => sig_RW_Boot<="0001";
                          sig_Val_In_boot <= octet_null&octet_null&octet_null&Val_In_boot;
        end case;
         sig_Adr_Boot   <= Adr_Boot((Bit_Nber-1) downto 2)&"00";
      else
        case (Adr_Boot(1 downto 0)) is
           when "11"   => sig_RW_Boot<="0000";
                          sig_Val_In_boot <= octet_null&octet_null&octet_null&octet_null;
           when "10"   => sig_RW_Boot<="0000";
                          sig_Val_In_boot <= octet_null&octet_null&octet_null&octet_null;
           when "01"   => sig_RW_Boot<="0000";
                          sig_Val_In_boot <= octet_null&octet_null&octet_null&octet_null;
           when others => sig_RW_Boot<="0000";
                          sig_Val_In_boot <= octet_null&octet_null&octet_null&octet_null;
        end case;
         sig_Adr_Boot   <= Adr_Boot((Bit_Nber-1) downto 2)&"00";
      end if;
   else
      sig_RW_Boot     <="0000";
      sig_Val_In_boot <= octet_null&octet_null&octet_null&octet_null;
      sig_Adr_Boot    <= octet_null&octet_null&octet_null&octet_null;
   end if;
 End process;
 
 
-- Mux Enable_Data             
inst_Mux_Ena_Data : Mux2_1
    generic map(Bit_Nber => 1)
    port map(
                In1    => sig_Ena_CPU, 
                In2    => sig_Boot,
                sel    => Boot,
                Output => sig_Ena_Mem
             );   
                 
-- Mux RW_Data
inst_Mux_RW_Data : Mux2_1
    generic map(Bit_Nber => 4)
    port map(
                In1    => sig_RW_CPU, 
                In2    => sig_RW_Boot,
                sel    => Boot,
                Output => sig_RW_Mem
             );   
                    
-- Mux Adr_Data
inst_Mux_Adr_Data : Mux2_1
    generic map(Bit_Nber => Bit_Nber)
    port map(
                In1    => sig_Adr_CPU, 
                In2    => sig_Adr_Boot,
                sel    => Boot,
                Output => sig_Adr_Mem
             );                         
             
-- Mux Val_Data
inst_Mux_Val_Data : Mux2_1
    generic map(Bit_Nber => Bit_Nber)
    port map(
                In1    => sig_Val_In_CPU, 
                In2    => sig_Val_In_Boot,
                sel    => Boot,
                Output => sig_Val_In_Mem
             );  

end Behavioral;
