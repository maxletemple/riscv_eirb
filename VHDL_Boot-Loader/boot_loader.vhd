library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity boot_loader is
    Generic(	
        Bit_Nber              : INTEGER := 32;
        Memory_size           : INTEGER := 6;   --! 2**5= 32 Values
        UART_recv_FIFO_Size   : INTEGER := 128;
        UART_recv_FIFO_Almost : INTEGER := 64
   );
    Port (  clk         : in std_logic;
            rst         : in std_logic;
            ce          : in std_logic;
            rx          : in std_logic;
            tx          : out std_logic;
            boot        : out std_logic;
            scan_memory : in std_logic;
            ram_out     : in std_logic_vector((8-1) downto 0);
            ram_rw      : out std_logic;
          --ram_enable : out std_logic;
            ram_adr     : out std_logic_vector((Memory_size-1) downto 0);
            ram_in      : out std_logic_vector((8-1) downto 0));
end boot_loader;

architecture Behavioral of boot_loader is


component UART_recv is
   Port ( clk    : in  STD_LOGIC;
          reset  : in  STD_LOGIC;
          rx     : in  STD_LOGIC;
          dat    : out STD_LOGIC_VECTOR (7 downto 0);
          dat_en : out STD_LOGIC);
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


signal rx_byte, tx_byte : std_logic_vector(7 downto 0);
signal rx_data_valid, tx_data_valid : std_logic; 

signal rx_byte_reg : std_logic_vector(7 downto 0);

signal rx_byte_count : unsigned((Memory_size-1) downto 0);
signal enable_rx_byte_counter : std_logic;
signal init_byte_counter : std_logic;

type t_state is (INIT, WAIT_RX_BYTE, INCR_RX_BYTE_COUNTER, WRITE_RX_BYTE, WAIT_SCAN_MEM, READ_TX_BYTE, INCR_TX_BYTE_COUNTER, ENABLE_TX, WAIT_8K_CYCLE, OVER);
signal current_state, future_state : t_state;

signal tx_cycle_count : unsigned(12 downto 0);
signal init_tx_cycle_count, tx_cycle_count_over : std_logic;

begin

ram_adr <= std_logic_vector(rx_byte_count);
ram_in <= rx_byte_reg;
tx_byte <= ram_out; 
                                          
inst_uart_recv : UART_recv
port map(   clk    => clk,
            reset  => rst,
            rx     => rx,
            dat    => rx_byte,
            dat_en => rx_data_valid);

