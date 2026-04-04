library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_tb is
end Register_File_tb;

architecture Behavioral of Register_File_tb is

    signal clk           : STD_LOGIC := '0';
    signal rst           : STD_LOGIC := '0';
    signal reg_write_en  : STD_LOGIC := '0';
    signal read_addr1    : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal read_addr2    : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal write_addr    : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal write_data    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal read_data1    : STD_LOGIC_VECTOR(31 downto 0);
    signal read_data2    : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: entity work.Register_File
        port map (
            clk => clk,
            rst => rst,
            reg_write_en => reg_write_en,
            read_addr1 => read_addr1,
            read_addr2 => read_addr2,
            write_addr => write_addr,
            write_data => write_data,
            read_data1 => read_data1,
            read_data2 => read_data2
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Test process
    process
    begin

        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        -- WRITE values
        reg_write_en <= '1';

        write_addr <= "001"; -- Register 1
        write_data <= std_logic_vector(to_signed(1934858, 32));
        wait for 10 ns;

        write_addr <= "011"; -- Register 3
        write_data <= std_logic_vector(to_signed(8558447, 32));
        wait for 10 ns;

        write_addr <= "101"; -- Register 5
        write_data <= std_logic_vector(to_signed(203848544, 32));
        wait for 10 ns;

        write_addr <= "111"; -- Register 7
        write_data <= std_logic_vector(to_signed(20670420, 32));
        wait for 10 ns;

        reg_write_en <= '0';

        -- READ values
        read_addr1 <= "001";
        read_addr2 <= "011";
        wait for 10 ns;

        read_addr1 <= "101";
        read_addr2 <= "111";
        wait for 10 ns;

        wait;

    end process;

end Behavioral;