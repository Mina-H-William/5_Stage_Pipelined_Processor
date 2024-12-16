LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL
USE ieee.std_logic_unsigned.ALL;
--input_(num not needed when call) => (others => '0'),  -- Tie to a constant value
ENTITY stack_mini_alu IS
    PORT (
        input_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- First input
        input_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Second input
        add_or_subtract_signal : IN STD_LOGIC; -- Selection signal (0 or 1)
        result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- Output
    );
END stack_mini_alu;

ARCHITECTURE Behavioral OF stack_mini_alu IS
BEGIN
    PROCESS (add_or_subtract_signal, input_1, input_2)
    BEGIN
        IF add_or_subtract_signal = '0' THEN
            result <= input_1 - input_2;
        ELSE
            result <= input_1 + input_2;
        END IF;
    END PROCESS;
END Behavioral;