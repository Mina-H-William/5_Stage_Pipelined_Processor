
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY int_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        int_signal : IN STD_LOGIC;
        first_WRITE_MEM_DONE_input : IN STD_LOGIC;
        first_WRITE_MEM_DONE_output : OUT STD_LOGIC
    );
END int_unit;

ARCHITECTURE Behavioral OF int_unit IS
    SIGNAL sig_total_input : STD_LOGIC;
    SIGNAL not_first_WRITE_MEM_DONE_input : STD_LOGIC;

BEGIN
    not_first_WRITE_MEM_DONE_input <= NOT(first_WRITE_MEM_DONE_input);
    instance_and_2_input_1_bit : ENTITY work.and_2_input_1_bit
        PORT MAP(
            input_0 => int_signal,
            input_1 => not_first_WRITE_MEM_DONE_input,
            result => sig_total_input
        );

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            first_WRITE_MEM_DONE_output <= '0';
        ELSIF rising_edge(clk) THEN
            IF sig_total_input = '1' THEN
                first_WRITE_MEM_DONE_output <= '1';
            ELSE
                first_WRITE_MEM_DONE_output <= '0';
            END IF;
        END IF;
    END PROCESS;
END Behavioral;