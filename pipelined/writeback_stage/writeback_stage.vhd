
-- input mem_to_reg_signal , mem_out, data2

-- output writeback_stage_out
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY writeback_stage IS
    PORT (
        mem_to_reg_signal : IN STD_LOGIC;
        mem_out : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        data2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        writeback_stage_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END writeback_stage;

ARCHITECTURE writeback_stage_arch OF writeback_stage IS

BEGIN
    mux_2_inst : ENTITY work.mux_2_input
        GENERIC MAP(
            size => 16
        )
        PORT MAP(
            sel => mem_to_reg_signal,
            input_0 => data2,
            input_1 => mem_out,
            result => writeback_stage_out
        );
END writeback_stage_arch;