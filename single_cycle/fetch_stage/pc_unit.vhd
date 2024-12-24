LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pc_unit IS
    PORT (
        freeze_signal : IN STD_LOGIC;
        int_signal : IN STD_LOGIC;
        invalid_memory : IN STD_LOGIC;
        empty_stack : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        index_bit : IN STD_LOGIC;
        result_of_pc_unit : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END pc_unit;

ARCHITECTURE Behavioral OF pc_unit IS

    -- Signal to hold the result of OR operation

BEGIN
    PROCESS (freeze_signal, int_signal, invalid_memory, empty_stack, reset, index_bit)
    BEGIN
        IF reset = '1' THEN
            result_of_pc_unit <= "010"; -- 2
            -- Handle empty stack scenario
        ELSIF empty_stack = '1' THEN
            result_of_pc_unit <= "011";
            -- Handle the invalid memory scenario
        ELSIF invalid_memory = '1' THEN
            result_of_pc_unit <= "100";
            -- Handle interrupt signal for index 0
        ELSIF int_signal = '1' AND index_bit = '0' THEN
            result_of_pc_unit <= "101";
            -- Handle interrupt signal for index 1
        ELSIF int_signal = '1' AND index_bit = '1' THEN
            result_of_pc_unit <= "110";
            -- handle freeze is the last priority 
        ELSIF freeze_signal = '1' THEN
            result_of_pc_unit <= "001";
        ELSE
            result_of_pc_unit <= "000"; -- default is the next instruction 
        END IF;
    END PROCESS;
END Behavioral;