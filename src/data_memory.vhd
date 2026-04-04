library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    Port (
        clk              : in  STD_LOGIC;
        mem_access_addr  : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_write_data   : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_write_en     : in  STD_LOGIC;
        mem_read         : in  STD_LOGIC;
        mem_read_data    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is

    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal RAM : memory_array := (others => (others => '0'));

    signal addr_index : integer range 0 to 255;

begin

    -- Use the lower address bits to pick the memory location
    addr_index <= to_integer(unsigned(mem_access_addr(7 downto 0)));

    process(clk)
    begin
        if rising_edge(clk) then

            -- Store data when write enable is active
            if mem_write_en = '1' then
                RAM(addr_index) <= mem_write_data;
            end if;

            -- Output the selected word when read is active
            if mem_read = '1' then
                mem_read_data <= RAM(addr_index);
            else
                mem_read_data <= (others => '0');
            end if;

        end if;
    end process;

end Behavioral;