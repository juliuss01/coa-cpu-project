library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Control_tb is
end ALU_Control_tb;

architecture Behavioral of ALU_Control_tb is

    signal alu_op   : STD_LOGIC_VECTOR(1 downto 0);
    signal funct    : STD_LOGIC_VECTOR(5 downto 0);
    signal alu_ctrl : STD_LOGIC_VECTOR(2 downto 0);

begin

    uut: entity work.ALU_Control
        port map (
            alu_op => alu_op,
            funct => funct,
            alu_ctrl => alu_ctrl
        );

    process
    begin
        -- Test 1: R-format ADD (alu_op=00, funct=100000)
        alu_op <= "00";
        funct <= "100000";
        wait for 10 ns;
        assert alu_ctrl = "000" report "ADD test failed" severity error;

        -- Test 2: R-format SUB (alu_op=00, funct=100010)
        alu_op <= "00";
        funct <= "100010";
        wait for 10 ns;
        assert alu_ctrl = "001" report "SUB test failed" severity error;

        -- Test 3: R-format AND (alu_op=00, funct=100100)
        alu_op <= "00";
        funct <= "100100";
        wait for 10 ns;
        assert alu_ctrl = "010" report "AND test failed" severity error;

        -- Test 4: R-format OR (alu_op=00, funct=100101)
        alu_op <= "00";
        funct <= "100101";
        wait for 10 ns;
        assert alu_ctrl = "011" report "OR test failed" severity error;

        -- Test 5: R-format SLT (alu_op=00, funct=101010)
        alu_op <= "00";
        funct <= "101010";
        wait for 10 ns;
        assert alu_ctrl = "100" report "SLT test failed" severity error;

        -- Test 6: ADDI (alu_op=01)
        alu_op <= "01";
        funct <= "000000";
        wait for 10 ns;
        assert alu_ctrl = "000" report "ADDI test failed" severity error;

        -- Test 7: LW/SW (alu_op=10)
        alu_op <= "10";
        funct <= "000000";
        wait for 10 ns;
        assert alu_ctrl = "000" report "LW/SW test failed" severity error;

        -- Test 8: BEQ (alu_op=11)
        alu_op <= "11";
        funct <= "000000";
        wait for 10 ns;
        assert alu_ctrl = "001" report "BEQ test failed" severity error;

        report "All ALU Control tests passed!" severity note;
        wait;

    end process;

end Behavioral;
