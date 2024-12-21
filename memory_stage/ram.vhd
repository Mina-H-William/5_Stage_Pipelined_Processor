LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        ADDRESS_WIDTH : INTEGER := 12  -- 4K memory requires 12 address bits (2^12 = 4096)
    );
    PORT (
        clk : IN std_logic;
        we : IN std_logic;
        re : IN std_logic;  -- Read enable
        address : IN std_logic_vector(ADDRESS_WIDTH-1 DOWNTO 0);
        data_in : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
        data_out : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
    );
END ENTITY ram;

ARCHITECTURE ram_arch OF ram IS
    TYPE ram_type IS ARRAY(0 TO (2**ADDRESS_WIDTH)-1) OF std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    SIGNAL ram : ram_type;
    SIGNAL data_out_reg : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
BEGIN
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF we = '1' THEN
                ram(to_integer(unsigned(address))) <= data_in;
            END IF;
        END IF;
        
    END PROCESS;

    
    data_out <= ram(to_integer(unsigned(address))) WHEN re ='1';
    
END ARCHITECTURE ram_arch;

