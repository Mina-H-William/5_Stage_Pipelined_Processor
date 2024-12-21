
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; -- Use numeric_std for unsigned arithmetic

ENTITY add_one IS
    GENERIC (
        width : INTEGER := 8 -- Width of the input and output
    );
    PORT (
        input : IN STD_LOGIC_VECTOR (width - 1 DOWNTO 0); -- Input
        output : OUT STD_LOGIC_VECTOR (width - 1 DOWNTO 0) -- Output
    );
END add_one;

ARCHITECTURE Behavioral OF add_one IS
BEGIN
    PROCESS (input)
    BEGIN
        -- Convert input from STD_LOGIC_VECTOR to unsigned, add 1, and convert back to STD_LOGIC_VECTOR
        output <= STD_LOGIC_VECTOR(unsigned(input) + 1);
    END PROCESS;
END Behavioral;