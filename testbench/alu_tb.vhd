library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

    signal a, b, result : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_control  : STD_LOGIC_VECTOR(2 downto 0);
    signal zero         : STD_LOGIC;

begin

    -- Instantiate ALU
    uut: entity work.ALU
        port map (
            a => a,
            b => b,
            alu_control => alu_control,
            result => result,
            zero => zero
        );

    -- Test process
    process
    begin

        -- Test 1: add two positive numbers
        a <= std_logic_vector(to_signed(2500, 32));
        b <= std_logic_vector(to_signed(25000, 32));
        alu_control <= "000";
        wait for 10 ns;

        -- Test 2: subtract the second value from the first
        a <= std_logic_vector(to_signed(540250, 32));
        b <= std_logic_vector(to_signed(37800, 32));
        alu_control <= "001";
        wait for 10 ns;

        -- Test 3: bitwise AND
        a <= std_logic_vector(to_signed(53957, 32));
        b <= std_logic_vector(to_signed(30000, 32));
        alu_control <= "010";
        wait for 10 ns;

        -- Test 4: bitwise OR
        a <= std_logic_vector(to_signed(746353, 32));
        b <= std_logic_vector(to_signed(846465, 32));
        alu_control <= "011";
        wait for 10 ns;

        -- Test 5: set less than
        a <= std_logic_vector(to_signed(58847537, 32));
        b <= std_logic_vector(to_signed(72464383, 32));
        alu_control <= "100";
        wait for 20 ns;

        report "ALU test completed!" severity note;

        wait; -- Stop the simulation here

    end process;

end Behavioral;