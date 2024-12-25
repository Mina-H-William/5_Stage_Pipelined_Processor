LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
    PORT (
        pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk : IN STD_LOGIC; -- Clock input
        reset : IN STD_LOGIC; -- Reset input
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        im_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END instruction_memory;

ARCHITECTURE behavior OF instruction_memory IS
    SIGNAL address : INTEGER RANGE 0 TO 65535;
    TYPE ram_type IS ARRAY (0 TO 65535) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL inst_memory : ram_type := (OTHERS => (OTHERS => '0'));
    SIGNAL seed_memory : STD_LOGIC := '1';
BEGIN

    im_0 <= inst_memory(0);
    im_1 <= inst_memory(1);
    im_2 <= inst_memory(2);
    im_3 <= inst_memory(3);
    im_4 <= inst_memory(4);

    -- Synchronous process for instruction fetch with clk and reset
    PROCESS (clk, reset)
        FILE instructions_file : text;
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        address <= to_integer(unsigned(pc));
        instruction <= inst_memory(to_integer(unsigned(pc)));
        -- Memory seeding logic
        IF seed_memory = '1' THEN
            file_open(instructions_file, "input.txt", read_mode);
            FOR i IN inst_memory'RANGE LOOP
                IF NOT endfile(instructions_file) THEN
                    readline(instructions_file, file_line);
                    read(file_line, temp_data);
                    inst_memory(i) <= temp_data;
                END IF;
            END LOOP;
            seed_memory <= '0'; -- Set flag to prevent re-seeding
            file_close(instructions_file); -- Close file after seeding
        ELSIF reset = '1' THEN
            -- Reset logic: Initialize memory to default state (optional)
            inst_memory <= (OTHERS => (OTHERS => '0'));
            instruction <= (OTHERS => '0');
            seed_memory <= '1'; -- Re-enable memory seeding after reset
            -- ELSIF rising_edge(clk) THEN
            -- Instruction fetch logic
            -- IF enable = '1' THEN
            -- END IF;
        END IF;

    END PROCESS;

END behavior;