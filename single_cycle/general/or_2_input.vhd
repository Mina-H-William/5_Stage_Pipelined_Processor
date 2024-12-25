LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY or_2_input IS
    GENERIC (
        size : INTEGER := 16 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Second input
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0) -- Result should be a vector of the same size
    );
END or_2_input;

ARCHITECTURE Behavioral OF or_2_input IS
BEGIN
    PROCESS (input_0, input_1)
    BEGIN
        result <= input_0 OR input_1; -- Perform the OR operation between the two vectors
    END PROCESS;
END Behavioral;