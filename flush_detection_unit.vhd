LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; -- Allows direct comparison with STD_LOGIC_VECTOR

ENTITY flush_detection_unit IS
    PORT (
        conditional_jumps_from_EX : IN STD_LOGIC;
        ret_or_rti_from_MEM : IN STD_LOGIC;
        ret_or_rti_from_EX : IN STD_LOGIC;
        ret_or_rti_from_ID : IN STD_LOGIC;
        ret_or_rti_from_WB : IN STD_LOGIC;
        stack_exception : IN STD_LOGIC;
        memory_exception : IN STD_LOGIC;
        int_signal_from_ID : IN STD_LOGIC;
        flush_IF_ID : OUT STD_LOGIC;
        flush_ID_EX : OUT STD_LOGIC;
        flush_EX_MEM : OUT STD_LOGIC;
        flush_MEM_WB : OUT STD_LOGIC
    );
END flush_detection_unit;

ARCHITECTURE Behavioral OF flush_detection_unit IS

BEGIN
    flush_IF_ID <= conditional_jumps_from_EX OR ret_or_rti_from_MEM OR
        ret_or_rti_from_EX OR ret_or_rti_from_ID OR ret_or_rti_from_WB OR
        stack_exception OR memory_exception OR int_signal_from_ID;

    flush_ID_EX <= conditional_jumps_from_EX OR ret_or_rti_from_MEM OR
        ret_or_rti_from_EX OR ret_or_rti_from_WB OR stack_exception OR memory_exception;

    flush_EX_MEM <= ret_or_rti_from_MEM OR ret_or_rti_from_WB OR memory_exception;

    flush_MEM_WB <= ret_or_rti_from_WB OR memory_exception;
END Behavioral;