library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is
    Generic(
           Bit_Nber    : INTEGER := 32 -- word size
           );
    Port ( sel_func_ALU         : in STD_LOGIC_VECTOR (3 downto 0);
           sel_func_ALU_connect : in STD_LOGIC_VECTOR (2 downto 0);
           Operand1             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Operand2             : in STD_LOGIC_VECTOR  ((Bit_Nber-1) downto 0);
           Result               : out STD_LOGIC_VECTOR ((Bit_Nber-1) downto 0);
           Val_connect          : out STD_LOGIC
          );
end ALU;


architecture Behavioral of ALU is


begin

process(sel_func_ALU, sel_func_ALU_connect, Operand1, Operand2)

variable index : integer range 0 to 31;

begin

    case(sel_func_ALU) is
    
        when "0001" => -- add
            Result <= std_logic_vector(unsigned(Operand1) + unsigned(Operand2));
            Val_connect <= '0';
            
        when "0010" => -- sub
            Result <= std_logic_vector(unsigned(Operand1) - unsigned(Operand2));
            val_connect <= '0';

        when "1000" => -- Decalage logique à gauche <<
        
            case(to_integer(unsigned(operand2))) is
            
                when 0 => 
                    Result <= Operand1;
                when 1 => 
                    Result <= Operand1(30 downto 0) & std_logic_vector(to_unsigned(0,1));
                when 2 => 
                    Result <= Operand1(29 downto 0) & std_logic_vector(to_unsigned(0,2));
                when 3 => 
                    Result <= Operand1(28 downto 0) & std_logic_vector(to_unsigned(0,3));
                when 4 => 
                    Result <= Operand1(27 downto 0) & std_logic_vector(to_unsigned(0,4));
                when 5 => 
                    Result <= Operand1(26 downto 0) & std_logic_vector(to_unsigned(0,5));
                when 6 => 
                    Result <= Operand1(25 downto 0) & std_logic_vector(to_unsigned(0,6));
                when 7 => 
                    Result <= Operand1(24 downto 0) & std_logic_vector(to_unsigned(0,7));
                when 8 => 
                    Result <= Operand1(23 downto 0) & std_logic_vector(to_unsigned(0,8));
                when 9 => 
                    Result <= Operand1(22 downto 0) & std_logic_vector(to_unsigned(0,9));
                when 10 => 
                    Result <= Operand1(21 downto 0) & std_logic_vector(to_unsigned(0,10));
                when 11 => 
                    Result <= Operand1(20 downto 0) & std_logic_vector(to_unsigned(0,11));
                when 12 => 
                    Result <= Operand1(19 downto 0) & std_logic_vector(to_unsigned(0,12));
                when 13 => 
                    Result <= Operand1(18 downto 0) & std_logic_vector(to_unsigned(0,13));
                when 14 => 
                    Result <= Operand1(17 downto 0) & std_logic_vector(to_unsigned(0,14));
                when 15=> 
                    Result <= Operand1(16 downto 0) & std_logic_vector(to_unsigned(0,15));
                when 16=> 
                    Result <= Operand1(15 downto 0) & std_logic_vector(to_unsigned(0,16));
                when 17=> 
                    Result <= Operand1(14 downto 0) & std_logic_vector(to_unsigned(0,17));
                when 18=> 
                    Result <= Operand1(13 downto 0) & std_logic_vector(to_unsigned(0,18));
                when 19=> 
                    Result <= Operand1(12 downto 0) & std_logic_vector(to_unsigned(0,19));
                when 20=> 
                    Result <= Operand1(11 downto 0) & std_logic_vector(to_unsigned(0,20));
                when 21=> 
                    Result <= Operand1(10 downto 0) & std_logic_vector(to_unsigned(0,21));
                when 22=> 
                    Result <= Operand1(9 downto 0) & std_logic_vector(to_unsigned(0,22));
                when 23=> 
                    Result <= Operand1(8 downto 0) & std_logic_vector(to_unsigned(0,23));
                when 24=> 
                    Result <= Operand1(7 downto 0) & std_logic_vector(to_unsigned(0,24));
                when 25=> 
                    Result <= Operand1(6 downto 0) & std_logic_vector(to_unsigned(0,25));
                when 26=> 
                    Result <= Operand1(5 downto 0) & std_logic_vector(to_unsigned(0,26));
                when 27=> 
                    Result <= Operand1(4 downto 0) & std_logic_vector(to_unsigned(0,27));
                when 28=> 
                    Result <= Operand1(3 downto 0) & std_logic_vector(to_unsigned(0,28));
                when 29=> 
                    Result <= Operand1(2 downto 0) & std_logic_vector(to_unsigned(0,29));
                when 30=> 
                    Result <= Operand1(1 downto 0) & std_logic_vector(to_unsigned(0,30));
                when 31=> 
                    Result <= Operand1(0)          & std_logic_vector(to_unsigned(0,31));
                when others =>
                    Result <= (others => '0');
                    
                end case;

