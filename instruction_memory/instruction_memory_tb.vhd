LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instruction_memory_tb IS
END instruction_memory_tb;

ARCHITECTURE behavior OF instruction_memory_tb IS
    -- Component declaration for the unit under test (UUT)
    COMPONENT instruction_memory
        PORT (
            pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            clk : IN STD_LOGIC; -- Clock input
            reset : IN STD_LOGIC; -- Reset input
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            IM_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL pc : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk : STD_LOGIC := '0'; -- Clock signal
    SIGNAL rst : STD_LOGIC := '0'; -- Reset signal
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IM_4 : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    -- Instantiate the unit under test (UUT)
    uut : instruction_memory
    PORT MAP(
        pc => pc,
        clk => clk,
        reset => rst,
        instruction => instruction,
        IM_0 => IM_0,
        IM_1 => IM_1,
        IM_2 => IM_2,
        IM_3 => IM_3,
        IM_4 => IM_4
    );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 100 ns;
        clk <= '1';
        WAIT FOR 100 ns;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Initial setup
        -- enable <= '0';
        rst <= '1'; -- Assert reset initially
        WAIT FOR 200 ns; -- Wait for 2 clock cycles

        rst <= '0'; -- Deassert reset

        -- Test case: Load instructions from the file
        -- enable <= '1'; -- Enable loading the instructions from file
        WAIT FOR 100 ns;

        -- Test: Read from instruction memory and check the first 5 locations (addresses 0 to 4)
        pc <= "0000000000000000"; -- Fetch instruction at address 0
        WAIT FOR 100 ns;

        pc <= "0000000000000001"; -- Fetch instruction at address 1
        WAIT FOR 100 ns;

        pc <= "0000000000000010"; -- Fetch instruction at address 2
        WAIT FOR 100 ns;

        pc <= "0000000000000011"; -- Fetch instruction at address 3
        WAIT FOR 100 ns;

        pc <= "0000000000000100"; -- Fetch instruction at address 4
        WAIT FOR 100 ns;

        -- Test: Fetch instructions for addresses >= 20
        pc <= "0000001000000000"; -- Fetch instruction at address 20
        WAIT FOR 100 ns;

        pc <= "0000000000010101"; -- Fetch instruction at address 21
        WAIT FOR 100 ns;

        pc <= "0000000000010110"; -- Fetch instruction at address 22
        WAIT FOR 100 ns;

        pc <= "0000000000010111"; -- Fetch instruction at address 23
        WAIT FOR 100 ns;

        pc <= "0000000000011000"; -- Fetch instruction at address 24
        WAIT FOR 100 ns;

        pc <= "0000000000011001"; -- Fetch instruction at address 25
        WAIT FOR 100 ns;

        pc <= "0000000000011010"; -- Fetch instruction at address 26
        WAIT FOR 100 ns;

        pc <= "0000000000011011"; -- Fetch instruction at address 27
        WAIT FOR 100 ns;

        pc <= "0000000000011100"; -- Fetch instruction at address 28
        WAIT FOR 100 ns;

        pc <= "0000000000011101"; -- Fetch instruction at address 29
        WAIT FOR 100 ns;

        -- Add more address checks as needed (addresses >= 30)

        WAIT; -- End simulation
    END PROCESS;

END behavior;