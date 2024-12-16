LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY demux_unit IS
    GENERIC (
        size : INTEGER := 16 -- Default size of the input/output signal
    );
    PORT (
        output_0 : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0); -- Output 0
        output_1 : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0); -- Output 1

        same_pc_write_disable : IN STD_LOGIC;
        freeze_signal : IN STD_LOGIC;

        freeze_instruction : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        instruction_memory_result_input : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);

        is_immediate : IN STD_LOGIC;
        reset : IN STD_LOGIC

    );
END demux_unit;

ARCHITECTURE Behavioral OF demux_unit IS

    SIGNAL input_demux_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL or_result_signal : STD_LOGIC;
BEGIN
    mux_inst_1 : ENTITY work.mux_2_input
        GENERIC MAP(
            size => 1
        )
        PORT MAP(
            input_0 => instruction_memory_result_input, -- incremented PC value as input_0
            input_1 => freeze_instruction, -- Alternative address as input_1
            sel => or_result_signal, -- Selection signal to choose between inputs
            result => input_demux_signal
        );

    -- Instantiate the OR module
    or_instance : ENTITY work.or_2_input
        GENERIC MAP(
            size => 1 -- 1-bit inputs
        )
        PORT MAP(
            input_0 => (same_pc_write_disable), -- Convert to a 1-bit vector
            input_1 => (freeze_signal), -- Convert to a 1-bit vector
            result => (or_result_signal) -- Convert back to a 1-bit vector
        );

    PROCESS (input_demux_signal, same_pc_write_disable, freeze_signal)
    BEGIN
        -- Default outputs to zero
        output_0 <= (OTHERS => '0');
        output_1 <= (OTHERS => '0');

        -- Route the input to the appropriate output based on the selection signal
        IF reset = '1' THEN
            output_0 <= (OTHERS => '0');
            output_1 <= (OTHERS => '0');
        ELSIF is_immediate = '1' THEN
            output_1 <= input_demux_signal;
        ELSE
            output_0 <= input_demux_signal;
        END IF;
    END PROCESS;
END Behavioral;