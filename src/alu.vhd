library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        a, b        : in  STD_LOGIC_VECTOR(31 downto 0);
        alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
        result      : out STD_LOGIC_VECTOR(31 downto 0);
        zero        : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
    signal res : STD_LOGIC_VECTOR(31 downto 0);
begin

    process(a, b, alu_control)
    begin
        case alu_control is

            when "000" => -- Add the two inputs
                res <= std_logic_vector(signed(a) + signed(b));

            when "001" => -- Subtract b from a
                res <= std_logic_vector(signed(a) - signed(b));

            when "010" => -- Bitwise AND
                res <= a and b;

            when "011" => -- Bitwise OR
                res <= a or b;

            when "100" => -- Set result to 1 when a is less than b
                if signed(a) < signed(b) then
                    res <= x"00000001";
                else
                    res <= x"00000000";
                end if;

            when others =>
                res <= (others => '0');

        end case;
    end process;

    result <= res;

    -- Raise zero when the result is all zeros
    zero <= '1' when res = x"00000000" else '0';

end Behavioral;