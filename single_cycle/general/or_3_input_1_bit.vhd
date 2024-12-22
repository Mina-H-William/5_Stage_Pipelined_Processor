LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY or_3_input_1_bit IS
    PORT (
        input_0 : IN STD_LOGIC; -- First input
        input_1 : IN STD_LOGIC; -- second input
        input_2 : IN STD_LOGIC; -- third input
        result : OUT STD_LOGIC
    );
END or_3_input_1_bit;

ARCHITECTURE Behavioral OF or_3_input_1_bit IS
BEGIN
    PROCESS (input_0, input_1, input_2)
    BEGIN
        result <= input_0 OR input_1 OR input_2;
    END PROCESS;
END Behavioral;