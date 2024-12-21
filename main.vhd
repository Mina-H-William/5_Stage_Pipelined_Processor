LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        write_enable : IN STD_LOGIC;
        read_register_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_register_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_register : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ret_or_rti_signal : OUT STD_LOGIC;
        reg_write_signal : OUT STD_LOGIC;
        jmp_signal : OUT STD_LOGIC;
        mem_to_reg_signal : OUT STD_LOGIC;
        mem_read_signal : OUT STD_LOGIC;
        mem_write_signal : OUT STD_LOGIC;
        int_signal : OUT STD_LOGIC;
        set_carry_signal : OUT STD_LOGIC;
        rti_signal : OUT STD_LOGIC;
        sp_write_signal : OUT STD_LOGIC;
        add_or_subtract_signal : OUT STD_LOGIC;
        freeze_signal : OUT STD_LOGIC;
        call_signal : OUT STD_LOGIC;
        out_signal : OUT STD_LOGIC;
        in_signal : OUT STD_LOGIC;
        is_immediate_signal : OUT STD_LOGIC;
        jz_signal : OUT STD_LOGIC;
        jc_signal : OUT STD_LOGIC;
        jn_signal : OUT STD_LOGIC;
        pass_data_2_signal : OUT STD_LOGIC;
        pass_data_1_signal : OUT STD_LOGIC;
        not_signal : OUT STD_LOGIC;
        add_offset_signal : OUT STD_LOGIC;
        alu_func_signal : OUT STD_LOGIC;
        read_data_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END main;

ARCHITECTURE Behavioral OF main IS

    SIGNAL sig_sp_write : STD_LOGIC;
    SIGNAL sig_int : STD_LOGIC;
    SIGNAL sig_rti : STD_LOGIC;
    SIGNAL sig_int_or_rti : STD_LOGIC;
    SIGNAL sig_add_or_subtract : STD_LOGIC;

BEGIN

    -- Control Unit
    CONTROL_UNIT : ENTITY work.control_unit
        PORT MAP(
            opcode => opcode,
            ret_or_rti_signal => ret_or_rti_signal,
            reg_write_signal => reg_write_signal,
            jmp_signal => jmp_signal,
            mem_to_reg_signal => mem_to_reg_signal,
            mem_read_signal => mem_read_signal,
            mem_write_signal => mem_write_signal,
            int_signal => sig_int,
            set_carry_signal => set_carry_signal,
            rti_signal => sig_rti,
            sp_write_signal => sig_sp_write,
            add_or_subtract_signal => sig_add_or_subtract,
            freeze_signal => freeze_signal,
            call_signal => call_signal,
            out_signal => out_signal,
            in_signal => in_signal,
            is_immediate_signal => is_immediate_signal,
            jz_signal => jz_signal,
            jc_signal => jc_signal,
            jn_signal => jn_signal,
            pass_data_2_signal => pass_data_2_signal,
            pass_data_1_signal => pass_data_1_signal,
            not_signal => not_signal,
            add_offset_signal => add_offset_signal,
            alu_func_signal => alu_func_signal
        );

    -- Register File
    REGISTER_FILE : ENTITY work.register_file
        PORT MAP(
            clk => clk,
            reset => reset,
            write_enable => write_enable,
            read_register_1 => read_register_1,
            read_register_2 => read_register_2,
            write_register => write_register,
            write_data => write_data,
            read_data_1 => read_data_1,
            read_data_2 => read_data_2
        );

    OR_2_INPUT_1_BIT : ENTITY work.or_2_input_1_bit
        PORT MAP(
            input_0 => sig_int, -- First input
            input_1 => sig_rti, -- Second input
            result => sig_int_or_rti-- Output
        );

    -- Stack Wrapper
    STACK_WRAPPER : ENTITY work.stack_wrapper
        PORT MAP(
            clk => clk, -- Clock signal
            sp_write => sig_sp_write, --sp write
            reset => reset, -- reset signal (active high)
            add_or_subtract_signal => sig_add_or_subtract,
            int_or_rti => sig_int_or_rti,
            data_out => sp
        );

    sp_write_signal <= sig_sp_write;
    rti_signal <= sig_rti;
    int_signal <= sig_int;
    add_or_subtract_signal <= sig_add_or_subtract;

END Behavioral;