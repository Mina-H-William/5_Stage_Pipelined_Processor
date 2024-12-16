
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY or_5_input IS
    GENERIC (
        size : INTEGER := 1 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- second input
        input_2 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- third input
        input_3 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- fourth input
        input_4 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- fifth input
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0)
    );
END or_5_input;

ARCHITECTURE Behavioral OF or_5_input IS

BEGIN
    PROCESS (input_0, input_1, input_2, input_3, input_4)
    BEGIN
        result <= input_0 OR input_1 OR input_2 OR input_3 OR input_4;
    END PROCESS;
END Behavioral;