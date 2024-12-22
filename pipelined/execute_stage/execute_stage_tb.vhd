
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY excute_stage_tb IS
END ENTITY;

ARCHITECTURE testbench OF excute_stage_tb IS

    COMPONENT excute_stage
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            is_immediate : IN STD_LOGIC;
            forward1_signal : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            forward2_signal : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            jz_signal : IN STD_LOGIC;
            jn_signal : IN STD_LOGIC;
            jc_signal : IN STD_LOGIC;
            jump_signal : IN STD_LOGIC;
            call_signal : IN STD_LOGIC;
            jumping_out_signal : OUT STD_LOGIC;
            pass_data1_signal : IN STD_LOGIC;
            pass_data2_signal : IN STD_LOGIC;
            not_signal : IN STD_LOGIC;
            add_offset_signal : IN STD_LOGIC;
            alu_func_signal : IN STD_LOGIC;
            alu_func : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            in_signal : IN STD_LOGIC;
            input_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_forward_mem : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_forward_wb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            rsrc1_from_excute : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            set_Carry : IN STD_LOGIC;
            rti_from_wb_signal : IN STD_LOGIC;
            flags_from_mem : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL is_immediate : STD_LOGIC := '0';
    SIGNAL forward1_signal : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL forward2_signal : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL jz_signal : STD_LOGIC := '0';
    SIGNAL jn_signal : STD_LOGIC := '0';
    SIGNAL jc_signal : STD_LOGIC := '0';
    SIGNAL jump_signal : STD_LOGIC := '0';
    SIGNAL call_signal : STD_LOGIC := '0';
    SIGNAL jumping_out_signal : STD_LOGIC;
    SIGNAL pass_data1_signal : STD_LOGIC := '0';
    SIGNAL pass_data2_signal : STD_LOGIC := '0';
    SIGNAL not_signal : STD_LOGIC := '0';
    SIGNAL add_offset_signal : STD_LOGIC := '0';
    SIGNAL alu_func_signal : STD_LOGIC := '0';
    SIGNAL alu_func : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in_signal : STD_LOGIC := '0';
    SIGNAL input_port : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_forward_mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_forward_wb : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL immediate : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rsrc1_from_excute : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL set_Carry : STD_LOGIC := '0';
    SIGNAL rti_from_wb_signal : STD_LOGIC := '0';
    SIGNAL flags_from_mem : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL flags_out : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Clock generation
    CONSTANT clk_period : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : excute_stage
    PORT MAP(
        rst => rst,
        clk => clk,
        is_immediate => is_immediate,
        forward1_signal => forward1_signal,
        forward2_signal => forward2_signal,
        jz_signal => jz_signal,
        jn_signal => jn_signal,
        jc_signal => jc_signal,
        jump_signal => jump_signal,
        call_signal => call_signal,
        jumping_out_signal => jumping_out_signal,
        pass_data1_signal => pass_data1_signal,
        pass_data2_signal => pass_data2_signal,
        not_signal => not_signal,
        add_offset_signal => add_offset_signal,
        alu_func_signal => alu_func_signal,
        alu_func => alu_func,
        in_signal => in_signal,
        input_port => input_port,
        data1 => data1,
        data2 => data2,
        data_forward_mem => data_forward_mem,
        data_forward_wb => data_forward_wb,
        immediate => immediate,
        rsrc1_from_excute => rsrc1_from_excute,
        data_out => data_out,
        set_Carry => set_Carry,
        rti_from_wb_signal => rti_from_wb_signal,
        flags_from_mem => flags_from_mem,
        flags_out => flags_out
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Initialize Inputs
        rst <= '1';
        WAIT FOR clk_period * 2;
        rst <= '0';

        -- Test case 1: Simple operation
        is_immediate <= '0';
        forward1_signal <= "00";
        forward2_signal <= "00";
        jz_signal <= '0';
        jn_signal <= '0';
        jc_signal <= '0';
        jump_signal <= '0';
        call_signal <= '0';
        pass_data1_signal <= '0';
        pass_data2_signal <= '0';
        not_signal <= '0';
        add_offset_signal <= '0';
        alu_func_signal <= '1';
        alu_func <= "00";
        in_signal <= '0';
        input_port <= x"0000";
        data1 <= x"0001";
        data2 <= x"0001";
        data_forward_mem <= x"0000";
        data_forward_wb <= x"0000";
        immediate <= x"0000";
        set_Carry <= '0';
        rti_from_wb_signal <= '0';
        flags_from_mem <= "000";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0002" REPORT "Test case 1 failed" SEVERITY ERROR;

        -- Test case 2: Immediate operation
        is_immediate <= '1';
        immediate <= x"0002";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0003" REPORT "Test case 2 failed" SEVERITY ERROR;

        -- Test case 3: Forwarding from MEM
        forward1_signal <= "01";
        data_forward_mem <= x"0003";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0005" REPORT "Test case 3 failed" SEVERITY ERROR;

        -- Test case 4: Forwarding from WB
        forward2_signal <= "10";
        data_forward_wb <= x"ffff";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0002" REPORT "Test case 4 failed" SEVERITY ERROR;

        -- Test case 5: Jump conditions
        jc_signal <= '1';
        WAIT FOR clk_period * 10;
        ASSERT jumping_out_signal = '1' REPORT "Test case 5 failed" SEVERITY ERROR;
        jc_signal <= '0';

        -- Test case 6: Jump signal
        jump_signal <= '1';
        WAIT FOR clk_period * 10;
        ASSERT jumping_out_signal = '1' REPORT "Test case 6 failed" SEVERITY ERROR;
        jump_signal <= '0';

        forward1_signal <= "00";
        alu_func_signal <= '0';
        -- Test case 9: Pass data 1
        pass_data1_signal <= '1';
        data1 <= x"0005";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0005" REPORT "Test case 9 failed" SEVERITY ERROR;
        pass_data1_signal <= '0';

        is_immediate <= '0';
        forward2_signal <= "00";
        -- Test case 10: Pass data 2
        pass_data2_signal <= '1';
        data2 <= x"0006";
        WAIT FOR clk_period * 10;
        ASSERT data_out = x"0006" REPORT "Test case 10 failed" SEVERITY ERROR;
        pass_data2_signal <= '0';

        -- End simulation
        WAIT;
    END PROCESS;
END ARCHITECTURE;