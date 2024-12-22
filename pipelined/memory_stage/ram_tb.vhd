LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram_tb IS
END ENTITY ram_tb;

ARCHITECTURE behavior OF ram_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ram
        GENERIC (
            DATA_WIDTH : INTEGER := 16;
            ADDRESS_WIDTH : INTEGER := 12
        );
        PORT (
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            re : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL re : STD_LOGIC := '0';
    SIGNAL address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ram
    GENERIC MAP(
        DATA_WIDTH => 16,
        ADDRESS_WIDTH => 12
    )
    PORT MAP(
        clk => clk,
        we => we,
        re => re,
        address => address,
        data_in => data_in,
        data_out => data_out
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Case 1: Write to a valid address and read from it
        we <= '1';
        re <= '0';
        address <= STD_LOGIC_VECTOR(to_unsigned(10, 12));
        data_in <= x"1234";
        WAIT FOR clk_period;

        we <= '0';
        re <= '1';
        WAIT FOR clk_period;
        ASSERT data_out = x"1234" REPORT "Test failed: Valid address read" SEVERITY error;

        -- Case 2: Write to another valid address and read from it
        we <= '1';
        re <= '0';
        address <= STD_LOGIC_VECTOR(to_unsigned(20, 12));
        data_in <= x"5678";
        WAIT FOR clk_period;

        we <= '0';
        re <= '1';
        WAIT FOR clk_period;
        ASSERT data_out = x"5678" REPORT "Test failed: Valid address read" SEVERITY error;

        -- Case 3: Write to an invalid address and read from it
        we <= '1';
        re <= '0';
        address <= STD_LOGIC_VECTOR(to_unsigned(20, 12)); -- Invalid address
        data_in <= x"9ABC";
        WAIT FOR clk_period;

        we <= '0';
        re <= '1';
        WAIT FOR clk_period;

        -- Case 4: Read from an address that was not written to
        re <= '1';
        address <= STD_LOGIC_VECTOR(to_unsigned(30, 12));
        WAIT FOR clk_period;

        -- Case 3: Write to an invalid address and read from it
        we <= '1';
        re <= '1';
        address <= STD_LOGIC_VECTOR(to_unsigned(11, 12)); -- Invalid address
        data_in <= x"1010";
        WAIT FOR clk_period;
        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;