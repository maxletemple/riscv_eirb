library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoblock is
    Generic(Bit_Nber : integer := 32);
    Port(opcode : in std_logic_vector(6 downto 0);
         funct3 : in std_logic_vector(2 downto 0);
         funct7 : in std_logic_vector(6 downto 0);
         sel_func_ALU         : out STD_LOGIC_VECTOR (3 downto 0);
         --reg_file_write       : out STD_LOGIC;
         imm_type             : out STD_LOGIC_VECTOR (2 downto 0);
         sel_op2              : out STD_LOGIC;
         sel_result           : out STD_LOGIC_VECTOR (1 downto 0);
         --RW_UT_Data           : out STD_LOGIC;
         sel_func_ALU_connect : out STD_LOGIC_VECTOR (2 downto 0);
         sel_PC_Mux           : out STD_LOGIC_VECTOR (1 downto 0);
         Val_connect          : in STD_LOGIC;
         mem_rw_depth : out STD_LOGIC_vector(1 downto 0));
end decoblock;

architecture Behavioral of decoblock is

begin

process(opcode, funct3, funct7, Val_connect) 
begin
    case opcode is
    when "0110011" => -- Op reg-reg
                                            -- signaux communs a chaque instruction reg-reg
                                            imm_type <= "000"; -- Type R
                                            sel_op2 <= '0'; -- '00' si rs2, '01' si imm, "10" si auipc
                                            sel_result <= "00";
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            mem_rw_depth <= "00";
                                            
                                            -- calcul du signal pour chaque instruction
                                            case funct3 is
                                                when "000" => if(funct7="0100000") then 
                                                                                    sel_func_ALU <= "0010"; -- sub
                                                                                elsif(funct7="0000000") then  
                                                                                    sel_func_ALU <= "0001";-- add
                                                                                else
                                                                                    sel_func_ALU <= "0000"; -- nop    
                                                                                end if;
                                                when "001" => sel_func_ALU <= "1000"; -- sll
                                                when "010" => sel_func_ALU <= "0011"; -- slt
                                                when "011" => sel_func_ALU <= "0100"; -- sltu
                                                when "100" => sel_func_ALU <= "0111"; -- xor
                                                when "101" => if(funct7="0100000") then 
                                                                                    sel_func_ALU <= "1010"; -- sra
                                                                                elsif(funct7="0000000")then 
                                                                                    sel_func_ALU <= "1001"; -- srl
                                                                                else
                                                                                    sel_func_ALU <= "0000"; -- nop
                                                                                end if;
                                                when "110" => sel_func_ALU <= "0110"; -- or
                                                when "111" => sel_func_ALU <= "0101"; -- and
                                                when others => sel_func_ALU <= "0000"; -- nop
                                            end case;
    when "0010011" => -- Op reg-imm
                                            -- signaux communs a chaque instruction reg-imm
                                            imm_type <= "001"; -- Type I
                                            sel_op2 <= '1';
                                            sel_result <= "00";
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            mem_rw_depth <= "00";
            
                                            -- signal a modifier pour chaque instruction
                                            case funct3 is
                                                when "000" => -- addi
                                                    sel_func_ALU <= "0001";
                                                when "010" => -- slti
                                                    sel_func_ALU <= "0011";
                                                when "011" => -- sltiu
                                                    sel_func_ALU <= "0100";
                                                when "111" => -- andi
                                                    sel_func_ALU <= "0101";
                                                when "110" => -- ori
                                                    sel_func_ALU <= "0110";
                                                when "100" => -- xori
                                                    sel_func_ALU <= "0111";
                                                when "001" => -- slli
                                                    sel_func_ALU <= "1000";
                                                when "101" =>
                                                    if(funct7="0000000") then -- srli
                                                        sel_func_ALU <= "1001";
                                                    elsif(funct7="0100000") then -- srai
                                                        sel_func_ALU <= "1010";
                                                    else
                                                        sel_func_ALU <= "0000"; -- nop    
                                                    end if; 
                                                when others => sel_func_ALU <= "0000";                                                                       
                                            end case;
    when "0000011" => -- Op load
                                            -- signaux communs a chaque instruction load
                                            imm_type <= "001"; -- Type I
                                            sel_op2 <= '1';
                                            sel_result <= "01"; -- 00 pour l'ALU, 01 pour m�moire et 10 pour PC
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "0001";
                                            mem_rw_depth <= "00";
                                            
                                            -- signal a modifier pour chaque instruction
