library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    Port (
        clk              : in  STD_LOGIC;
        rst              : in  STD_LOGIC;
        reg_write_en     : in  STD_LOGIC;
        read_addr1       : in  STD_LOGIC_VECTOR(2 downto 0);
        read_addr2       : in  STD_LOGIC_VECTOR(2 downto 0);
        write_addr       : in  STD_LOGIC_VECTOR(2 downto 0);
        write_data       : in  STD_LOGIC_VECTOR(31 downto 0);
        read_data1       : out STD_LOGIC_VECTOR(31 downto 0);
        read_data2       : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Register_File;

architecture Behavioral of Register_File is

    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (
        0 => x"00000001",
        1 => x"00000002",
        2 => x"00000003",
        3 => x"00000004",
        4 => x"00000005",
        5 => x"00000006",
        6 => x"00000007",
        7 => x"00000008"
    );

begin

    -- Reset restores the default register values and the clock edge handles writes
    process(clk, rst)
    begin
        if rst = '1' then
            registers(0) <= x"00000001";
            registers(1) <= x"00000002";
            registers(2) <= x"00000003";
            registers(3) <= x"00000004";
            registers(4) <= x"00000005";
            registers(5) <= x"00000006";
            registers(6) <= x"00000007";
            registers(7) <= x"00000008";
        elsif rising_edge(clk) then
            if reg_write_en = '1' then
                if write_addr /= "000" then
                    registers(to_integer(unsigned(write_addr))) <= write_data;
                end if;
            end if;
        end if;
    end process;

    -- Register 0 always reads as zero
    read_data1 <= x"00000000" when read_addr1 = "000" else registers(to_integer(unsigned(read_addr1)));
    read_data2 <= x"00000000" when read_addr2 = "000" else registers(to_integer(unsigned(read_addr2)));

end Behavioral;