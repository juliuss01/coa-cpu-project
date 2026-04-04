library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory_tb is
end Data_Memory_tb;

architecture Behavioral of Data_Memory_tb is

    signal clk              : STD_LOGIC := '0';
    signal mem_access_addr  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_data   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_en     : STD_LOGIC := '0';
    signal mem_read         : STD_LOGIC := '0';
    signal mem_read_data    : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: entity work.Data_Memory
        port map (
            clk => clk,
            mem_access_addr => mem_access_addr,
            mem_write_data => mem_write_data,
            mem_write_en => mem_write_en,
            mem_read => mem_read,
            mem_read_data => mem_read_data
        );

    -- Clock generator
    process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Test cases from the assignment
    process
    begin

        -- Test 1: write 1024 to address 2 and read it back
        mem_access_addr <= std_logic_vector(to_unsigned(2, 32));
        mem_write_data  <= std_logic_vector(to_unsigned(1024, 32));
        mem_write_en    <= '1';
        wait for 10 ns;

        mem_write_en <= '0';

        -- Read the value back
        mem_read <= '1';
        wait for 10 ns;

        mem_read <= '0';


        -- Test 2: write 429496 to address 4 and read it back
        mem_access_addr <= std_logic_vector(to_unsigned(4, 32));
        mem_write_data  <= std_logic_vector(to_unsigned(429496, 32));
        mem_write_en    <= '1';
        wait for 10 ns;

        mem_write_en <= '0';

        -- Read the value back
        mem_read <= '1';
        wait for 10 ns;

        mem_read <= '0';

        wait;

    end process;

end Behavioral;