--            index := to_integer(unsigned(Operand2));
--            --Result <= Operand1(index downto 0) & std_logic_vector(to_unsigned(0, index));
--            --Result <= std_logic_vector(resize(unsigned(operand1(Bit_Nber-1 downto to_integer(unsigned(operand2)))), 32 ) * (2 ** (unsigned(operand2))));
--            Result <= std_logic_vector(shift_left(unsigned(operand1), index));
--            val_connect <= '0';

            val_connect <= '0';
            
        when "1001" => -- Décalage logique à droite >>u ?????????????????
--            index := to_integer(unsigned(Operand2));
--            Result <= std_logic_vector(shift_right(unsigned(operand1), index));
--            val_connect <= '0';

            case(to_integer(unsigned(operand2))) is
                when 0 => 
                    Result <=                                        Operand1               ;
                when 1 => 
                    Result <=  std_logic_vector(to_unsigned(0,1))  & Operand1(31  downto 1) ;
                when 2 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,2))  & Operand1(31  downto 2) ;
                when 3 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,3))  & Operand1(31  downto 3) ;
                when 4 =>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,4))  & Operand1(31  downto 4) ;
                when 5 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,5))  & Operand1(31  downto 5) ;
                when 6 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,6))  & Operand1(31  downto 6) ;
                when 7 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,7))  & Operand1(31  downto 7) ;
                when 8 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,8))  & Operand1(31  downto 8) ;
                when 9 =>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,9))  & Operand1(31  downto 9) ;
                when 10 =>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,10)) & Operand1(31  downto 10);
                when 11 =>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,11)) & Operand1(31  downto 11);
                when 12 =>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,12)) & Operand1(31  downto 12);
                when 13 =>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,13)) & Operand1(31  downto 13);
                when 14 =>                                                                
                    Result <=  std_logic_vector(to_unsigned(0,14)) & Operand1(31  downto 14);
                when 15=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,15)) & Operand1(31  downto 15);
                when 16=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,16)) & Operand1(31  downto 16);
                when 17=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,17)) & Operand1(31  downto 17);
                when 18=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,18)) & Operand1(31  downto 18);
                when 19=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,19)) & Operand1(31  downto 19);
                when 20=>                                                              
                    Result <=  std_logic_vector(to_unsigned(0,20)) & Operand1(31  downto 20);
                when 21=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,21)) & Operand1(31  downto 21);
                when 22=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,22)) & Operand1(31 downto 22) ;
                when 23=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,23)) & Operand1(31 downto 23) ;
                when 24=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,24)) & Operand1(31 downto 24) ;
                when 25=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,25)) & Operand1(31 downto 25) ;
                when 26=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,26)) & Operand1(31 downto 26) ;
                when 27=>                                                               
                    Result <=  std_logic_vector(to_unsigned(0,27)) & Operand1(31 downto 27) ;
                when 28=>                                                                
                    Result <=  std_logic_vector(to_unsigned(0,28)) & Operand1(31 downto 28) ;
                when 29=>                                                                
                    Result <=  std_logic_vector(to_unsigned(0,29)) & Operand1(31 downto 29) ;
                when 30=>                                                                
                    Result <=  std_logic_vector(to_unsigned(0,30)) & Operand1(31 downto 30) ;
                when 31=>                                                                
                    Result <=  std_logic_vector(to_unsigned(0,31)) & Operand1(31          ) ;
                when others =>
                    Result <= (others => '0');
                end case;
        
            
            val_connect <= '0';
        
        when "1010" => -- D?calage arithm?tique ? droite >>s
        
        case(to_integer(unsigned(Operand2))) is
            when 0 =>
                Result <= Operand1;
            when 1 =>
                Result(31) <= Operand1(31);
                for i in 0 to 30 loop
                    Result(i) <= Operand1(1+i);
                end loop;
            when 2 =>
                Result(31 downto 30) <= (others=>Operand1(31));
                for i in 0 to 29 loop
                    Result(i) <= Operand1(2+i);
                end loop;
            when 3 =>
                Result(31 downto 29)<= (others=>Operand1(31));
                for i in 0 to 28 loop
                    Result(i) <= Operand1(3+i);
                end loop;
            when 4 =>
                Result(31 downto 28)<= (others=>Operand1(31));
                for i in 0 to 27 loop
                    Result(i) <= Operand1(4+i);
                end loop;
            when 5 =>
                Result(31 downto 27)<= (others=>Operand1(31));
                for i in 0 to 26 loop
                    Result(i) <= Operand1(5+i);
                end loop;
            when 6 =>
                Result(31 downto 26) <= (others=>Operand1(31));
                for i in 0 to 25 loop
                    Result(i) <= Operand1(6+i);
                end loop;
            when 7 =>
                Result(31 downto 25) <= (others=>Operand1(31));
                for i in 0 to 24 loop
                    Result(i) <= Operand1(7+i);
                end loop;
            when 8 =>
                Result(31 downto 24) <= (others=>Operand1(31));
                for i in 0 to 23 loop
                    Result(i) <= Operand1(8+i);
                end loop;
            when 9 =>
                Result(31 downto 23) <= (others=>Operand1(31));
                for i in 0 to 22 loop
                    Result(i) <= Operand1(9+i);
                end loop;
            when 10 =>
                Result(31 downto 22) <= (others=>Operand1(31));
                for i in 0 to 21 loop
                    Result(i) <= Operand1(10+i);
                end loop;
            when 11 =>
                Result(31 downto 21) <= (others=>Operand1(31));
                for i in 0 to 20 loop
                    Result(i) <= Operand1(11+i);
                end loop;
            when 12 =>
                Result(31 downto 20) <= (others=>Operand1(31));
                for i in 0 to 19 loop
                    Result(i) <= Operand1(12+i);
                end loop;
            when 13 =>
                Result(31 downto 19) <= (others=>Operand1(31));
                for i in 0 to 18 loop
                    Result(i) <= Operand1(13+i);
                end loop;
            when 14 =>
                Result(31 downto 18) <= (others=>Operand1(31));
                for i in 0 to 17 loop
                    Result(i) <= Operand1(14+i);
                end loop;
            when 15 =>
                Result(31 downto 17) <= (others=>Operand1(31));
                for i in 0 to 16 loop
                    Result(i) <= Operand1(15+i);
                end loop;
            when 16 =>
                Result(31 downto 16) <= (others=>Operand1(31));
                for i in 0 to 15 loop
                    Result(i) <= Operand1(16+i);
                end loop;
            when 17 =>
                Result(31 downto 15) <= (others=>Operand1(31));
                for i in 0 to 14 loop
                    Result(i) <= Operand1(17+i);
                end loop;
            when 18 =>
                Result(31 downto 14) <= (others=>Operand1(31));
                for i in 0 to 13 loop
                    Result(i) <= Operand1(18+i);
                end loop;
            when 19 =>
                Result(31 downto 13) <= (others=>Operand1(31));
                for i in 0 to 12 loop
                    Result(i) <= Operand1(19+i);
                end loop;
            when 20 =>
                Result(31 downto 12) <= (others=>Operand1(31));
                for i in 0 to 11 loop
                    Result(i) <= Operand1(20+i);
                end loop;
            when 21 =>
                Result(31 downto 11) <= (others=>Operand1(31));
                for i in 0 to 10 loop
                    Result(i) <= Operand1(21+i);
                end loop;
            when 22 =>
                Result(31 downto 10) <= (others=>Operand1(31));
                for i in 0 to 9 loop
                    Result(i) <= Operand1(22+i);
                end loop;
            when 23 =>
                Result(31 downto 9) <= (others=>Operand1(31));
                for i in 0 to 8 loop
                    Result(i) <= Operand1(23+i);
                end loop;
            when 24 =>
                Result(31 downto 8) <= (others=>Operand1(31));
                for i in 0 to 7 loop
                    Result(i) <= Operand1(24+i);
                end loop;
            when 25 =>
                Result(31 downto 7) <= (others=>Operand1(31));
                for i in 0 to 6 loop
                    Result(i) <= Operand1(25+i);
                end loop;
            when 26 =>
                Result(31  downto 6) <= (others=>Operand1(31));
                for i in 0 to 5 loop
                    Result(i) <= Operand1(26+i);
                end loop;
            when 27 =>
                Result(31 downto 5) <= (others=>Operand1(31));
                for i in 0 to 4 loop
                    Result(i) <= Operand1(27+i);
                end loop;
            when 28 =>
                Result(31 downto 4) <= (others=>Operand1(31));
                for i in 0 to 3 loop
                    Result(i) <= Operand1(28+i);
                end loop;
            when 29 =>
                Result(31 downto 3) <= (others=>Operand1(31));
                for i in 0 to 2 loop
                    Result(i) <= Operand1(29+i);
                end loop;
            when 30 =>
                Result(31 downto 2) <= (others=>Operand1(31));
                for i in 0 to 1 loop
                    Result(i) <= Operand1(30+i);
                end loop;
            when others =>
                Result <= (others=>Operand1(31));
                
            end case;        
        
        
