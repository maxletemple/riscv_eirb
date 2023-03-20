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
            index := to_integer(unsigned(Operand2));
            --Result <= Operand1(index downto 0) & std_logic_vector(to_unsigned(0, index));
            --Result <= std_logic_vector(resize(unsigned(operand1(Bit_Nber-1 downto to_integer(unsigned(operand2)))), 32 ) * (2 ** (unsigned(operand2))));
            Result <= std_logic_vector(shift_left(unsigned(operand1), index));
            val_connect <= '0';
            
        when "1001" => -- Décalage logique à droite >>u ?????????????????
            index := to_integer(unsigned(Operand2));
            Result <= std_logic_vector(shift_right(unsigned(operand1), index));
            val_connect <= '0';
        
        when "1010" => -- Décalage arithmétique à droite >>s
        
            index := to_integer(unsigned(Operand2));
            Result <= std_logic_vector(shift_right(signed(operand1), index));
--            index := to_integer(unsigned(Operand2));
--            if(signed(Operand1) >= 0) then
--                Result <= std_logic_vector(to_unsigned(0,index)) & Operand1(Bit_Nber - 1 downto index);
--            else
--                Result <= std_logic_vector(to_signed(-1, index)) & Operand1(Bit_Nber - 1 downto index);
--            end if;
--            val_connect <= '0';
            
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
        
        when "1011" => -- lui = load upper immediate
            Result <= Operand2; -- Operand2(19 downto 0) & std_logic_vector(to_unsigned(0,12));
            val_connect <= '0';
            
        when "1100" => -- Jalr
            Result <= std_logic_vector(unsigned(Operand1) + unsigned(Operand2)) and std_logic_vector(to_signed(-2,Bit_Nber)); -- Masquage du dernier bit
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

-- c koi ca ?
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
