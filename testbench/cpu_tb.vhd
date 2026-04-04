library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_tb is
end CPU_tb;

architecture Behavioral of CPU_tb is

    signal clk              : STD_LOGIC := '0';
    signal rst              : STD_LOGIC := '0';
    signal pc_out           : STD_LOGIC_VECTOR(31 downto 0);
    signal instruction_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_result_out   : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_data_out     : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: entity work.CPU
        port map (
            clk => clk,
            rst => rst,
            pc_out => pc_out,
            instruction_out => instruction_out,
            alu_result_out => alu_result_out,
            mem_data_out => mem_data_out
        );

    -- Clock generator
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Test sequence
    test_process: process
    begin
        -- Start with a reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Let the CPU run through the instruction stream
        
        -- Cycle 0: add $t0, $t1, $t2
        wait for 10 ns;
        report "Cycle 0: Executing ADD" severity note;

        -- Cycle 1: sub $t2, $t2, $t3
        wait for 10 ns;
        report "Cycle 1: Executing SUB" severity note;

        -- Cycle 2: and $t1, $t2, $t0
        wait for 10 ns;
        report "Cycle 2: Executing AND" severity note;

        -- Cycle 3: or $t2, $t3, $t1
        wait for 10 ns;
        report "Cycle 3: Executing OR" severity note;

        -- Cycle 4: addi $t1, $t0, 100
        wait for 10 ns;
        report "Cycle 4: Executing ADDI" severity note;

        -- Cycle 5: lw $t0, 0($sp)
        wait for 10 ns;
        report "Cycle 5: Executing LW" severity note;

        -- Cycle 6: sw $t0, 0($sp)
        wait for 10 ns;
        report "Cycle 6: Executing SW" severity note;

        -- Cycle 7: beq $t0, $t1, 4
        wait for 10 ns;
        report "Cycle 7: Executing BEQ" severity note;

        -- Cycle 8: j 0
        wait for 10 ns;
        report "Cycle 8: Executing J" severity note;

        -- Cycle 9: jal 0
        wait for 10 ns;
        report "Cycle 9: Executing JAL" severity note;

        report "CPU test simulation completed!" severity note;
        wait;

    end process;

end Behavioral;
