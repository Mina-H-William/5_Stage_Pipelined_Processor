LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY stack_wrapper IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        sp_write : IN STD_LOGIC; --sp write
        reset : IN STD_LOGIC; -- reset signal (active high)
        add_or_subtract_signal : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- Output data
    );
END stack_wrapper;

ARCHITECTURE Behavioral OF stack_wrapper IS
    -- Internal signals for exceptions
    SIGNAL sp_out : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- Signal for EPC output
    SIGNAL new_or_old : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL mini_alu_out : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

    -- Instantiate the exception_detection_unit
    STACK_POINTER : ENTITY work.stack_pointer
        PORT MAP(
            clk => clk, -- Clock signal
            write_enable => sp_write, --sp write
            reset => reset, -- reset signal (active high)
            data_in => mini_alu_out, -- Input data
            data_out => sp_out -- Output data
        );

    STACK_MINI_ALU : ENTITY work.stack_mini_alu
        PORT MAP(
            input_1 => sp_out, -- First input
            input_2 => X"0001", -- Second input
            add_or_subtract_signal => add_or_subtract_signal, -- Selection signal (0 or 1)
            result => mini_alu_out
        );

    SECOND_MUX_2_INPUT : ENTITY work.mux_2_input
        PORT MAP(
            input_0 => sp_out, -- First input
            input_1 => mini_alu_out, -- Second input
            sel => add_or_subtract_signal, -- Selection signal (0 or 1)
            result => new_or_old
        );

    -- Connect EPC output to wrapper output
    data_out <= new_or_old;

END Behavioral;