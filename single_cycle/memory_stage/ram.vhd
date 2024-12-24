LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        ADDRESS_WIDTH : INTEGER := 12 -- 4K memory requires 12 address bits (2^12 = 4096)
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC; -- Read enable
        address : IN STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY ram;

ARCHITECTURE ram_arch OF ram IS
    TYPE ram_type IS ARRAY(0 TO (2 ** ADDRESS_WIDTH) - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL ram : ram_type;
    SIGNAL data_out_reg : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            ram <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF we = '1' THEN
                ram(to_integer(unsigned(address))) <= data_in;
            END IF;
        END IF;

    END PROCESS;
    data_out <= ram(to_integer(unsigned(address))) WHEN re = '1';

END ARCHITECTURE ram_arch;