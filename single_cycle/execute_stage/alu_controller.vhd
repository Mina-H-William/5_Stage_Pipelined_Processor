LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY alu_controller IS
    PORT (
        alu_func_signal : IN STD_LOGIC; -- Enable the ALU
        not_signal : IN STD_LOGIC; -- Enable the NOT operation
        add_offset_signal : IN STD_LOGIC; -- Enable the store operation
        pass_data1_signal : IN STD_LOGIC; -- Pass data from first input
        pass_data2_signal : IN STD_LOGIC; -- Pass data from second input
        func : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- ALU operation
        alu_control : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) -- ALU control
    );
END alu_controller;

ARCHITECTURE Behavioral OF alu_controller IS
BEGIN
    PROCESS (alu_func_signal, not_signal, pass_data1_signal, pass_data2_signal, func)
    BEGIN
        -- Default: no ALU operation (000)
        alu_control <= "0000";

        -- Check if ALU operation is enabled
        IF alu_func_signal = '1' THEN
            CASE func IS
                WHEN "00" => -- Add operation
                    alu_control <= "0001"; -- Output: 001
                WHEN "01" => -- Subtract operation
                    alu_control <= "0010"; -- Output: 010
                WHEN "10" => -- AND operation
                    alu_control <= "0011"; -- Output: 011
                WHEN "11" => -- Increment operation
                    alu_control <= "0100"; -- Output: 100
                WHEN OTHERS =>
                    alu_control <= "0000"; -- Default to no ALU operation
            END CASE;
        ELSIF not_signal = '1' THEN
            -- Handle NOT operation (if enabled)
            alu_control <= "0101"; -- Output: 101 for NOT operation
        ELSIF pass_data1_signal = '1' THEN
            -- Pass data from the first input
            alu_control <= "0110"; -- Output: 110 for passing data_1
        ELSIF pass_data2_signal = '1' THEN
            -- Pass data from the second input
            alu_control <= "0111"; -- Output: 111 for passing data_2
        ELSIF add_offset_signal = '1' THEN
            -- Add offset operation
            alu_control <= "1000"; -- Output: 1000 for add offset
        ELSE
            -- Default: No ALU operation
            alu_control <= "0000"; -- No ALU operation
        END IF;
    END PROCESS;
END Behavioral;

-- 0000 -> np --  0001 -> add -- 0010 -> sub -- 0011 -> and -- 0100 -> inc 
-- 0101 -> not -- 0110 -> pass_data_1 -- 0111 -> pass_data_2  -- 1000 -> add_offset