

-- input rsrc1_execute, rsrc2_execute, rdest_mem, rdest_wb, reg_write_signal_mem, reg_write_signal_wb
-- output forward1_signal, forward2_signal

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY forward_unit IS
    PORT (
        rsrc1_execute : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Source 1 execute
        rsrc2_execute : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Source 2 execute
        rdest_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Destination memory
        rdest_wb : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Destination write back
        reg_write_signal_mem : IN STD_LOGIC; -- Register write signal memory
        reg_write_signal_wb : IN STD_LOGIC; -- Register write signal write back
        forward1_signal : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- Forward 1 signal
        forward2_signal : OUT STD_LOGIC_VECTOR (1 DOWNTO 0) -- Forward 2 signal
    );
END forward_unit;

ARCHITECTURE behavior OF forward_unit IS
BEGIN
    PROCESS (rsrc1_execute, rsrc2_execute, rdest_mem, rdest_wb, reg_write_signal_mem, reg_write_signal_wb)
    BEGIN

        forward1_signal <= "00";
        forward2_signal <= "00";

        IF (reg_write_signal_mem = '1') THEN
            IF (rdest_mem = rsrc1_execute) THEN
                forward1_signal <= "01";
            END IF;
            IF (rdest_mem = rsrc2_execute) THEN
                forward2_signal <= "01";
            END IF;
        ELSIF (reg_write_signal_wb = '1') THEN
            IF (rdest_wb = rsrc1_execute) THEN
                forward1_signal <= "10";
            END IF;
            IF (rdest_wb = rsrc2_execute) THEN
                forward2_signal <= "10";
            END IF;
        END IF;
    END PROCESS;

END behavior;