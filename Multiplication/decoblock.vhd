library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
         mem_rw_depth : out STD_LOGIC_vector(3 downto 0));
end decoblock;
architecture Behavioral of decoblock is
begin

    process(opcode, funct3, funct7, Val_connect) is
    begin
        case opcode is
          when "0110011" => -- Op reg-reg
            -- signaux communs a chaque instruction reg-reg
            imm_type <= "000"; -- Type R
            sel_op2 <= '0'; -- '00' si rs2, '01' si imm, "10" si auipc
            sel_result <= "00";
            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
            sel_func_ALU_connect <= "000";
            mem_rw_depth <= "0000";

            -- calcul du signal pour chaque instruction
            case funct3 is
    when "000" =>
        if (funct7 = "0000000") then
            sel_func_ALU <= "0001"; -- add
    else
        sel_func_ALU <= "0000"; -- nop
    end if;
    when others => sel_func_ALU <= "0000";
end case;    when "0010011" => -- Op reg-imm
        -- signaux communs a chaque instruction reg-imm
        imm_type <= "001"; -- Type I
        sel_op2 <= '1';
        sel_result <= "00";
        sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
        sel_func_ALU_connect <= "000";
        mem_rw_depth <= "0000";

        -- signal a modifier pour chaque instruction
        case funct3 is
    when "000" => -- addi
        sel_func_ALU <= "0001";
    when others =>
        sel_func_ALU <= "0000";
    end case;
when "0000011" => -- Op load        imm_type <= "001"; -- Type I
        sel_op2 <= '1';
        sel_result <= "01"; -- 00 pour l'ALU, 01 pour mémoire et 10 pour PC
        sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
        sel_func_ALU_connect <= "000";
        sel_func_ALU <= "0001";
        mem_rw_depth <= "0000";
        case funct3 is 
    when "000" =>
        sel_func_ALU <= "0001";
        mem_rw_depth <= "0001";
    when others =>
        sel_func_ALU <= "0000";
        mem_rw_depth <= "0000";
end case;
    when "0100011" =>
        imm_type <= "010"; -- Type S
        sel_op2 <= '1';
        sel_result <= "01"; -- 00 pour l'ALU, 01 pour memoire et 10 pour PC
        sel_PC_Mux <= "00"; -- 01 pour les branchements, 10 pour jal, 00 sinon
        sel_func_ALU_connect <= "000";
        sel_func_ALU <= "0001";
        case funct3 is
        when "000" => -- sb
            sel_func_ALU <= "0001";
            mem_rw_depth <= "0001"; -- 01
    when others =>
        sel_func_ALU <= "0000";
        mem_rw_depth <= "0001";
    end case;
        when "1100011" =>
            imm_type <= "011"; -- Type B
            sel_op2 <= '0';
            sel_result <= "10"; -- 00 pour l'ALU, 01 pour mémoire et 10 pour PC
            sel_func_ALU <= "0000";
            mem_rw_depth <= "0000";
            case funct3 is        when "000" => -- beq
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
        when others =>
            sel_func_ALU_connect <= "000";
    end case;

    -- branchement
    if (Val_connect = '1') then
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
            mem_rw_depth <= "0000";
        when "1100111" => -- Op Jalr
            imm_type <= "001"; -- Type I
            sel_op2 <= '1';
            sel_result <= "10"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder
            sel_PC_Mux <= "11"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
            sel_func_ALU_connect <= "000";
            sel_func_ALU <= "1100";
            mem_rw_depth <= "0000";
        when "0110111" => -- Op Lui
            imm_type <= "100"; -- Type U
            sel_op2 <= '1';
            sel_result <= "00"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder
            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
            sel_func_ALU_connect <= "000";
            sel_func_ALU <= "1011";
            mem_rw_depth <= "0000";
        when "0010111" => -- Op Auipc
            imm_type <= "100"; -- Type U
            sel_op2 <= '0';
            sel_result <= "11"; -- 00 pour l'ALU, 01 pour memoire, 10 pour PC et 11 pour l'Adder
            sel_PC_Mux <= "00"; -- 01 pour les branchements et jal, 10 pour mettre a 0 le pc, 11 pour jalr, 00 sinon
            sel_func_ALU_connect <= "000";
            sel_func_ALU <= "1011";
            mem_rw_depth <= "0000";
   when"1111111"=>
            imm_type<="000";
            sel_op2<='0';
            sel_result<="00";
            sel_PC_Mux<="00";
            mem_rw_depth<="0000";
            sel_func_ALU<="1111";
            sel_func_ALU_connect<="000";
            case funct3 is
                    when "000" => 
                        if (funct7 = "0000000") then
                            sel_func_ALU <= "1111"; 
                    else
                        sel_func_ALU <= "0000"; 
                    end if;
                       when others => sel_func_ALU <= "0000";
            end case;
    when others =>
        imm_type <= "000";
        sel_op2 <= '0';
        sel_result <= "00";
        sel_PC_Mux <= "00";
        sel_func_ALU_connect <= "000";
        sel_func_ALU <= "0000";
        mem_rw_depth <= "0000";
    end case;
end process;
end Behavioral;
