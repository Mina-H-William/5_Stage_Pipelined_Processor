
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4_input IS
    GENERIC (
        size : INTEGER := 8  -- Size of each input (bit-width)
    );
    PORT (
        input_0 : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);  -- First input
        input_1 : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);  -- Second input
        input_2 : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);  -- Third input
        input_3 : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);  -- Fourth input
        sel     : IN STD_LOGIC_VECTOR (1 DOWNTO 0);        -- 2-bit selection signal (00 to 11)
        output  : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)   -- Output
    );
END mux_4_input;

ARCHITECTURE behavioral OF mux_4_input IS
BEGIN
    PROCESS (sel, input_0, input_1, input_2, input_3)
    BEGIN
        CASE sel IS
            WHEN "00" => 
                output <= input_0;  -- Select first input
            WHEN "01" => 
                output <= input_1;  -- Select second input
            WHEN "10" => 
                output <= input_2;  -- Select third input
            WHEN "11" => 
                output <= input_3;  -- Select fourth input
            WHEN OTHERS => 
                output <= (others => '0');  -- Default case (should never happen)
        END CASE;
    END PROCESS;
END behavioral;
