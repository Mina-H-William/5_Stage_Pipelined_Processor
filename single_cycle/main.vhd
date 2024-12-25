LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main IS
    PORT (
        reset : IN STD_LOGIC;
        memory_reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        memory_clk : IN STD_LOGIC;
        input_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        epc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ccr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        stack_pointer : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        pc : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END main;

ARCHITECTURE Behavioral OF main IS

    -- outputs of IF
    SIGNAL sig_instruction_from_IF : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_pc_from_IF : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_immediate_bits_from_IF : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_r_src_1_from_IF : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_r_src_2_from_IF : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_r_dest_from_IF : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_func_from_IF : STD_LOGIC_VECTOR (1 DOWNTO 0);

    -- outputs of ID
    SIGNAL sig_ret_from_ID : STD_LOGIC;
    SIGNAL sig_freeze_from_ID : STD_LOGIC;
    SIGNAL sig_int_from_ID : STD_LOGIC;
    SIGNAL sig_rti_from_ID : STD_LOGIC;
    SIGNAL sig_pc_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_sp_write_from_ID : STD_LOGIC;
    SIGNAL sig_add_or_subtract_from_ID : STD_LOGIC;
    SIGNAL sig_reg_write_from_ID : STD_LOGIC;
    SIGNAL sig_jmp_from_ID : STD_LOGIC;
    SIGNAL sig_mem_to_reg_from_ID : STD_LOGIC;
    SIGNAL sig_mem_read_from_ID : STD_LOGIC;
    SIGNAL sig_mem_write_from_ID : STD_LOGIC;
    SIGNAL sig_set_carry_from_ID : STD_LOGIC;
    SIGNAL sig_call_from_ID : STD_LOGIC;
    SIGNAL sig_out_from_ID : STD_LOGIC;
    SIGNAL sig_in_from_ID : STD_LOGIC;
    SIGNAL sig_is_immediate_from_ID : STD_LOGIC;
    SIGNAL sig_jz_from_ID : STD_LOGIC;
    SIGNAL sig_jn_from_ID : STD_LOGIC;
    SIGNAL sig_jc_from_ID : STD_LOGIC;
    SIGNAL sig_pass_data_1_from_ID : STD_LOGIC;
    SIGNAL sig_pass_data_2_from_ID : STD_LOGIC;
    SIGNAL sig_not_from_ID : STD_LOGIC;
    SIGNAL sig_add_offset_from_ID : STD_LOGIC;
    SIGNAL sig_alu_func_from_ID : STD_LOGIC;
    SIGNAL sig_read_data_1_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_read_data_2_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- outputs of EX
    SIGNAL sig_conditional_jumps_from_EX : STD_LOGIC;
    SIGNAL sig_write_flags_done_from_EX : STD_LOGIC;
    SIGNAL sig_reg_write_from_EX : STD_LOGIC;
    SIGNAL sig_alu_out_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_flags_from_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    -- outputs of MEM

    SIGNAL sig_mem_out_from_MEM : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_first_write_mem_done_from_MEM : STD_LOGIC;
    SIGNAL sig_memory_address_from_MEM : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_pc_from_MEM : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_write_data_from_MEM : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- outputs of exception detection unit 
    SIGNAL sig_invalid_memory_exception : STD_LOGIC;
    SIGNAL sig_empty_stack_exception : STD_LOGIC;

    -- outputs of stack wrapper 
    SIGNAL sig_sp_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- temporary signals
    SIGNAL sig_index_bit : STD_LOGIC;

BEGIN
    sig_index_bit <= sig_instruction_from_IF (1);

    FETCH_STAGE : ENTITY work.fetch_stage
        PORT MAP(
            conditional_jumps => sig_conditional_jumps_from_EX,
            ret_signal => sig_ret_from_ID,
            r_src1_from_excute => sig_read_data_1_from_ID,
            mem_out => sig_mem_out_from_MEM,
            freeze_signal => sig_freeze_from_ID,
            int_signal => sig_int_from_ID,
            rti_signal => sig_rti_from_ID,
            first_write_mem_done => sig_first_write_mem_done_from_MEM,
            write_flags_done => sig_write_flags_done_from_EX,
            invalid_memory => sig_invalid_memory_exception,
            empty_stack => sig_empty_stack_exception,
            reset => reset,
            index_bit => sig_index_bit,
            memory_clk => memory_clk,
            clk => clk,
            memory_reset => memory_reset,

            pc_from_fetch => sig_pc_from_IF,
            instruction_bits_output => sig_instruction_from_IF,
            immediate_bits_output => sig_immediate_bits_from_IF
        );

    EXCEPTION_WRAPPER : ENTITY work.exception_wrapper
        PORT MAP(
            clk => clk, -- Clock signal
            reset => reset, -- Reset signal (active high)
            stack_pointer_address => sig_sp_from_ID, -- Stack pointer address
            memory_address => sig_memory_address_from_MEM, -- Memory address to write
            pc_from_decode => sig_pc_from_ID, -- Program counter from decode stage
            pc_from_mem => sig_pc_from_MEM, -- Program counter from memory stage
            data_out => epc, -- EPC output
            empty_stack_exception => sig_empty_stack_exception, -- Empty Stack Exception
            invalid_memory_exception => sig_invalid_memory_exception-- Invalid Memory Address Exception
        );

    STACK_WRAPPER : ENTITY work.stack_wrapper
        PORT MAP(
            clk => clk, -- Clock signal
            sp_write => sig_sp_write_from_ID, --sp write
            reset => reset, -- reset signal (active high)
            add_or_subtract_signal => sig_add_or_subtract_from_ID,
            data_out => sig_sp_from_ID
        );

    sig_r_src_1_from_IF <= sig_instruction_from_IF (10 DOWNTO 8);
    sig_r_src_2_from_IF <= sig_instruction_from_IF (4 DOWNTO 2);
    sig_r_dest_from_IF <= sig_instruction_from_IF (7 DOWNTO 5);
    sig_func_from_IF <= sig_instruction_from_IF (1 DOWNTO 0);

    DECODE_STAGE : ENTITY work.decode_stage
        PORT MAP(
            opcode => sig_instruction_from_IF (15 DOWNTO 11),
            clk => clk,
            reset => reset,
            write_enable => sig_reg_write_from_EX,
            read_register_1 => sig_r_src_1_from_IF,
            read_register_2 => sig_r_src_2_from_IF,
            write_register => sig_r_dest_from_IF,
            write_data => sig_write_data_from_MEM,
            ret_signal => sig_ret_from_ID,
            reg_write_signal => sig_reg_write_from_ID,
            jmp_signal => sig_jmp_from_ID,
            mem_to_reg_signal => sig_mem_to_reg_from_ID,
            mem_read_signal => sig_mem_read_from_ID,
            mem_write_signal => sig_mem_write_from_ID,
            int_signal => sig_int_from_ID,
            set_carry_signal => sig_set_carry_from_ID,
            rti_signal => sig_rti_from_ID,
            sp_write_signal => sig_sp_write_from_ID,
            add_or_subtract_signal => sig_add_or_subtract_from_ID,
            freeze_signal => sig_freeze_from_ID,
            call_signal => sig_call_from_ID,
            out_signal => sig_out_from_ID,
            in_signal => sig_in_from_ID,
            is_immediate_signal => sig_is_immediate_from_ID,
            jz_signal => sig_jz_from_ID,
            jc_signal => sig_jc_from_ID,
            jn_signal => sig_jn_from_ID,
            pass_data_2_signal => sig_pass_data_2_from_ID,
            pass_data_1_signal => sig_pass_data_1_from_ID,
            not_signal => sig_not_from_ID,
            add_offset_signal => sig_add_offset_from_ID,
            alu_func_signal => sig_alu_func_from_ID,
            read_data_1 => sig_read_data_1_from_ID,
            read_data_2 => sig_read_data_2_from_ID
        );

    INT_UNIT : ENTITY work.int_unit
        PORT MAP(
            clk => clk,
            rst => reset,
            int_signal => sig_int_from_ID,
            first_WRITE_MEM_DONE_input => sig_first_write_mem_done_from_MEM,
            first_WRITE_MEM_DONE_output => sig_first_write_mem_done_from_MEM
        );

    RTI_UNIT : ENTITY work.rti_unit
        PORT MAP(
            clk => clk,
            rst => reset,
            rti_signal => sig_rti_from_ID,
            WRITE_FLAGS_DONE_input => sig_write_flags_done_from_EX,
            WRITE_FLAGS_DONE_output => sig_write_flags_done_from_EX
        );

    EXECUTE_STAGE : ENTITY work.execute_stage
        PORT MAP(
            rst => reset, -- Reset signal
            clk => clk, -- Clock signal
            is_immediate => sig_is_immediate_from_ID, -- Immediate signal
            -- signals for jumping
            jz_signal => sig_jz_from_ID, -- Jump zero signal
            jn_signal => sig_jn_from_ID, -- Jump negative signal
            jc_signal => sig_jc_from_ID, -- Jump carry signal
            jump_signal => sig_jmp_from_ID, -- Jump signal
            call_signal => sig_call_from_ID, -- Call signal
            jumping_out_signal => sig_conditional_jumps_from_EX, -- Conditional jumping signal
            -- signals for alu cntrl
            pass_data1_signal => sig_pass_data_1_from_ID, -- Pass data 1 signal
            pass_data2_signal => sig_pass_data_2_from_ID, -- Pass data 2 signal
            not_signal => sig_not_from_ID, -- Not signal
            add_offset_signal => sig_add_offset_from_ID, -- Add offset signal
            alu_func_signal => sig_alu_func_from_ID, -- Alu function signal
            alu_func => sig_func_from_IF, -- Alu function
            -- input port
            in_signal => sig_in_from_ID, -- In signal
            input_port => input_port, -- Input port
            -- data
            data1 => sig_read_data_1_from_ID, -- Data 1
            data2 => sig_read_data_2_from_ID, -- Data 2
            immediate => sig_immediate_bits_from_IF, -- Immediate
            rsrc1_from_excute => sig_read_data_1_from_ID, -- Source 1 from IDecute
            data_out => sig_alu_out_from_EX, -- Alu out
            -- flags
            set_Carry => sig_set_carry_from_ID, -- Set carry signal
            rti_signal => sig_rti_from_ID,
            write_flags_done => sig_write_flags_done_from_EX,
            flags_from_mem => sig_mem_out_from_MEM(2 DOWNTO 0), -- Flags from memory
            flags_out => sig_flags_from_EX-- Flags out
        );

    MEMORY_STAGE : ENTITY work.memory_stage
        PORT MAP(
            clk => clk,
            reset => reset,
            sp_write_signal => sig_sp_write_from_ID,
            int_signal_from_meomery => sig_int_from_ID,
            call_signal => sig_call_from_ID,
            mem_write_signal => sig_mem_write_from_ID,
            mem_read_signal => sig_mem_read_from_ID,
            pc => sig_pc_from_IF,
            alu_output => sig_alu_out_from_EX,
            alu_input_2 => sig_read_data_2_from_ID,
            flags => sig_flags_from_EX,
            sp => sig_sp_from_ID,
            first_write_mem_done => sig_first_write_mem_done_from_MEM,

            data_out => sig_mem_out_from_MEM

        );

    WRITE_BACK_STAGE : ENTITY work.mux_2_input
        GENERIC MAP(
            size => 16 -- Size of each input (bit-width)
        )
        PORT MAP(
            input_0 => sig_alu_out_from_EX, -- First input
            input_1 => sig_mem_out_from_MEM, -- Second input
            sel => sig_mem_to_reg_from_ID, -- Selection signal (0 or 1)
            result => sig_write_data_from_MEM-- Output
        );

    PROCESS (sig_out_from_ID, sig_alu_out_from_EX)
    BEGIN
        IF (sig_out_from_ID = '1') THEN
            output_port <= sig_alu_out_from_EX;
        ELSE
            output_port <= (OTHERS => 'Z');
        END IF;
    END PROCESS;
END Behavioral;