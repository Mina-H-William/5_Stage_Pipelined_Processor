LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main_tb IS
END main_tb;

ARCHITECTURE Behavioral OF main_tb IS

    -- Signals to connect to the DUT
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL memory_reset : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL memory_clk : STD_LOGIC := '0';
    SIGNAL input_port : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output_port : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL epc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ccr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL stack_pointer : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instruction : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL immediate : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL rsrc1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL rsrc2 : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- Clock period constants
    CONSTANT clk_period : TIME := 200 ns;
    CONSTANT memory_clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    UUT : ENTITY work.main
        PORT MAP(
            reset => reset,
            memory_reset => memory_reset,
            clk => clk,
            memory_clk => memory_clk,
            input_port => input_port,
            output_port => output_port,
            epc => epc,
            ccr => ccr,
            stack_pointer => stack_pointer,
            pc => pc,
            instruction => instruction,
            immediate => immediate,
            rsrc1 => rsrc1,
            rsrc2 => rsrc2
        );

    -- Clock generation for clk
    clk_process : PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR clk_period / 2;
        clk <= '0';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Clock generation for memory_clk
    memory_clk_process : PROCESS
    BEGIN
        memory_clk <= '0';
        WAIT FOR memory_clk_period / 2;
        memory_clk <= '1';
        WAIT FOR memory_clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus : PROCESS
    BEGIN
        -- Apply reset
        reset <= '1';
        memory_reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        memory_reset <= '0';

        -- Test 1: Provide some input data
        -- test1
        -- input_port <= X"0005";
        -- WAIT FOR 1000 ns;
        -- test2
        -- input_port <= X"0006";
        -- WAIT FOR 400 ns;
        -- test3
        input_port <= X"00F5";
        WAIT FOR 400 ns;

        -- Test 2: Modify input data
        -- test1
        -- input_port <= X"0010";
        -- WAIT FOR 2000 ns;
        -- test2
        -- input_port <= X"0020";
        -- WAIT FOR 2500 ns;

        -- Stop the simulation
        WAIT;
    END PROCESS;

END Behavioral;