
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--input_(num not needed when call) => (others => '0'),  -- Tie to a constant value
ENTITY mux_2_input IS
    GENERIC (
        size : INTEGER := 8 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Second input
        sel : IN STD_LOGIC; -- Selection signal (0 or 1)
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0) -- Output
    );
END mux_2_input;

ARCHITECTURE behavioral OF mux_2_input IS
BEGIN
    PROCESS (sel, input_0, input_1)
    BEGIN
        IF sel = '0' THEN
            result <= input_0; -- Select first input
        ELSE
            result <= input_1; -- Select second input
        END IF;
    END PROCESS;
END behavioral;