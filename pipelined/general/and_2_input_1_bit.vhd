

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY and_2_input_1_bit IS
    PORT (
        input_0 : IN STD_LOGIC; -- First input
        input_1 : IN STD_LOGIC; -- second input
        result : OUT STD_LOGIC
    );
END and_2_input_1_bit;

ARCHITECTURE Behavioral OF and_2_input_1_bit IS

BEGIN
    PROCESS (input_0, input_1)
    BEGIN
        result <= input_0 AND input_1;
    END PROCESS;
END Behavioral;