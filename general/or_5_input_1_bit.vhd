
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY or_5_input_1_bit IS
    PORT (
        input_0 : IN STD_LOGIC; -- First input
        input_1 : IN STD_LOGIC; -- Second input
        input_2 : IN STD_LOGIC; -- Third input
        input_3 : IN STD_LOGIC; -- Fourth input
        input_4 : IN STD_LOGIC; -- Fifth input
        result : OUT STD_LOGIC -- Output
    );
END or_5_input_1_bit;
ARCHITECTURE Behavioral OF or_5_input_1_bit IS

BEGIN
    PROCESS (input_0, input_1, input_2, input_3, input_4)
    BEGIN
        result <= input_0 OR input_1 OR input_2 OR input_3 OR input_4;
    END PROCESS;
END Behavioral;