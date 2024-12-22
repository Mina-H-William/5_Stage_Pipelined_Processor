LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY register_file IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        write_enable : IN STD_LOGIC;
        read_register_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_register_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_register : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END register_file;

ARCHITECTURE Behavioral OF register_file IS
    TYPE reg_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL reg_file : reg_array := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            reg_file <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF write_enable = '1' THEN
                reg_file(to_integer(unsigned(write_register))) <= write_data;
            END IF;
        END IF;
    END PROCESS;

    read_data_1 <= reg_file(to_integer(unsigned(read_register_1)));
    read_data_2 <= reg_file(to_integer(unsigned(read_register_2)));

END ARCHITECTURE Behavioral;