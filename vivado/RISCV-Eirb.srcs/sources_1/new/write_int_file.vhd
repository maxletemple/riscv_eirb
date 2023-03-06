library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

  entity write_int_file is
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
  end write_int_file;

  architecture bhv of write_int_file is

  signal counter  : unsigned(34 downto 0);
  signal nb_octet : unsigned(Memory_size downto 0);
  
  begin
    
  write_data_file : process(clk)
	 file File_Inst : text open write_mode is File_Out_Inst;--"default_Inst.txt";
	 file File_Data : text open write_mode is File_Out_Data;--"default_Data.txt";
	 variable sample_data : line;
	 variable data_int : integer range 0 to symb_max_val;
	 begin

	 if(rst = '1') then
		counter  <= (others => '0');
		nb_octet <= (others => '0');
	 elsif(clk 'event and clk='1') then --read inputs

		if(data_valid = '1') then
		  nb_octet <= nb_octet + to_unsigned(1,Memory_size);
		  data_int := to_integer(unsigned(data(data_size-1 downto 0)));
		  write(sample_data,data_int);
		  write(sample_data,string'(" "));
		
		  if(counter = frame_size-1) then
		     if (nb_octet<(2**Memory_size)) then
			    writeline(File_Inst,sample_data);
			 else 
			    writeline(File_Data,sample_data);
			 end if;
		  end if;                  

		  if(counter = frame_size-1) then
			 counter <= (others => '0');
		  else
			 counter <= counter + 1;
		  end if;
		end if;
	 end if;    

  end process;          

  end architecture;