inst_uart_send : UART_fifoed_send 	
----Memory 64	
--generic map(fifo_size             => 8,--4	
--            fifo_almost           => 4,--2	
--Memory 128	
--generic map(fifo_size             => 16,--4	
--            fifo_almost           => 8,--2	
--Memory 128	
--generic map(fifo_size             => 128,--4	
--            fifo_almost           => 64,--2    	
--memory generic	
generic map(fifo_size             => UART_recv_FIFO_Size,	
            fifo_almost           => UART_recv_FIFO_Almost,                     	
            drop_oldest_when_full => false,	
            asynch_fifo_full      => true,	
            baudrate              => 115200,	
            clock_frequency       => 100000000)	
port map(	
            clk_100MHz => clk,	
            reset      => rst,	
            dat_en     => tx_data_valid,	
            dat        => tx_byte,	
            TX         => tx,	
            fifo_empty => open,	
            fifo_afull => open,	
            fifo_full  => open
            );
            

---------------------
-- rx_byte_register
---------------------
process(clk)
begin
    if (rising_edge(clk)) then
        if (rst = '1') then
                rx_byte_reg <= (others => '0');
        elsif (ce = '1') then
            if (rx_data_valid = '1') then
                rx_byte_reg <= rx_byte;
            end if;
        end if;
    end if;
end process;

---------------------
-- rx_byte_counter
---------------------

process(clk)
begin

   if ( rising_edge(clk)) then   
        if (rst = '1') then
                    rx_byte_count <= to_unsigned(0, Memory_size);
        elsif (ce = '1') then
            if(init_byte_counter = '1') then
                    rx_byte_count <= to_unsigned(0, Memory_size);
            elsif (enable_rx_byte_counter = '1') then
               if(rx_byte_count = to_unsigned(((2**Memory_size)-1), Memory_size)) then
                    rx_byte_count <= to_unsigned(0, Memory_size);
                else
                    rx_byte_count <= rx_byte_count + to_unsigned(1, Memory_size);
                end if;
            end if;
        end if;
    end if;
end process;

---------------------
-- tx_cycle_counter
---------------------


process(clk)
begin
    if (rising_edge(clk)) then
        if (rst = '1') then
                tx_cycle_count <= (others => '0');
        elsif (ce = '1') then
            if(init_tx_cycle_count = '1') then
                tx_cycle_count <= (others => '0');
                tx_cycle_count_over <= '0';
            elsif(tx_cycle_count = to_unsigned(8191,13)) then
                tx_cycle_count_over <= '1';
                tx_cycle_count <= (others => '0');
            else
                tx_cycle_count <= tx_cycle_count + to_unsigned(1, 13);
                tx_cycle_count_over <= '0';
            end if;            
        end if;
    end if;
end process;

---------------------
-- fsm
---------------------

state_register : process(clk)
begin
    if (rising_edge ( clk ) ) then
        if (rst = '1') then
            current_state <= INIT;
        elsif (ce = '1') then
            current_state <= future_state;
        end if;
    end if;
end process;

next_state_compute : process(current_state, rx_data_valid, rx_byte_count, scan_memory, tx_cycle_count_over)
begin
    case current_state is
        when INIT =>
            future_state <= WAIT_RX_BYTE;
        when WAIT_RX_BYTE =>
            if(rx_data_valid = '1') then
                future_state <= WRITE_RX_BYTE;
            else
                future_state <= WAIT_RX_BYTE;
            end if;    
        when WRITE_RX_BYTE =>
            if(rx_byte_count = to_unsigned(((2**Memory_size)-1), Memory_size)) then            
                future_state <= WAIT_SCAN_MEM;
            else
                future_state <= INCR_RX_BYTE_COUNTER;
            end if;   
        when INCR_RX_BYTE_COUNTER =>
            future_state <= WAIT_RX_BYTE;                
        when WAIT_SCAN_MEM =>
            if(scan_memory = '1') then
                future_state <= READ_TX_BYTE;
            else
                future_state <= WAIT_SCAN_MEM;
            end if;
        when INCR_TX_BYTE_COUNTER =>
            future_state <= WAIT_8K_CYCLE;
        when WAIT_8K_CYCLE =>
            if(tx_cycle_count_over = '0') then
                future_state <= WAIT_8K_CYCLE;
            else
                future_state <= READ_TX_BYTE;
            end if;
        when READ_TX_BYTE =>
            future_state <= ENABLE_TX;
        when ENABLE_TX =>
            if( rx_byte_count = to_unsigned(((2**Memory_size)-1), Memory_size)) then
                future_state <= OVER;
            else
                future_state <= INCR_TX_BYTE_COUNTER;
            end if;
        when OVER =>
            future_state <= OVER;
    end case;     
end process;


output_compute : process(current_state)
begin
    case current_state is
        when  INIT =>
            ram_rw <= '0';
            --ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '1';
            init_tx_cycle_count <= '1';
        when  WAIT_RX_BYTE =>
            ram_rw <= '0';
            --ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  WRITE_RX_BYTE =>
            ram_rw <= '1';
            --ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  INCR_RX_BYTE_COUNTER =>
            ram_rw <= '0';
           -- ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '1';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  WAIT_SCAN_MEM =>
            ram_rw <= '0';
           -- ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '0';
            init_byte_counter <= '1';
            init_tx_cycle_count <= '1';
        when  READ_TX_BYTE =>
            ram_rw <= '0';
           -- ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  ENABLE_TX =>
            ram_rw <= '0';
          --  ram_enable <= '1';
            tx_data_valid <= '1';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  INCR_TX_BYTE_COUNTER =>
            ram_rw <= '0';
           -- ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '1';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '1';
        when  WAIT_8K_CYCLE =>
            ram_rw <= '0';
           -- ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '1';
            init_byte_counter <= '0';
            init_tx_cycle_count <= '0';    
        when  OVER =>
            ram_rw <= '0';
          --  ram_enable <= '1';
            tx_data_valid <= '0';
            enable_rx_byte_counter <= '0';
            boot <= '0'; 
            init_byte_counter <= '0';  
            init_tx_cycle_count <= '1';        
    end case;
end process;

end Behavioral;
