LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_entity IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal for write operations
        reset : IN STD_LOGIC; -- Reset signal
        address : IN STD_LOGIC_VECTOR (11 DOWNTO 0); -- 12-bit address for 4K memory
        write_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- 16-bit data to write
        read_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- 16-bit data output
        write_en : IN STD_LOGIC; -- Write enable signal

        -- Separate outputs for each memory element IM[0] to IM[4]
        im_0 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- IM[0] output
        im_1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- IM[1] output
        im_2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- IM[2] output
        im_3 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- IM[3] output
        im_4 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- IM[4] output
    );
END memory_entity;

ARCHITECTURE Behavioral OF memory_entity IS

    -- Memory array: 4K x 16
    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0')); -- Initialize memory to zero

BEGIN

    -- Synchronous Write
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF write_en = '1' THEN
                memory(to_integer(unsigned(address))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

    -- Reset Logic
    PROCESS (reset)
    BEGIN
        IF reset = '1' THEN
            memory <= (OTHERS => (OTHERS => '0')); -- Clear memory on reset
        END IF;
    END PROCESS;

    -- Asynchronous Read
    read_data <= memory(to_integer(unsigned(address)));

    -- Output the individual memory elements (IM[0] to IM[4])
    im_0 <= memory(0); -- Output IM[0]
    im_1 <= memory(1); -- Output IM[1]
    im_2 <= memory(2); -- Output IM[2]
    im_3 <= memory(3); -- Output IM[3]
    im_4 <= memory(4); -- Output IM[4]

END Behavioral;