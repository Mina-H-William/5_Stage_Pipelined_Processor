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
            clk : IN std_logic;
            we : IN std_logic;
            re : IN std_logic;
            address : IN std_logic_vector(ADDRESS_WIDTH-1 DOWNTO 0);
            data_in : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
            data_out : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL clk : std_logic := '0';
    SIGNAL we : std_logic := '0';
    SIGNAL re : std_logic := '0';
    SIGNAL address : std_logic_vector(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : std_logic_vector(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: ram
        GENERIC MAP (
            DATA_WIDTH => 16,
            ADDRESS_WIDTH => 12
        )
        PORT MAP (
            clk => clk,
            we => we,
            re => re,
            address => address,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Case 1: Write to a valid address and read from it
        we <= '1';
        re <= '0';
        address <= std_logic_vector(to_unsigned(10, 12));
        data_in <= x"1234";
        wait for clk_period;

        we <= '0';
        re <= '1';
        wait for clk_period;
        assert data_out = x"1234" report "Test failed: Valid address read" severity error;

        -- Case 2: Write to another valid address and read from it
        we <= '1';
        re <= '0';
        address <= std_logic_vector(to_unsigned(20, 12));
        data_in <= x"5678";
        wait for clk_period;

        we <= '0';
        re <= '1';
        wait for clk_period;
        assert data_out = x"5678" report "Test failed: Valid address read" severity error;

        -- Case 3: Write to an invalid address and read from it
        we <= '1';
        re <= '0';
        address <= std_logic_vector(to_unsigned(20, 12));  -- Invalid address
        data_in <= x"9ABC";
        wait for clk_period;

        we <= '0';
        re <= '1';
        wait for clk_period;
        
        -- Case 4: Read from an address that was not written to
        re <= '1';
        address <= std_logic_vector(to_unsigned(30, 12));
        wait for clk_period;
        
        -- Case 3: Write to an invalid address and read from it
        we <= '1';
        re <= '1';
        address <= std_logic_vector(to_unsigned(11, 12));  -- Invalid address
        data_in <= x"1010";
        wait for clk_period;
        -- End simulation
        wait;
    end process;

END ARCHITECTURE behavior;
