LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instruction_memory_tb IS
END instruction_memory_tb;

ARCHITECTURE behavior OF instruction_memory_tb IS
    -- Component declaration for the unit under test (UUT)
    COMPONENT instruction_memory
        PORT (
            pc          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            enable      : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_0        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_1        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_2        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_3        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_4        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_5        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_6        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_7        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL pc          : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    SIGNAL enable      : STD_LOGIC := '0';
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_0        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_1        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_2        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_3        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_4        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_5        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_6        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_7        : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- Instantiate the unit under test (UUT)
    uut: instruction_memory
        PORT MAP (
            pc => pc,
            enable => enable,
            instruction => instruction,
            IM_0 => IM_0,
            IM_1 => IM_1,
            IM_2 => IM_2,
            IM_3 => IM_3,
            IM_4 => IM_4,
            IM_5 => IM_5,
            IM_6 => IM_6,
            IM_7 => IM_7
        );

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initial setup
        enable <= '0';
        WAIT FOR 10 ns;

        -- Test case: Load instructions from the file
        enable <= '1';  -- Enable loading the instructions from file
        WAIT FOR 10 ns;

        -- Disable loading and simulate instruction fetch for the first five memory locations
        -- enable <= '0';  -- Disable loading to test instruction fetch

        -- Test: Read from instruction memory and check the first 5 locations
        pc <= "0000000000000000";  -- Fetch instruction at address 0
        WAIT FOR 10 ns;
    

        pc <= "0000000000000001";  -- Fetch instruction at address 1
        WAIT FOR 10 ns;


        pc <= "0000000000000010";  -- Fetch instruction at address 2
        WAIT FOR 10 ns;
   

        pc <= "0000000000000011";  -- Fetch instruction at address 3
        WAIT FOR 10 ns;
  
        pc <= "0000000000000100";  -- Fetch instruction at address 4
        WAIT FOR 10 ns;

        -- Add more address checks as needed

        WAIT; -- End simulation
    END PROCESS;
END behavior;