--            index := to_integer(unsigned(Operand2));
--            Result <= std_logic_vector(shift_right(signed(operand1), index));
--            index := to_integer(unsigned(Operand2));
--            if(signed(Operand1) >= 0) then
--                Result <= std_logic_vector(to_unsigned(0,index)) & Operand1(Bit_Nber - 1 downto index);
--            else
--                Result <= std_logic_vector(to_signed(-1, index)) & Operand1(Bit_Nber - 1 downto index);
--            end if;
            val_connect <= '0';
            
        when "0111" => -- xor
            Result <= Operand1 xor Operand2;
            val_connect <= '0';
            
        when "0110" => -- or
            Result <= Operand1 or Operand2;
            val_connect <= '0';
            
        when "0101" => -- and
            Result <= Operand1 and Operand2;
            val_connect <= '0';
            
        when "0011" => -- slt = set less than
            if(signed(Operand1) < signed(Operand2)) then
                Result <= std_logic_vector(to_unsigned(1,Bit_Nber));
            else
                Result <= (others => '0');
            end if;
            val_connect <= '0';
            
        when "0100" => -- sltu = set less than unsigned
            if(unsigned(Operand1) < unsigned(Operand2)) then
                Result <= std_logic_vector(to_unsigned(1,Bit_Nber));
            else
                Result <= (others => '0');
            end if;
        val_connect <= '0';
        
        when "1011" => -- lui = load immediate    
            Result <= Operand1(19 downto 0) & std_logic_vector(to_unsigned(0,12));
            val_connect <= '0';
            
        when "1100" =>
            Result <= std_logic_vector(unsigned(Operand1) + unsigned(Operand2)) and std_logic_vector(to_signed(-2,Bit_Nber));
            val_connect <= '0';
            
        when "0000" => -- a<b?1:0 signed
            
            case(sel_func_ALU_connect) is
            
            when "001" => -- beq = branch equal
                if(unsigned(Operand1) = unsigned(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
                
            when "010" => -- bne = branch not equal
                if(unsigned(Operand1) /= unsigned(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
            
            when "011" => -- blt = branch less than signed
                if(signed(Operand1) < signed(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
            
            when "100" => -- bge = branch greathor or equal signed
                if(signed(Operand1) >= signed(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
            
            when "101" => -- bltu = branch less than unsigned
                if(unsigned(Operand1) < unsigned(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
            
            when "110" => -- bgeu = branch greater or equal unsigned
                if(unsigned(Operand1) >= unsigned(Operand2)) then
                    val_connect <= '1';
                else 
                    val_connect<= '0';
                end if;
            
            when others =>
        Result <= (others => '0');
            
            end case;
--                if(unsigned(Operand1) < unsigned(Operand2)) then
--                    val_connect <= '1';
--                else 
--                    val_connect<= '0';
--                end if;
            Result <= (others => '0');
            
        when others => -- "1101" to "1111"
            Result <= (others => '0');
            val_connect <= '0';
            
    end case;
    

end process;


end Behavioral;
