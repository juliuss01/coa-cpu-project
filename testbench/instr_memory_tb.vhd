library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is

    signal pc          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: entity work.Instruction_Memory
        port map (
            pc => pc,
            instruction => instruction
        );

    process
    begin
        -- Task 4: read the four instructions from instruction memory
        
        -- Address 0: add $t0, $t1, $t2
        pc <= x"00000000";
        wait for 10 ns;
        report "Test PC=0" severity note;
        assert instruction = "00000000011001010000100000100000" report "Address 0 failed" severity error;

        -- Address 2: sub $t2, $t2, $t3
        pc <= x"00000002";
        wait for 10 ns;
        report "Test PC=2" severity note;
        assert instruction = "00000000101001110010100000100010" report "Address 2 failed" severity error;

        -- Address 4: and $t1, $t2, $t0
        pc <= x"00000004";
        wait for 10 ns;
        report "Test PC=4" severity note;
        assert instruction = "00000000101000010001100000100100" report "Address 4 failed" severity error;

        -- Address 6: or $t2, $t3, $t1
        pc <= x"00000006";
        wait for 10 ns;
        report "Test PC=6" severity note;
        assert instruction = "00000000111000110010100000100101" report "Address 6 failed" severity error;

        -- Anything past the last instruction should return NOP
        pc <= x"00000008";
        wait for 10 ns;
        report "Test PC=8" severity note;
        assert instruction = x"00000000" report "Out of range failed" severity error;

        report "All instruction memory tests passed!" severity note;
        wait;

    end process;

end Behavioral;
