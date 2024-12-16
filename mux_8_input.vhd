
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--input_(num not needed when call) => (others => '0'),  -- Tie to a constant value
ENTITY mux_8_input IS
    GENERIC (
        size : INTEGER := 8 -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- First input
        input_1 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Second input
        input_2 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Third input
        input_3 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Fourth input
        input_4 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Fifth input
        input_5 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Sixth input
        input_6 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Seventh input
        input_7 : IN STD_LOGIC_VECTOR (size - 1 DOWNTO 0); -- Eighth input
        sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- 3-bit selection signal (000 to 111)
        result : OUT STD_LOGIC_VECTOR (size - 1 DOWNTO 0) -- Output
    );
END mux_8_input;

ARCHITECTURE behavioral OF mux_8_input IS
BEGIN
    PROCESS (sel, input_0, input_1, input_2, input_3, input_4, input_5, input_6, input_7)
    BEGIN
        CASE sel IS
            WHEN "000" =>
                result <= input_0; -- Select first input
            WHEN "001" =>
                result <= input_1; -- Select second input
            WHEN "010" =>
                result <= input_2; -- Select third input
            WHEN "011" =>
                result <= input_3; -- Select fourth input
            WHEN "100" =>
                result <= input_4; -- Select fifth input
            WHEN "101" =>
                result <= input_5; -- Select sixth input
            WHEN "110" =>
                result <= input_6; -- Select seventh input
            WHEN "111" =>
                result <= input_7; -- Select eighth input
            WHEN OTHERS =>
                result <= (OTHERS => '0'); -- Default case (should never happen)
        END CASE;
    END PROCESS;
END behavioral;