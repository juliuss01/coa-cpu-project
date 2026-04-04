library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Sign extension unit for immediate values
entity Sign_Extend is
    Port (
        imm_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        imm_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Sign_Extend;

architecture Behavioral of Sign_Extend is
begin

    process(imm_in)
    begin
        if imm_in(15) = '1' then
            -- Negative value
            imm_out <= "1111111111111111" & imm_in;
        else
            -- Positive value
            imm_out <= "0000000000000000" & imm_in;
        end if;
    end process;

end Behavioral;
