library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit_tb is
end Control_Unit_tb;

architecture Behavioral of Control_Unit_tb is

        signal opcode    : STD_LOGIC_VECTOR(5 downto 0);
    signal reset     : STD_LOGIC := '0';
        signal reg_dst   : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_src   : STD_LOGIC;
        signal mem_to_reg: STD_LOGIC_VECTOR(1 downto 0);
    signal mem_write : STD_LOGIC;
    signal mem_read  : STD_LOGIC;
    signal branch    : STD_LOGIC;
    signal jump      : STD_LOGIC;
    signal reg_write : STD_LOGIC;
    signal sign_or_zero : STD_LOGIC;
    signal alu_op    : STD_LOGIC_VECTOR(1 downto 0);

begin

    uut: entity work.Control_Unit
        port map (
            opcode => opcode,
            reset => reset,
            reg_dst => reg_dst,
            alu_src => alu_src,
            mem_to_reg => mem_to_reg,
            mem_write => mem_write,
            mem_read => mem_read,
            branch => branch,
            jump => jump,
            reg_write => reg_write,
            sign_or_zero => sign_or_zero,
            alu_op => alu_op
        );

    process
    begin
        -- Task 5: show the control signals for each opcode
        
        -- add
        opcode <= "000000";
        reset <= '0';
        wait for 10 ns;
        report "ADD: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- addi
        opcode <= "001000";
        wait for 10 ns;
        report "ADDI: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- slti
        opcode <= "001010";
        wait for 10 ns;
        report "SLTI: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- beq
        opcode <= "000100";
        wait for 10 ns;
        report "BEQ: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- j
        opcode <= "000010";
        wait for 10 ns;
        report "J: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- jal
        opcode <= "000011";
        wait for 10 ns;
        report "JAL: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- lw
        opcode <= "100011";
        wait for 10 ns;
        report "LW: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        -- sw
        opcode <= "101011";
        wait for 10 ns;
        report "SW: reg_dst="&std_logic'image(reg_dst(1))&std_logic'image(reg_dst(0))&" alu_src="&std_logic'image(alu_src)&
                " mem_to_reg="&std_logic'image(mem_to_reg(1))&std_logic'image(mem_to_reg(0))&" mem_write="&std_logic'image(mem_write)&
                " mem_read="&std_logic'image(mem_read)&" branch="&std_logic'image(branch)&
                " jump="&std_logic'image(jump)&" reg_write="&std_logic'image(reg_write)&
                " sign_or_zero="&std_logic'image(sign_or_zero) severity note;

        report "Control unit test completed!" severity note;
        wait;

    end process;

end Behavioral;
