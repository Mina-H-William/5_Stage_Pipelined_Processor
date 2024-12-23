LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
    PORT (
        pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        enable : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_5 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_6 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IM_7 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END instruction_memory;

ARCHITECTURE behavior OF instruction_memory IS
    SIGNAL address : INTEGER RANGE 0 TO 65535;
    TYPE ram_type IS ARRAY (0 TO 65535) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL inst_memory : ram_type := (OTHERS => (OTHERS => '0'));
    SIGNAL seed_memory : STD_LOGIC := '1';
BEGIN

    IM_0 <= inst_memory(0);
    IM_1 <= inst_memory(1);
    IM_2 <= inst_memory(2);
    IM_3 <= inst_memory(3);
    IM_4 <= inst_memory(4);
    IM_5 <= inst_memory(5);
    IM_6 <= inst_memory(6);
    IM_7 <= inst_memory(7);

    -- Combinatorial process for instruction fetch
    PROCESS (pc, enable,address, inst_memory, seed_memory)
        FILE insturcions_file : text;
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF enable = '1' THEN
            address <= to_integer(unsigned(pc));
            instruction <= inst_memory(to_integer(unsigned(pc)));
        end if;
        if seed_memory = '1' then
            file_open(insturcions_file, "input.txt",  read_mode);
            FOR i IN inst_memory'RANGE LOOP
                IF NOT endfile(insturcions_file) THEN
                    readline(insturcions_file, file_line);
                    read(file_line, temp_data);
                    inst_memory(i) <= temp_data;
                END IF;
            END LOOP;
            seed_memory <= '0';
        END IF;
    END PROCESS;

END behavior;