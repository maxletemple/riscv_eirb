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
-- 
--   Attention pour l'addressage du bloc mémoire, nous gardons seulement 
--   Memory_size bits parmi les Bit_Nber bits
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.ram_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mem_Unit is
    Generic(
           Bit_Nber     : INTEGER := 32; -- word size
           Memory_size  : INTEGER -- := 6   -- 2**6 values
           );
    Port ( Clk          : in STD_LOGIC;
           --CE         : in STD_LOGIC;
           Boot         : in STD_LOGIC;           
           Ena_CPU      : in STD_LOGIC;
           RW_Boot      : in STD_LOGIC;
           RW_CPU       : in STD_LOGIC_VECTOR  (3 downto 0);
           Adr_Boot     : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Adr_CPU      : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);
           Val_In_CPU   : in STD_LOGIC_VECTOR  ((Bit_Nber-1)downto 0);
           Val_Out_CPU  : out STD_LOGIC_VECTOR ((Bit_Nber-1)downto 0);
           Val_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0)
                  
         );
end Mem_Unit;

architecture Behavioral of Mem_Unit is

component RAM_Unit is 
    Generic(
           Bit_Nber    : INTEGER := Bit_Nber;   -- word size
           Memory_size : INTEGER := Memory_size -- 2**Memory_size values
           );
    Port ( Clk     : in STD_LOGIC;
           --CE      : in STD_LOGIC;
           Ena_Mem : in STD_LOGIC;
           RW_Mem  : in STD_LOGIC_VECTOR  (3 downto 0);
           Adr     : in STD_LOGIC_VECTOR  ((Memory_size-3) downto 0);
           Val_In  : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_Out : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)        
         );
end component;

component RAM_Unit_Xilinx is
 generic (
 NB_COL : integer;
 COL_WIDTH : integer;
 RAM_DEPTH : integer
 --RAM_PERFORMANCE : string
 --INIT_FILE : string
);
port
(
 addra : in std_logic_vector((clogb2(RAM_DEPTH)-1) downto 0);
 dina  : in std_logic_vector(NB_COL*COL_WIDTH-1 downto 0);
 clka  : in std_logic;
 wea   : in std_logic_vector(NB_COL-1 downto 0);  
 ena   : in std_logic;
 --rsta  : in std_logic;
 --regcea: in std_logic;
 douta : out std_logic_vector(NB_COL*COL_WIDTH-1 downto 0)
);
end component;

 component Mux_Boot_Loader is
    Generic(
           Bit_Nber : INTEGER := Bit_Nber
           );
    Port ( Boot     : in STD_LOGIC;  
           Ena_CPU  : in STD_LOGIC;
           Ena_Mem  : out STD_LOGIC;
           RW_CPU   : in STD_LOGIC_VECTOR(3 downto 0);
           RW_Boot  : in STD_LOGIC;
           RW_Mem   : out STD_LOGIC_VECTOR(3 downto 0);
 
           Adr_Boot    : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Adr_CPU     : in STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Adr_Mem     : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
   
           Val_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);
           Val_In_CPU   : in STD_LOGIC_VECTOR  ((Bit_Nber-1)downto 0);
           Val_In_Mem   : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0)
          );
 end component;

component DatatToBootLoader is
    Generic(
           Bit_Nber : INTEGER := Bit_Nber
           );
    Port ( Boot      : in STD_LOGIC;
           RW_Boot   : in STD_LOGIC;
           Adr_Boot  : in STD_LOGIC_VECTOR  (1 downto 0);
           Val_In    : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_Out   : out STD_LOGIC_VECTOR ((8-1) downto 0)
         );
 end component;
 
signal sig_Ena_Mem     : STD_LOGIC; 
signal sig_RW_Mem      : STD_LOGIC_VECTOR(3 downto 0);
signal sig_Adr_Mem     : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Val_In_Mem  : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
signal sig_Val_Out_Mem : STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);

--constant sig_rsta      : STD_LOGIC :='0';  
--constant sig_regcea    : STD_LOGIC :='1';  
            
begin

-- Mux_Boot_Loader for RAM Memory 
inst_Mux_Boot_Loader_Inst : Mux_Boot_Loader
    generic map(Bit_Nber => Bit_Nber)
    port map(
                Boot        => Boot, 
                Ena_CPU     => Ena_CPU,
                Ena_Mem     => sig_Ena_Mem,
                RW_CPU      => RW_CPU,
                RW_Boot     => RW_Boot,
                RW_Mem      => sig_RW_Mem,
                Adr_Boot    => Adr_Boot,
                Adr_CPU     => Adr_CPU,
                Adr_Mem     => sig_Adr_Mem,
                Val_In_boot => Val_In_boot,
                Val_In_CPU  => Val_In_CPU,
                Val_In_Mem  => sig_Val_In_Mem
             );  

--Inst_RAM_Unit : RAM_Unit
--    generic map(
--                  Bit_Nber    => Bit_Nber,    -- Octets
--                  Memory_size => Memory_size  --2**Memory_size values
--                )
--    port map(
--              Clk     => Clk,
--              --CE    => CE,
--              Ena_Mem => sig_Ena_Mem,
--              RW_Mem  => sig_RW_Mem,
--              Adr     => sig_Adr_Mem((Memory_size-1) downto 2),
--              Val_In  => sig_Val_In_Mem,
--              Val_Out => sig_Val_Out_Mem
--             );   
             
 Inst_RAM_Unit : RAM_Unit_Xilinx
 generic map (
       NB_COL => 4,
       COL_WIDTH => 8,
       RAM_DEPTH => 2**(Memory_size-2)
       --RAM_PERFORMANCE => "LOW_LATENCY"
       --INIT_FILE => "" 
                 )
  port map  
  (
        --addra  => sig_Adr_Mem,
        addra  => sig_Adr_Mem((Memory_size-1) downto 2),
        dina   => sig_Val_In_Mem,
        clka   => Clk,
        wea    => sig_RW_Mem,
        ena    => sig_Ena_Mem,
        --rsta   => sig_rsta,
        --regcea => sig_regcea,
        douta  => sig_Val_Out_Mem
   );               
             
Val_Out_CPU <= sig_Val_Out_Mem;
             
Inst_Conv : DatatToBootLoader 
    generic map(Bit_Nber => Bit_Nber)
    port map( Boot     => Boot, 
              RW_Boot  => RW_Boot,
              Adr_Boot => Adr_Boot(1 downto 0),
              Val_In   => sig_Val_Out_Mem,
              Val_Out  => Val_Out_Boot
             );    

end Behavioral;
