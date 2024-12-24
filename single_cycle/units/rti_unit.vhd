
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY rti_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        rti_signal : IN STD_LOGIC;
        WRITE_FLAGS_DONE_input : IN STD_LOGIC;
        WRITE_FLAGS_DONE_output : OUT STD_LOGIC
    );
END rti_unit;

ARCHITECTURE Behavioral OF rti_unit IS
    SIGNAL sig_total_input : STD_LOGIC;

BEGIN

    instance_and_2_input_1_bit : ENTITY work.and_2_input_1_bit
        PORT MAP(
            input_0 => rti_signal,
            input_1 => NOT(WRITE_FLAGS_DONE_input),
            result => sig_total_input
        );

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            WRITE_FLAGS_DONE_output <= '0';
        ELSIF rising_edge(clk) THEN
            IF sig_total_input = '1' THEN
                WRITE_FLAGS_DONE_output <= '1';
            ELSE
                WRITE_FLAGS_DONE_output <= '0';
            END IF;
        END IF;
    END PROCESS;
END Behavioral;