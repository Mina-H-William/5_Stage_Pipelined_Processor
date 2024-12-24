LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY immediate_unit IS
    GENERIC (
        size : INTEGER := 16 -- Default size of the input/output signal
    );
    PORT (
        output_0 : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0); -- Output 0
        output_1 : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0); -- Output 1
        instruction_with_immediate_output : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0);

        instruction_memory_result_input : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        instruction_with_immediate_input : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);

        reset : IN STD_LOGIC

    );
END immediate_unit;

ARCHITECTURE Behavioral OF immediate_unit IS
BEGIN

    PROCESS (instruction_memory_result_input, reset)
    BEGIN
        IF reset = '1' THEN
            output_0 <= (OTHERS => '0');
            output_1 <= (OTHERS => '0');
            instruction_with_immediate_output <= (OTHERS => '0');
        ELSE
            IF instruction_with_immediate_input = (OTHERS => '0') THEN
                -- idd 00100, ldm 01011, ldd 01100, std 01101
                IF instruction_memory_result_input(15 DOWNTO 11) = "00100"
                    OR instruction_memory_result_input(15 DOWNTO 11) = "01011"
                    OR instruction_memory_result_input(15 DOWNTO 11) = "01100"
                    OR instruction_memory_result_input(15 DOWNTO 11) = "01101" THEN
                    instruction_with_immediate_output <= instruction_memory_result_input;
                    output_0 <= (OTHERS => '0');
                    output_1 <= (OTHERS => '0');
                ELSE
                    output_0 <= instruction_with_immediate_input;
                    output_1 <= (OTHERS => '0');
                    instruction_with_immediate_output <= (OTHERS => '0');
                END IF;
            ELSE
                output_0 <= instruction_with_immediate_input;
                output_1 <= instruction_memory_result_input;
                instruction_with_immediate_output <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;
END Behavioral;