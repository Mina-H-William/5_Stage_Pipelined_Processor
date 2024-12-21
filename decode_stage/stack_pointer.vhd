LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY stack_pointer IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        write_enable : IN STD_LOGIC; --sp write
        reset : IN STD_LOGIC; -- reset signal (active high)
        data_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Input data
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- Output data
    );
END stack_pointer;

ARCHITECTURE Behavioral OF stack_pointer IS
    SIGNAL register_value : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            register_value <= X"0FFF";
        ELSIF rising_edge(clk) THEN
            -- Update the register value on the clock edge if enabled
            IF write_enable = '1' THEN
                register_value <= data_in;
            END IF;
        END IF;
    END PROCESS;

    data_out <= register_value;

END Behavioral;