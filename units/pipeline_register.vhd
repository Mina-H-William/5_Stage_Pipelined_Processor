LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pipeline_register IS
    GENERIC (
        WIDTH : INTEGER := 32 -- Generic parameter for data width
    );
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- reset signal (active high)
        flush : IN STD_LOGIC; -- flush signal (active high)
        data_in : IN STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0); -- Input data
        data_out : OUT STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0) -- Output data
    );
END pipeline_register;

-- from up to down (up max value [width - 1])

ARCHITECTURE Behavioral OF pipeline_register IS
    SIGNAL register_value : STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN

        IF reset = '1' THEN
            -- Reset the register value
            register_value <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF flush = '1' THEN
                register_value <= (OTHERS => '0');
            ELSE
                -- Update the register value on the clock edge if enabled
                register_value <= data_in;
            END IF;
        END IF;
    END PROCESS;

    -- Output the register value
    data_out <= register_value;

END Behavioral;