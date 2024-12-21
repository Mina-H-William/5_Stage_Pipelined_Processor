
-- flags [zero , negative , carry]

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ccr IS
    PORT (
        rst : IN STD_LOGIC; -- Reset signal
        clk : IN STD_LOGIC; -- Clock signal
        rti_signal : IN STD_LOGIC; -- RTI signal
        set_carry : IN STD_LOGIC; -- Set carry signal
        flags_enable_from_alu : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags enable
        flags_from_alu : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags
        flags_in_rti : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags
        flags_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0) -- Flags
    );
END ccr;

ARCHITECTURE ccr_arch OF ccr IS
    SIGNAL flags : STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            flags <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF (rti_signal = '1') THEN
                flags <= flags_in_rti;
            END IF;
            IF (flags_enable_from_alu(0) = '1') THEN
                flags(0) <= flags_from_alu(0);
            END IF;
            IF (flags_enable_from_alu(1) = '1') THEN
                flags(1) <= flags_from_alu(1);
            END IF;
            IF (flags_enable_from_alu(2) = '1') THEN
                flags(2) <= flags_from_alu(2);
            END IF;
            IF (set_carry = '1') THEN
                flags(2) <= '1';
            END IF;
        END IF;
    END PROCESS;
    flags_out <= flags;
END ccr_arch;