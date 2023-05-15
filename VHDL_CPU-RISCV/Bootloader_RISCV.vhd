library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CPU_Bootloader is
    Generic(
       Bit_Nber              : INTEGER := 32;  
       Memory_size           : INTEGER := 10;   --! 2**5= 32 Values
       UART_recv_FIFO_Size   : INTEGER := 128;   
       UART_recv_FIFO_Almost : INTEGER := 64  
       );
    Port ( Clk_100        : in  STD_LOGIC;
           Reset          : in  STD_LOGIC;
           CE             : in  STD_LOGIC;
           Scan_Mem       : in  STD_LOGIC; --! Memory ready
           Rx             : in  STD_LOGIC;
           Tx             : out STD_LOGIC;
           --AN           : out STD_LOGIC_VECTOR (7 downto 0);
          --Sevenseg      : out STD_LOGIC_VECTOR (7 downto 0);
           LED            : out STD_LOGIC_VECTOR (3 downto 0)
         );
end CPU_Bootloader;

architecture Behavioral of CPU_Bootloader is

component CPU_RISCV is
    Generic(
           Bit_Nber    : INTEGER := Bit_Nber ;
           Memory_size : INTEGER := Memory_size
           );
    Port ( Clk               : in STD_LOGIC;
           Reset             : in STD_LOGIC;
           CE                : in STD_LOGIC;
           boot              : in STD_LOGIC;
           Inst_Boot         : in STD_LOGIC;
           Data_Boot         : in STD_LOGIC;
           Inst_RW_Boot      : in STD_LOGIC;
           Data_RW_Boot      : in STD_LOGIC;
           Adr_Inst_boot     : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Adr_Data_boot     : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Val_Inst_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);
           Val_Data_In_boot  : in STD_LOGIC_VECTOR  ((8-1) downto 0);           
           Val_Inst_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0);           
           Val_Data_Out_Boot : out STD_LOGIC_VECTOR ((8-1) downto 0)
           );
end component;

component boot_loader is
    Generic(
               Bit_Nber              : INTEGER := 32 ;
               Memory_size           : INTEGER := 6 ;   --! 2**5= 32 Values
               UART_recv_FIFO_Size   : INTEGER := 128;   
               UART_recv_FIFO_Almost : INTEGER := 64  
          );
    Port (  rst         : in  std_logic;
            clk         : in  std_logic;
            ce          : in  std_logic;
            rx          : in  std_logic;
            tx          : out std_logic;
            boot        : out std_logic;
            scan_memory : in  std_logic;
            ram_out     : in  std_logic_vector((8-1) downto 0);
            ram_rw      : out std_logic;
            ram_adr     : out std_logic_vector((Memory_size-1) downto 0);
            ram_in      : out std_logic_vector((8-1) downto 0));
end component;

--component clk_wiz_0 is
--     Port ( 
--     clk_in1  : in  std_logic;
--     clk_out1 : out  std_logic
--     );
--     end component;

signal clk                    : std_logic;
signal sig_Boot               : std_logic;
signal sig_Inst_Boot          : std_logic;
signal sig_Data_Boot          : std_logic;
signal sig_RW_Boot            : std_logic;
signal sig_Adr_boot           : std_logic_vector((Memory_size) downto 0);
signal sig_Val_In_boot        : std_logic_vector((8-1) downto 0);
signal sig_Val_Out_boot       : std_logic_vector((8-1) downto 0);
signal sig_Val_Inst_Out_boot  : std_logic_vector((8-1) downto 0);
signal sig_Val_Data_Out_boot  : std_logic_vector((8-1) downto 0);

signal sig_Adr_Inst_boot_32      : std_logic_vector((Bit_Nber-1) downto 0);
signal sig_Adr_Data_boot_32      : std_logic_vector((Bit_Nber-1) downto 0);

constant  octet_null : STD_LOGIC_VECTOR (7 downto 0) := "00000000"; 
 
begin

--sig_Adr_Inst_boot_32((Memory_size-1) downto 0) <= sig_Adr_boot;--((Memory_size-1) downto 0);
--sig_Adr_Data_boot_32((Memory_size-1) downto 0) <= sig_Adr_boot;--((Memory_size-1) downto 0);

--horloge : clk_wiz_0
--     port map(
--     clk_in1  => clk_100,
--     clk_out1 => clk
--     );

Boot_Demux : Process(sig_Boot, sig_Adr_boot)
  Begin
    if (sig_Adr_boot(Memory_size)='1') then
        sig_Inst_Boot <= '0';
        sig_Data_Boot <= sig_Boot;
        sig_Adr_Inst_boot_32((Memory_size-1) downto 0) <= (others => '0');
        sig_Adr_Data_boot_32((Memory_size-1) downto 0) <= sig_Adr_boot((Memory_size-1) downto 0);
    else
        sig_Inst_Boot <= sig_Boot;
        sig_Data_Boot <= '0';
        sig_Adr_Inst_boot_32((Memory_size-1) downto 0) <= sig_Adr_boot((Memory_size-1) downto 0);
        sig_Adr_Data_boot_32((Memory_size-1) downto 0) <= (others => '0');
    end if;
End Process;

Boot_Mux : Process(sig_Adr_boot, sig_Val_Inst_Out_boot, sig_Val_Data_Out_boot)
  Begin
    if (sig_Adr_boot(Memory_size)='1') then
        sig_Val_Out_boot <= sig_Val_Data_Out_boot;
    else
        sig_Val_Out_boot <= sig_Val_Inst_Out_boot;
    end if;
End Process;

CPU_Instance : CPU_RISCV 
    generic map( Bit_Nber    => Bit_Nber,   -- 
                 Memory_size => Memory_size 
                )
    port map( Clk               => Clk,
              Reset             => Reset,
              CE                => CE,
              boot              => sig_Boot,
              Inst_Boot         => sig_Inst_Boot, 
              Data_Boot         => sig_Data_Boot, 
              Inst_RW_Boot      => sig_RW_Boot,
              Data_RW_Boot      => sig_RW_Boot,
              Adr_Inst_boot     => sig_Adr_Inst_boot_32,
              Adr_Data_boot     => sig_Adr_Data_boot_32,
              Val_Inst_In_boot  => sig_Val_In_boot,
              Val_Data_In_boot  => sig_Val_In_boot,        
              Val_Inst_Out_Boot => sig_Val_Inst_Out_boot,        
              Val_Data_Out_Boot => sig_Val_Data_Out_boot
           );
     

BL_Instance : boot_loader 
        generic map( Bit_Nber            => Bit_Nber,   -- 
                     Memory_size         => (Memory_size+1),
                     UART_recv_FIFO_Size =>  UART_recv_FIFO_Size,
                     UART_recv_FIFO_Almost =>  UART_recv_FIFO_Almost
                   )
        port map(  clk         => Clk_100,
                   rst         => Reset,
                   ce          => CE,
                   rx          => rx,
                   tx          => tx,
                   boot        => sig_Boot,
                   scan_memory => Scan_Mem,
                   ram_out     => sig_Val_Out_boot,
                   ram_rw      => sig_RW_Boot,
                   ram_adr     => sig_Adr_boot,
                   ram_in      => sig_Val_In_boot
                 );
                 
  LED(0) <= Reset;
  LED(1) <= CE;    
  LED(2) <= Rx;
  LED(3) <= Scan_Mem;
  
  clk <= clk_100;                     
                 
end Behavioral;
