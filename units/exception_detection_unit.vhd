LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; -- Allows direct comparison with STD_LOGIC_VECTOR

ENTITY exception_detection_unit IS
    PORT (
        stack_pointer_address : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Stack pointer address (16-bit)
        memory_address : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Memory address to write (16-bit)
        empty_stack_exception : OUT STD_LOGIC; -- Output for Empty Stack Exception
        invalid_memory_exception : OUT STD_LOGIC -- Output for Invalid Memory Address Exception
    );
END exception_detection_unit;

ARCHITECTURE Behavioral OF exception_detection_unit IS
    -- Constant for the maximum valid address (2^12 - 1 = 4095 in binary)
    CONSTANT MAX_VALID_ADDRESS : STD_LOGIC_VECTOR (15 DOWNTO 0) := x"0FFF"; -- Binary for 4095
BEGIN
    PROCESS (stack_pointer_address, memory_address)
    BEGIN
        -- Check for Empty Stack Exception
        IF stack_pointer_address > MAX_VALID_ADDRESS THEN
            empty_stack_exception <= '1';
        ELSE
            empty_stack_exception <= '0';
        END IF;

        -- Check for Invalid Memory Address Exception
        IF memory_address > MAX_VALID_ADDRESS THEN
            invalid_memory_exception <= '1';
        ELSE
            invalid_memory_exception <= '0';
        END IF;
    END PROCESS;

END Behavioral;