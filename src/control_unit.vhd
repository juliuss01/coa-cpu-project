library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Main Control Unit - Decodes 6-bit MIPS opcode to generate control signals
entity Control_Unit is
    Port (
        opcode       : in  STD_LOGIC_VECTOR(5 downto 0);
        reset        : in  STD_LOGIC;        -- Reset signal
        
        reg_dst      : out STD_LOGIC_VECTOR(1 downto 0);  -- 00=rt, 01=rd, 10=$ra
        alu_src      : out STD_LOGIC;        -- ALU source select (0=reg, 1=immediate)
        mem_to_reg   : out STD_LOGIC_VECTOR(1 downto 0);  -- 00=ALU, 01=memory, 10=PC+4
        mem_write    : out STD_LOGIC;        -- Memory write enable
        mem_read     : out STD_LOGIC;        -- Memory read enable
        branch       : out STD_LOGIC;        -- Branch enable
        jump         : out STD_LOGIC;        -- Jump enable
        reg_write    : out STD_LOGIC;        -- Register write enable
        sign_or_zero : out STD_LOGIC;        -- Sign extend (1) or zero extend (0)
        alu_op       : out STD_LOGIC_VECTOR(1 downto 0)  -- ALU operation type
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
begin

    process(opcode, reset)
    begin
        -- Default everything to a safe NOP-like state
        reg_dst <= "00";
        alu_src <= '0';
        mem_to_reg <= "00";
        mem_write <= '0';
        mem_read <= '0';
        branch <= '0';
        jump <= '0';
        reg_write <= '0';
        sign_or_zero <= '1';  -- Default: sign extend
        alu_op <= "00";
        
        if reset = '1' then
            -- Reset clears the control outputs
            reg_dst <= "00";
            alu_src <= '0';
            mem_to_reg <= "00";
            mem_write <= '0';
            mem_read <= '0';
            branch <= '0';
            jump <= '0';
            reg_write <= '0';
            sign_or_zero <= '1';
            alu_op <= "00";
        else
            -- Decode the 6-bit opcode into the control signals
            case opcode is
            
                -- R-type instructions
                when "000000" =>
                    -- Use rd and write the ALU result back to the register file
                    reg_dst <= "01";    -- rd is destination
                    alu_src <= '0';      -- Use register
                    mem_to_reg <= "00"; -- Use ALU result
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '0';         -- No jump
                    reg_write <= '1';    -- Write to register
                    sign_or_zero <= '1'; -- Sign extend (not used for R-format)
                    alu_op <= "00";      -- Check function code
                
                -- Add immediate
                when "001000" =>
                    reg_dst <= "00";    -- rt is destination
                    alu_src <= '1';      -- Use immediate
                    mem_to_reg <= "00"; -- Use ALU result
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '0';         -- No jump
                    reg_write <= '1';    -- Write to register
                    sign_or_zero <= '1'; -- Sign extend immediate
                    alu_op <= "11";      -- ADD operation
                
                -- Set less than immediate
                when "001010" =>
                    reg_dst <= "00";    -- rt is destination
                    alu_src <= '1';      -- Use immediate
                    mem_to_reg <= "00"; -- Use ALU result
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '0';         -- No jump
                    reg_write <= '1';    -- Write to register
                    sign_or_zero <= '1'; -- Sign extend immediate
                    alu_op <= "10";      -- SLT operation
                
                -- Branch if equal
                when "000100" =>
                    reg_dst <= "00";    -- Don't care
                    alu_src <= '0';      -- Use register
                    mem_to_reg <= "00"; -- Don't care
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '1';       -- Branch enabled
                    jump <= '0';         -- No jump
                    reg_write <= '0';    -- No register write
                    sign_or_zero <= '1'; -- Sign extend for branch offset
                    alu_op <= "01";      -- SUB (for comparison)
                
                -- Jump
                when "000010" =>
                    reg_dst <= "00";    -- Don't care
                    alu_src <= '0';      -- Don't care
                    mem_to_reg <= "00"; -- Don't care
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '1';         -- Jump enabled
                    reg_write <= '0';    -- No register write
                    sign_or_zero <= '1'; -- Don't care
                    alu_op <= "00";      -- Don't care
                
                -- Jump and link
                when "000011" =>
                    reg_dst <= "10";    -- $ra is destination
                    alu_src <= '0';      -- Don't care
                    mem_to_reg <= "10"; -- Write PC + 4
                    mem_write <= '0';    -- No memory write
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '1';         -- Jump enabled
                    reg_write <= '1';    -- Write return address to $ra (reg 31)
                    sign_or_zero <= '1'; -- Don't care
                    alu_op <= "00";      -- Don't care
                
                -- Load word
                when "100011" =>
                    reg_dst <= "00";    -- rt is destination
                    alu_src <= '1';      -- Use immediate (for address offset)
                    mem_to_reg <= "01"; -- Use memory data
                    mem_write <= '0';    -- No memory write
                    mem_read <= '1';     -- Memory read enabled
                    branch <= '0';       -- No branch
                    jump <= '0';         -- No jump
                    reg_write <= '1';    -- Write to register
                    sign_or_zero <= '1'; -- Sign extend offset
                    alu_op <= "11";      -- ADD (for address calculation)
                
                -- Store word
                when "101011" =>
                    reg_dst <= "00";    -- Don't care
                    alu_src <= '1';      -- Use immediate (for address offset)
                    mem_to_reg <= "00"; -- Don't care
                    mem_write <= '1';    -- Memory write enabled
                    mem_read <= '0';     -- No memory read
                    branch <= '0';       -- No branch
                    jump <= '0';         -- No jump
                    reg_write <= '0';    -- No register write
                    sign_or_zero <= '1'; -- Sign extend offset
                    alu_op <= "11";      -- ADD (for address calculation)
                
                when others =>
                    -- Anything unsupported stays idle
                    reg_dst <= "00";
                    alu_src <= '0';
                    mem_to_reg <= "00";
                    mem_write <= '0';
                    mem_read <= '0';
                    branch <= '0';
                    jump <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                    alu_op <= "00";
            
            end case;
        end if;
    end process;

end Behavioral;
