LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; -- Allows direct comparison with STD_LOGIC_VECTOR

ENTITY load_use_detection_unit IS
    PORT (
        rt_from_execute : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        r_src_1_from_decode : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        r_src_2_from_decode : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        mem_read_from_execute : IN STD_LOGIC;
        reg_write_from_execute : IN STD_LOGIC;
        load_use_out : OUT STD_LOGIC
    );
END load_use_detection_unit;

ARCHITECTURE Behavioral OF load_use_detection_unit IS
BEGIN
    PROCESS (rt_from_execute, r_src_1_from_decode, r_src_2_from_decode, mem_read_from_execute, reg_write_from_execute)
    BEGIN
        IF (mem_read_from_execute = '1' AND reg_write_from_execute = '1' AND
            (rt_from_execute = r_src_1_from_decode OR rt_from_execute = r_src_2_from_decode)) THEN
            load_use_out <= '1';
        ELSE
            load_use_out <= '0';
        END IF;
    END PROCESS;
END Behavioral;