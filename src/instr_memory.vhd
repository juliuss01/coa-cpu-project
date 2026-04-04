library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Instruction Memory - Holds the test program used by the CPU
entity Instruction_Memory is
    Port (
        pc          : in  STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)   -- Fetched instruction
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    -- Store four 32-bit instructions for the task
    type instruction_array is array (0 to 3) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Task 4 instruction sequence
    
    constant rom_data : instruction_array := (
        -- add $t0, $t1, $t2
        0 => "00000000011001010000100000100000",
        
        -- sub $t2, $t2, $t3
        1 => "00000000101001110010100000100010",
        
        -- and $t1, $t2, $t0
        2 => "00000000101000010001100000100100",
        
        -- or $t2, $t3, $t1
        3 => "00000000111000110010100000100101",
        
        others => "00000000000000000000000000000000"
    );

begin

    process(pc)
        variable addr_index : integer;
    begin
        -- Each instruction is 2 bytes, so the address uses pc(4 downto 1)
        addr_index := to_integer(unsigned(pc(4 downto 1)));

        if unsigned(pc) > to_unsigned(6, pc'length) then
            -- Return NOP if the address goes past the test program
            instruction <= x"00000000";
        else
            instruction <= rom_data(addr_index);
        end if;
    end process;

end Behavioral;
