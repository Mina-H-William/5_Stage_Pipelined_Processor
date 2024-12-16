LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY or_3_input IS
    GENERIC (
        size : INTEGER := 1 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- second input
        input_2 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- third input
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0)
    );
END or_3_input;

ARCHITECTURE Behavioral OF or_3_input IS
BEGIN
    PROCESS (input_0, input_1, input_2)
    BEGIN
        result <= input_0 OR input_1 OR input_2;
    END PROCESS;
END Behavioral;