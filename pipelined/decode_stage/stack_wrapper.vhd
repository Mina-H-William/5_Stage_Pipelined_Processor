LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY stack_wrapper IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        sp_write : IN STD_LOGIC; --sp write
        conditional_jumps : IN STD_LOGIC;
        ret_or_rti_from_EX : IN STD_LOGIC;
        ret_or_rti_from_MEM : IN STD_LOGIC;
        ret_or_rti_from_WB : IN STD_LOGIC;
        reset : IN STD_LOGIC; -- reset signal (active high)
        add_or_subtract_signal : IN STD_LOGIC;
        int_or_rti : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- Output data
    );
END stack_wrapper;

ARCHITECTURE Behavioral OF stack_wrapper IS
    -- Internal signals for exceptions
    SIGNAL sig_write_enable : STD_LOGIC;
    SIGNAL sp_out : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- Signal for EPC output
    SIGNAL one_or_two : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL new_or_old : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL mini_alu_out : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

    sig_write_enable <= sp_write AND NOT(conditional_jumps OR ret_or_rti_from_EX OR ret_or_rti_from_MEM OR ret_or_rti_from_WB)
        -- Instantiate the exception_detection_unit
        STACK_POINTER : ENTITY work.stack_pointer
            PORT MAP(
                clk => clk, -- Clock signal
                write_enable => sig_write_enable, --sp write
                reset => reset, -- reset signal (active high)
                data_in => mini_alu_out, -- Input data
                data_out => sp_out -- Output data
            );

    -- Instantiate the EPC
    FIRST_MUX_2_INPUT : ENTITY work.mux_2_input
        PORT MAP(
            input_0 => X"0001", -- First input
            input_1 => X"0002", -- Second input
            sel => int_or_rti, -- Selection signal (0 or 1)
            result => one_or_two
        );

    STACK_MINI_ALU : ENTITY work.stack_mini_alu
        PORT MAP(
            input_1 => sp_out, -- First input
            input_2 => one_or_two, -- Second input
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