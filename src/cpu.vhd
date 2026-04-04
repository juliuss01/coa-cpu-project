library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 32-bit single-cycle CPU used for the project
entity CPU is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        
        -- Output signals for monitoring
        pc_out          : out STD_LOGIC_VECTOR(31 downto 0);
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0);
        alu_result_out  : out STD_LOGIC_VECTOR(31 downto 0);
        mem_data_out    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end CPU;

architecture Behavioral of CPU is

    -- Internal CPU signals
    signal pc, pc_next : STD_LOGIC_VECTOR(31 downto 0);
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Fields taken directly from the fetched instruction
    signal opcode   : STD_LOGIC_VECTOR(5 downto 0);
    signal rs, rt, rd : STD_LOGIC_VECTOR(4 downto 0);
    signal immediate : STD_LOGIC_VECTOR(15 downto 0);
    signal funct    : STD_LOGIC_VECTOR(5 downto 0);
    signal jump_addr : STD_LOGIC_VECTOR(25 downto 0);
    
    -- Control signals coming from the control unit
    signal reg_dst, mem_to_reg : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_src : STD_LOGIC;
    signal mem_write, mem_read, branch : STD_LOGIC;
    signal jump, reg_write : STD_LOGIC;
    signal sign_or_zero : STD_LOGIC;
    signal alu_op : STD_LOGIC_VECTOR(1 downto 0);
    
    -- Register file connections
    signal reg_read_data1, reg_read_data2 : STD_LOGIC_VECTOR(31 downto 0);
    signal write_data : STD_LOGIC_VECTOR(31 downto 0);
    signal write_addr : STD_LOGIC_VECTOR(2 downto 0);
    
    -- ALU connections
    signal alu_control : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_result : STD_LOGIC_VECTOR(31 downto 0);
    signal zero_flag : STD_LOGIC;
    signal alu_b : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Extended immediate value
    signal imm_extended : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Data memory signals
    signal mem_read_data : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Address calculations for branch and jump
    signal branch_addr : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_plus2 : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Pull out the instruction fields
    opcode <= instruction(31 downto 26);
    rs <= instruction(25 downto 21);
    rt <= instruction(20 downto 16);
    rd <= instruction(15 downto 11);
    immediate <= instruction(15 downto 0);
    funct <= instruction(5 downto 0);
    jump_addr <= instruction(25 downto 0);
    
    -- Instruction memory
    instr_mem : entity work.Instruction_Memory
        port map (
            pc => pc,
            instruction => instruction
        );
    
    -- Control unit
    ctrl_unit : entity work.Control_Unit
        port map (
            opcode => opcode,
            reset => rst,
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
    
    -- Register file
    reg_file : entity work.Register_File
        port map (
            clk => clk,
            rst => rst,
            reg_write_en => reg_write,
            read_addr1 => rs(2 downto 0),
            read_addr2 => rt(2 downto 0),
            write_addr => write_addr,
            write_data => write_data,
            read_data1 => reg_read_data1,
            read_data2 => reg_read_data2
        );
    
        -- Choose the destination register
        write_addr <= rd(2 downto 0) when reg_dst = "01" else
                      "111" when reg_dst = "10" else
                      rt(2 downto 0);
    
    -- Sign extension
    sign_ext : entity work.Sign_Extend
        port map (
            imm_in => immediate,
            imm_out => imm_extended
        );
    
    -- ALU control
    alu_ctrl_unit : entity work.ALU_Control
        port map (
            alu_op => alu_op,
            funct => funct,
            alu_ctrl => alu_control
        );
    
    -- Select the second ALU input
    alu_b <= imm_extended when alu_src = '1' else reg_read_data2;
    
    -- ALU
    alu_unit : entity work.ALU
        port map (
            a => reg_read_data1,
            b => alu_b,
            alu_control => alu_control,
            result => alu_result,
            zero => zero_flag
        );
    
    -- Data memory
    data_mem : entity work.Data_Memory
        port map (
            clk => clk,
            mem_access_addr => alu_result,
            mem_write_data => reg_read_data2,
            mem_write_en => mem_write,
            mem_read => mem_read,
            mem_read_data => mem_read_data
        );
    
    -- Choose what gets written back to the register file
    write_data <= mem_read_data when mem_to_reg = "01" else
                  pc_plus2 when mem_to_reg = "10" else
                  alu_result;
    
    -- Program counter logic
    pc_plus2 <= std_logic_vector(unsigned(pc) + 2);
    
    -- Branch target uses the immediate shifted by one bit
    branch_addr <= std_logic_vector(signed(pc_plus2) + shift_left(signed(imm_extended), 1));
    
    -- Pick the next PC value
    process(jump, branch, zero_flag, pc_plus2, branch_addr, jump_addr)
    begin
        if jump = '1' then
            -- Jump uses the upper PC bits and the shifted jump target
            pc_next <= pc(31 downto 27) & jump_addr & '0';
        elsif branch = '1' and zero_flag = '1' then
            -- Branch when the comparison says the values match
            pc_next <= branch_addr;
        else
            -- Default to the next instruction
            pc_next <= pc_plus2;
        end if;
    end process;
    
    -- Update the PC on each clock edge
    process(clk, rst)
    begin
        if rst = '1' then
            pc <= (others => '0');
        elsif rising_edge(clk) then
            pc <= pc_next;
        end if;
    end process;
    
    -- Top-level outputs
    pc_out <= pc;
    instruction_out <= instruction;
    alu_result_out <= alu_result;
    mem_data_out <= mem_read_data;

end Behavioral;
