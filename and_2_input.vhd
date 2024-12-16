LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY and_2_input IS
    GENERIC (
        size : INTEGER := 1 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- second input
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0)
    );
END and_2_input;

ARCHITECTURE Behavioral OF and_2_input IS
BEGIN
    PROCESS (input_0, input_1)
    BEGIN
        result <= input_0 AND input_1;
    END PROCESS;
END Behavioral;