LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY epc IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- reset signal (active high)
        stack_exception : IN STD_LOGIC;
        mem_exception : IN STD_LOGIC;
        pc_from_decode : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Input data
        pc_from_mem : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Input data
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- Output data
    );
END epc;

ARCHITECTURE Behavioral OF epc IS
    SIGNAL register_value : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            register_value <= X"0FFF";
        ELSIF rising_edge(clk) THEN
            -- Update the register value on the clock edge if enabled
            IF stack_exception = '1' THEN
                register_value <= pc_from_decode;
            ELSIF mem_exception = '1' THEN
                register_value <= pc_from_mem;
            END IF;
        END IF;

    END PROCESS;

    data_out <= register_value;

END Behavioral;