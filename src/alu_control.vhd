library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ALU control unit for the main datapath
-- Uses ALUOp and the function field to pick the operation
entity ALU_Control is
    Port (
        alu_op   : in  STD_LOGIC_VECTOR(1 downto 0);  -- Control code from the control unit
        funct    : in  STD_LOGIC_VECTOR(5 downto 0);  -- Function field for R-type instructions
        alu_ctrl : out STD_LOGIC_VECTOR(2 downto 0)   -- Control code sent to the ALU
    );
end ALU_Control;

architecture Behavioral of ALU_Control is
begin

    process(alu_op, funct)
    begin
        case alu_op is
            
            -- R-type instructions use the function field
            when "00" =>
                case funct is
                    when "100000" => -- add
                        alu_ctrl <= "000";
                    when "100010" => -- sub
                        alu_ctrl <= "001";
                    when "100100" => -- and
                        alu_ctrl <= "010";
                    when "100101" => -- or
                        alu_ctrl <= "011";
                    when "101010" => -- slt
                        alu_ctrl <= "100";
                    when others =>
                        alu_ctrl <= "000";
                end case;
            
            -- addi
            when "01" =>
                alu_ctrl <= "000";
            
            -- lw and sw
            when "10" =>
                alu_ctrl <= "000";
            
            -- beq
            when "11" =>
                alu_ctrl <= "001";
            
            when others =>
                alu_ctrl <= "000";
        end case;
    end process;

end Behavioral;