--                                            case funct3 is
--                                                 when "000" => -- lb
--                                                    sel_func_ALU <= "0001";
--                                                    mem_rw_depth <= "0001";
--                                                 when "001" => -- lh
--                                                    sel_func_ALU <= "0001";
--                                                    mem_rw_depth <= "0011";
--                                                 when "010" => -- lw
--                                                    sel_func_ALU <= "0001";
--                                                    mem_rw_depth <= "1111"; 
--                                                 when "100" => -- lbu
--                                                    sel_func_ALU <= "0001";
--                                                    mem_rw_depth <= "0001";
--                                                 when "101" => -- lhu
--                                                    sel_func_ALU <= "0001";
--                                                    mem_rw_depth <= "0011";  
--                                                 when others => sel_func_ALU <= "0000";
--                                                                mem_rw_depth <= "0000";                            
--                                            end case; 
    when "0100011" => -- Op Write
                                            -- signaux communs a chaque instruction write
                                            imm_type <= "010"; -- Type S
                                            sel_op2 <= '1';
                                            sel_result <= "01"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "0001";
                                            
                                            -- signal a modifier pour chaque instruction
                                            case funct3 is
                                                when "000" => -- sb
                                                    sel_func_ALU <= "0001";
                                                    mem_rw_depth <= "01";
                                                when "001" => -- sh
                                                    sel_func_ALU <= "0001";
                                                    mem_rw_depth <= "10";
                                                when "010" => -- sw
                                                    sel_func_ALU <= "0001";
                                                    mem_rw_depth <= "11";  
                                                when others => sel_func_ALU <= "0000";
                                                                mem_rw_depth <= "00";                                               
                                            end case;
    when "1100011" => -- Op control
                                            -- signaux communs a chaque instruction control
                                            imm_type <= "011"; -- Type B
                                            sel_op2 <= '0';
                                            sel_result <= "10"; -- 00 pour l'ALU, 01 pour m�moire et 10 pour PC                                                              
                                            sel_func_ALU <= "0000";
                                            mem_rw_depth <= "00";
                    
                                            -- signal a modifier pour chaque instruction
                                            case funct3 is
                                                 when "000" => -- beq
                                                    sel_func_ALU_connect <= "001";
                                                 when "001" => -- bne
                                                    sel_func_ALU_connect <= "010";
                                                 when "100" => -- blt
                                                    sel_func_ALU_connect <= "011"; 
                                                 when "101" => -- bge
                                                    sel_func_ALU_connect <= "100";
                                                 when "110" => -- bltu
                                                    sel_func_ALU_connect <= "101";
                                                 when "111" => -- bgeu
                                                    sel_func_ALU_connect <= "110";   
                                                 when others => sel_func_ALU_connect <= "000";                            
                                            end case;
                                            
                                            -- branchement
                                            if(Val_connect = '1') then
                                                sel_PC_Mux <= "01"; -- 01 pour les branchements, 10 pour jal, 00 sinon
                                            else
                                                sel_PC_Mux <= "00"; -- on continue normalement
                                            end if;                                  
    when "1101111" => -- Op Jal
                                            imm_type <= "101"; -- Type J
                                            sel_op2 <= '0';
                                            sel_result <= "10"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC
                                            sel_PC_Mux <= "01"; -- 01 pour les branchementset jal, 10 pour mettre le pc a 0, 11 pour jalr, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "0000";
                                            mem_rw_depth <= "00";
                                               
    when "1100111" => -- Op Jalr
                                            imm_type <= "001"; -- Type I            
                                            sel_op2 <= '1';
                                            sel_result <= "10"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC                   
                                            sel_PC_Mux <= "11"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "1100";
                                            mem_rw_depth <= "00";
                                            
    when "0110111" => -- Op Lui
                                            imm_type <= "100"; -- Type U         
                                            sel_op2 <= '1';
                                            sel_result <= "00"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC                   
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre � 0 le pc, 11 pour jalr, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "1011";
                                            mem_rw_depth <= "00";
                                            
    when "0010111" => -- Op Auipc ???
                                            imm_type <= "100"; -- Type U                                                      
                                            sel_op2 <= '0';                                             
                                            sel_result <= "00"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC                   
                                            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre � 0 le pc, 11 pour jalr, 00 sinon
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "1011";
                                            mem_rw_depth <= "00";                                                                                                                       
    when others =>
                                            imm_type <= "000";
                                            sel_op2 <= '0';
                                            sel_result <= "00";
                                            sel_PC_Mux <= "00";
                                            sel_func_ALU_connect <= "000";
                                            sel_func_ALU <= "0000";
                                            mem_rw_depth <= "00";
    end case;    
end process;

end Behavioral;