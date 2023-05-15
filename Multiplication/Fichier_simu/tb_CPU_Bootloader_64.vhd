library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_CPU_Bootloader_64_Values is
    Generic(
           Bit_Nber       : INTEGER := 32;
           Memory_size    : INTEGER := 6 ;-- 2 mmemory (2**6= 64 Values)
           File_In_Inst   : STRING  := "Mem_In_Inst_64_Values.txt";
           File_In_Data   : STRING  := "Mem_In_Data_64_Values.txt";
           File_Out_Inst  : STRING  := "Mem_Out_Inst_64_Values.txt";
           File_Out_Data  : STRING  := "Mem_Out_Data_64_Values.txt"
           );
end tb_CPU_Bootloader_64_Values;

architecture Behavioral of tb_CPU_Bootloader_64_Values is

component CPU_Bootloader is
    Generic(
           Bit_Nber    : INTEGER := Bit_Nber ;
           Memory_size : INTEGER := Memory_size 
           );
    Port ( clk      : in STD_LOGIC;
           reset    : in STD_LOGIC;
           ce       : in STD_LOGIC;
           Scan_Mem : in std_logic;
           rx       : in STD_LOGIC;
           tx       : out STD_LOGIC;
           LED         : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

component read_int_file is
generic (
        File_In_Inst   : STRING  := "default_Inst.txt";
        File_In_Data   : STRING  := "default_Data.txt";
        line_size      : integer := 32;
        --symb_max_val   : integer := 3;
        data_size      : integer := 2
     );
port(    clk        : in  STD_LOGIC;
        rst        : in std_logic;
        enable     : in  STD_LOGIC;
        stream_out : out STD_LOGIC_vector(data_size-1 downto 0));
end component;

component UART_fifoed_send is
    Generic ( fifo_size             : integer := 4096;
              fifo_almost           : integer := 4090;
              drop_oldest_when_full : boolean := False;
              asynch_fifo_full      : boolean := True;
              baudrate              : integer := 921600;   -- [bps]
              clock_frequency       : integer := 100000000 -- [Hz]
    );
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        dat_en     : in  STD_LOGIC;
        dat        : in  STD_LOGIC_VECTOR (7 downto 0);
        TX         : out STD_LOGIC;
        fifo_empty : out STD_LOGIC;
        fifo_afull : out STD_LOGIC;
        fifo_full  : out STD_LOGIC
    );
end component;

component UART_recv is
   Port ( clk    : in  STD_LOGIC;
          reset  : in  STD_LOGIC;
          rx     : in  STD_LOGIC;
          dat    : out STD_LOGIC_VECTOR (7 downto 0);
          dat_en : out STD_LOGIC);
end component;

component write_int_file is
     generic (
           File_Out_Inst   : STRING  := "default_Inst.txt";
           File_Out_Data   : STRING  := "default_Data.txt";
           frame_size   : integer := 203;
           symb_max_val : integer := 255;
           data_size    : integer := 8;
           Memory_size  : INTEGER := 5 -- 2**5= 32 Values
     );
     port(
        CLK              : in std_logic;
        RST              : in std_logic;
        data_valid       : in std_logic;
        data             : in std_logic_vector(data_size-1 downto 0)
     );
end component;
  
signal clk      : STD_LOGIC := '0';
signal rst      : STD_LOGIC;
signal ce       : STD_LOGIC;
signal Scan_Mem : STD_LOGIC;
signal rx       : STD_LOGIC;
signal tx       : STD_LOGIC;
signal LED      : STD_LOGIC_VECTOR (3 downto 0);

signal ce_dly        : std_logic;
signal tx_data_valid : std_logic;
signal tx_byte       : std_logic_vector((8-1) downto 0);

signal prog_out    : std_logic_vector((8-1) downto 0);
signal prog_out_dv : std_logic;

signal byte_count                   : unsigned((Memory_size) downto 0);
signal cycle_count                  : unsigned(12 downto 0);
signal enable_push, enable_push_dly : std_logic;

begin

------------------------------------------------
-- control CPU signal generation
------------------------------------------------

clk      <= not(clk) after 1 ns;
rst      <= '1', '0' after 113 ns;
Scan_Mem <= '0', '1' after 4 ms;
ce       <= '1';

process(rst, clk)
begin
    if (rst = '1') then
        byte_count <= to_unsigned(0,Memory_size+1);
        enable_push <= '0';
        cycle_count <= (others => '0');
    elsif ( rising_edge(clk)) then
        if(cycle_count = to_unsigned(8191,13)) then
            cycle_count <= (others => '0');
            enable_push <= '1';
            byte_count <= byte_count + to_unsigned(1,Memory_size+1);
        else
            cycle_count <= cycle_count + to_unsigned(1,13);
            enable_push <= '0';
            byte_count <= byte_count;                        
        end if;
    end if;
end process;

process(rst, clk)
begin
    if (rst = '1') then
        enable_push_dly <= '0';
    elsif ( rising_edge(clk)) then
        enable_push_dly <= enable_push;
    end if;
end process;

------------------------------------------------
-- Inst and Data file reader
------------------------------------------------

inst_read_file : read_int_file
generic map(File_In_Inst   => File_In_Inst,
            File_In_Data   => File_In_Data,
            line_size      => 1,
            --symb_max_val => 255,
            data_size      => 8)
port map(    clk        => clk,
            rst        => rst,
            enable     => enable_push,
            stream_out => tx_byte);

------------------------------------------------
-- UART TX
------------------------------------------------
            
inst_uart_send : UART_fifoed_send 
generic map(fifo_size             => 8,--4
            fifo_almost           => 4,--2
            drop_oldest_when_full => false,
            asynch_fifo_full      => true,
            baudrate              => 115200,
            clock_frequency       => 100000000)
port map(
            clk_100MHz => clk,
            reset      => rst,
            dat_en     => enable_push_dly,
            dat        => tx_byte,
            TX         => rx,
            fifo_empty => open,
            fifo_afull => open,
            fifo_full  => open);

------------------------------------------------
-- Unit Under Test : CPU
------------------------------------------------
            
inst_CPU : CPU_Bootloader 
    generic map( Bit_Nber    => Bit_Nber ,   -- 
                 Memory_size => Memory_size   
                )
    Port map(   clk      => clk,
                reset    => rst,
                ce       => ce,
                Scan_Mem => Scan_Mem,
                rx       => rx,
                tx       => tx,
                LED      => LED
                );

------------------------------------------------
-- UART RX
------------------------------------------------
                            
inst_uart_rx : UART_recv
   Port map( clk    => clk,
             reset  => rst,
             rx     => tx,
             dat    => prog_out,
             dat_en => prog_out_dv);

------------------------------------------------
-- memory file writer
------------------------------------------------

inst_write_file : write_int_file 
     generic map(
        File_Out_Inst   => File_Out_Inst,
        File_Out_Data   => File_Out_Data,
        frame_size   => 1,
        symb_max_val => 255,
        data_size    => 8,
        Memory_size    => Memory_size
        
     )
     port map(
        CLK        => clk,
        RST        => rst,
        data_valid => prog_out_dv,
        data       => prog_out
     );

end Behavioral;
