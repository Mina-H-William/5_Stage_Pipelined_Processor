LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pc_unit IS
    PORT (
        same_pc_write_disable : IN STD_LOGIC;
        freeze_signal : IN STD_LOGIC;
        int_signal : IN STD_LOGIC;
        invalid_memory : IN STD_LOGIC;
        empty_stack : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        index_bit : IN STD_LOGIC;
        result_of_pc_unit : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
    );
END pc_unit;

ARCHITECTURE Behavioral OF pc_unit IS

    -- Signal to hold the result of OR operation
    SIGNAL or_result : STD_LOGIC_VECTOR (0 DOWNTO 0); -- 1-bit vector for OR output

    -- COMPONENT or_2_input
    --     GENERIC (
    --         size : INTEGER := 1 -- Size of each input (bit-width)
    --     );
    --     PORT (
    --         input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
    --         input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Second input
    --         result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0) -- Result should be a vector of the same size
    --     );
    -- END COMPONENT;

BEGIN

    -- Instantiate the OR module
    or_instance : ENTITY work.or_2_input
        GENERIC MAP(
            size => 1 -- 1-bit inputs
        )
        PORT MAP(
            input_0 => same_pc_write_disable, -- Connect the first input
            input_1 => freeze_signal, -- Connect the second input
            result => or_result -- OR operation result
        );

    PROCESS (or_result, int_signal, invalid_memory, empty_stack, reset, index_bit)
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
        ELSIF or_result(0) = '1' THEN
            result_of_pc_unit <= "001";
        ELSE
            result_of_pc_unit <= "000"; -- default is the next instruction 
        END IF;
    END PROCESS;
END Behavioral;