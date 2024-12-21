LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main IS
    PORT (
        reset : IN STD_LOGIC;
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

    -- outputs of fetch
    SIGNAL sig_pc_from_fetch : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_instruction_from_IF : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_immediate_bits_from_IF : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- outputs of decode
    SIGNAL sig_ret_or_rti_from_ID : STD_LOGIC;
    SIGNAL sig_reg_write_from_ID : STD_LOGIC;
    SIGNAL sig_jmp_from_ID : STD_LOGIC;
    SIGNAL sig_mem_to_reg_from_ID : STD_LOGIC;
    SIGNAL sig_mem_read_from_ID : STD_LOGIC;
    SIGNAL sig_mem_write_from_ID : STD_LOGIC;
    SIGNAL sig_int_from_ID : STD_LOGIC;
    SIGNAL sig_set_carry_from_ID : STD_LOGIC;
    SIGNAL sig_rti_from_ID : STD_LOGIC;
    SIGNAL sig_sp_write_from_ID : STD_LOGIC;
    SIGNAL sig_add_or_subtract_from_ID : STD_LOGIC;
    SIGNAL sig_freeze_from_ID : STD_LOGIC;
    SIGNAL sig_call_from_ID : STD_LOGIC;
    SIGNAL sig_out_from_ID : STD_LOGIC;
    SIGNAL sig_in_from_ID : STD_LOGIC;
    SIGNAL sig_is_immediate_from_ID : STD_LOGIC;
    SIGNAL sig_jz_from_ID : STD_LOGIC;
    SIGNAL sig_jc_from_ID : STD_LOGIC;
    SIGNAL sig_jn_from_ID : STD_LOGIC;
    SIGNAL sig_pass_data_2_from_ID : STD_LOGIC;
    SIGNAL sig_pass_data_1_from_ID : STD_LOGIC;
    SIGNAL sig_not_from_ID : STD_LOGIC;
    SIGNAL sig_add_offset_from_ID : STD_LOGIC;
    SIGNAL sig_alu_func_from_ID : STD_LOGIC;
    SIGNAL sig_read_data_1_from_ID : STD_LOGIC;
    SIGNAL sig_read_data_2_from_ID : STD_LOGIC;

    -- outputs of execute
    SIGNAL sig_conditional_jumps_from_EX : STD_LOGIC;
    SIGNAL ret_or_rti_from_EX : STD_LOGIC;
    SIGNAL sig_flags_from_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL sig_alu_out_from_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL sig_r_src_1_data_from_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- outputs of memory
    SIGNAL ret_or_rti_from_MEM : STD_LOGIC;
    SIGNAL sig_data_forward_from_MEM : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL sig_flags_from_MEM : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- outputs of write back
    SIGNAL sig_ret_or_rti_from_WB : STD_LOGIC;
    SIGNAL sig_write_enable_from_WB : STD_LOGIC;
    SIGNAL sig_rti_from_WB : STD_LOGIC;
    SIGNAL sig_r_dest_from_WB : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_write_data_from_WB : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_mem_out_from_WB : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- ouputs of stack wrapper
    SIGNAL sp_from_ID : STD_LOGIC;

    -- outputs of exception
    SIGNAL sig_invalid_memory_exception : STD_LOGIC;
    SIGNAL sig_empty_stack_exception : STD_LOGIC;

    -- outputs of load use
    SIGNAL sig_same_pc_write_disable : STD_LOGIC;

    -- outputs of forward units
    SIGNAL sig_forward1 : STD_LOGIC;
    SIGNAL sig_forward2 : STD_LOGIC;

    --flushes
    SIGNAL sig_flush_IF_ID : STD_LOGIC;
    SIGNAL sig_flush_ID_EX : STD_LOGIC;
    SIGNAL sig_flush_EX_MEM : STD_LOGIC;
    SIGNAL sig_flush_MEM_WB : STD_LOGIC;

    --IF_ID register inputs
    SIGNAL sig_IF_ID_inputs : STD_LOGIC_VECTOR (47 DOWNTO 0);

    --ID_EX
    SIGNAL sig_ID_EX_inputs : STD_LOGIC_VECTOR (112 DOWNTO 0);

    -- IF_ID register outputs
    SIGNAL sig_IF_ID_outputs : STD_LOGIC_VECTOR (47 DOWNTO 0);
    SIGNAL sig_pc_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_instruction_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_immediate_bits_from_ID : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_r_src_1_from_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_r_src_2_from_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_r_dest_from_ID : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_func_from_ID : STD_LOGIC_VECTOR (1 DOWNTO 0);

    -- ID_EX register outputs
    SIGNAL sig_ID_EX_outputs : STD_LOGIC_VECTOR (112 DOWNTO 0);
    SIGNAL sig_ret_or_rti_from_EX : STD_LOGIC;
    SIGNAL sig_reg_write_from_EX : STD_LOGIC;
    SIGNAL sig_jmp_from_EX : STD_LOGIC;
    SIGNAL sig_mem_to_reg_from_EX : STD_LOGIC;
    SIGNAL sig_mem_read_from_EX : STD_LOGIC;
    SIGNAL sig_mem_write_from_EX : STD_LOGIC;
    SIGNAL sig_int_from_EX : STD_LOGIC;
    SIGNAL sig_set_carry_from_EX : STD_LOGIC;
    SIGNAL sig_rti_from_EX : STD_LOGIC;
    SIGNAL sig_sp_write_from_EX : STD_LOGIC;
    SIGNAL sig_call_from_EX : STD_LOGIC;
    SIGNAL sig_out_from_EX : STD_LOGIC;
    SIGNAL sig_in_from_EX : STD_LOGIC;
    SIGNAL sig_is_immediate_from_EX : STD_LOGIC;
    SIGNAL sig_pc_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_jz_from_EX : STD_LOGIC_VECTOR (82);
    SIGNAL sig_jc_from_EX : STD_LOGIC_VECTOR (81);
    SIGNAL sig_jn_from_EX : STD_LOGIC_VECTOR (80);
    SIGNAL sig_read_data_1_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_read_data_2_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_input_port_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_r_src_1_address_from_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_r_src_2_address_from_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_pass_data_2_from_EX : STD_LOGIC;
    SIGNAL sig_pass_data_1_from_EX : STD_LOGIC;
    SIGNAL sig_not_from_EX : STD_LOGIC;
    SIGNAL sig_add_offset_from_EX : STD_LOGIC;
    SIGNAL sig_r_dest_from_EX : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sig_alu_func_from_EX : STD_LOGIC;
    SIGNAL sig_func_from_EX : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL sig_sp_from_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- intermediate
    SIGNAL sig_int_or_rti_from_ID : STD_LOGIC;

BEGIN
    FETCH_STAGE : ENTITY work.fetch_stage
        PORT MAP(
            conditional_jumps => sig_conditional_jumps_from_EX,
            ret_or_rti_signal => sig_ret_or_rti_from_WB,
            r_src1_from_EX => sig_r_src_1_data_from_EX,
            mem_out => sig_mem_out_from_WB,
            same_pc_write_disable => sig_same_pc_write_disable,
            freeze_signal => sig_freeze_from_ID,
            int_signal => sig_int_from_ID,
            invalid_memory => sig_invalid_memory_exception,
            empty_stack => sig_empty_stack_exception,
            reset => reset,
            index_bit => sig_instruction(1),
            memory_clk => memory_clk,
            clk => clk,
            memory_reset => reset,
            freeze_instruction => sig_instruction,
            is_immediate => sig_is_immediate_from_ID,

            pc_from_fetch => sig_pc_from_fetch,
            instruction_bits_output => sig_instruction_from_IF,
            immediate_bits_output => sig_immediate_bits_from_IF
        );

    sig_IF_ID_inputs <= sig_pc_from_fetch & sig_instruction_from_IF & sig_immediate_bits_from_IF;

    PIPELINE_REGISTER_IF_ID : ENTITY work.pipeline_register
        GENERIC (
            WIDTH => 48 -- Generic parameter for data width
        )
        PORT (
            clk => clk,
            flush => sig_flush_IF_ID,
            data_in => sig_IF_ID_inputs,
            data_out => sig_IF_ID_outputs
        );

    sig_pc_from_ID <= sig_IF_ID_outputs(47 DOWNTO 32);
    sig_instruction_from_ID <= sig_IF_ID_outputs(31 DOWNTO 16);
    sig_immediate_bits_from_ID <= sig_IF_ID_outputs(15 DOWNTO 0);

    sig_r_src_1_from_ID <= sig_instruction_from_ID(10 DOWNTO 8);
    sig_r_src_2_from_ID <= sig_instruction_from_ID(4 DOWNTO 2);
    sig_r_dest_from_ID <= sig_instruction_from_ID(7 DOWNTO 5);
    sig_func_from_ID <= sig_instruction_from_ID(1 DOWNTO 0);

    sig_int_or_rti_from_ID <= sig_int_from_ID OR sig_rti_from_ID;

    STACK_WRAPPER : ENTITY work.stack_wrapper
        PORT (
            clk => clk, -- Clock signal
            sp_write => sig_sp_write_from_ID, --sp write
            conditional_jumps => sig_conditional_jumps_from_EX,
            ret_or_rti_from_EX => sig_ret_or_rti_from_EX,
            ret_or_rti_from_MEM => sig_ret_or_rti_from_MEM,
            ret_or_rti_from_WB => sig_ret_or_rti_from_WB,
            reset => reset,
            add_or_subtract_signal => sig_add_or_subtract_from_ID,
            int_or_rti => sig_int_or_rti_from_ID,
            data_out => sp_from_ID
        );

    DECODE_STAGE : ENTITY work.decode_stage
        PORT MAP(
            opcode => sig_instruction_from_ID,
            clk => clk,
            reset => reset,
            write_enable => sig_write_enable_from_WB,
            read_register_1 => sig_r_src_1_from_ID,
            read_register_2 => sig_r_src_2_from_ID,
            write_register => sig_r_dest_from_WB,
            write_data => sig_write_data_from_WB,
            ret_or_rti_signal => sig_ret_or_rti_from_ID,
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
            read_data_2 => sig_read_data_2_from_ID,
        );

    sig_ID_EX_inputs <=
        sig_ret_or_rti_from_ID & sig_reg_write_from_ID & sig_jmp_from_ID & sig_mem_to_reg_from_ID -- 1 bits
        & sig_mem_read_from_ID & sig_mem_write_from_ID & sig_int_from_ID & sig_set_carry_from_ID
        & sig_rti_from_ID & sig_sp_write_from_ID & sig_call_from_ID
        & sig_out_from_ID & sig_in_from_ID & sig_is_immediate_from_ID

        & sig_pc_from_ID -- 16 bits

        & sig_jz_from_ID & sig_jc_from_ID & sig_jn_from_ID -- 1 bits

        & sig_read_data_1_from_ID & sig_read_data_2_from_ID & input_port -- 16 bits

        & sig_r_src_1_from_ID & sig_r_src_2_from_ID -- 3 bits

        & sig_pass_data_2_from_ID & sig_pass_data_1_from_ID & sig_not_from_ID & sig_add_offset_from_ID -- 1 bits

        & sig_r_dest_from_ID -- 3 bits

        & sig_alu_func_from_ID -- 1 bits

        & sig_func_from_ID -- 2 bits

        & sp_from_ID;-- 16 bits

    PIPELINE_REGISTER_ID_EX : ENTITY work.pipeline_register
        GENERIC (
            WIDTH => 113 -- Generic parameter for data width
        )
        PORT (
            clk => clk,
            flush => sig_flush_ID_EX,
            data_in => sig_ID_EX_inputs,
            data_out => sig_ID_EX_outputs
        );

    sig_ret_or_rti_from_EX <= sig_ID_EX_outputs(112);
    sig_reg_write_from_EX <= sig_ID_EX_outputs(111);
    sig_jmp_from_EX <= sig_ID_EX_outputs(110);
    sig_mem_to_reg_from_EX <= sig_ID_EX_outputs(109);
    sig_mem_read_from_EX <= sig_ID_EX_outputs(108);
    sig_mem_write_from_EX <= sig_ID_EX_outputs(107);
    sig_int_from_EX <= sig_ID_EX_outputs(106);
    sig_set_carry_from_EX <= sig_ID_EX_outputs(105);
    sig_rti_from_EX <= sig_ID_EX_outputs(104);
    sig_sp_write_from_EX <= sig_ID_EX_outputs(103);
    sig_call_from_EX <= sig_ID_EX_outputs(102);
    sig_out_from_EX <= sig_ID_EX_outputs(101);
    sig_in_from_EX <= sig_ID_EX_outputs(100);
    sig_is_immediate_from_EX <= sig_ID_EX_outputs(99);
    sig_pc_from_EX <= sig_ID_EX_outputs(98 DOWNTO 83);
    sig_jz_from_EX <= sig_ID_EX_outputs(82);
    sig_jc_from_EX <= sig_ID_EX_outputs(81);
    sig_jn_from_EX <= sig_ID_EX_outputs(80);
    sig_read_data_1_from_EX <= sig_ID_EX_outputs(79 DOWNTO 64);
    sig_read_data_2_from_EX <= sig_ID_EX_outputs(63 DOWNTO 48);
    sig_input_port_from_EX <= sig_ID_EX_outputs(47 DOWNTO 32);
    sig_r_src_1_address_from_EX <= sig_ID_EX_outputs(31 DOWNTO 29);
    sig_r_src_2_address_from_EX <= sig_ID_EX_outputs(28 DOWNTO 26);
    sig_pass_data_2_from_EX <= sig_ID_EX_outputs(25);
    sig_pass_data_1_from_EX <= sig_ID_EX_outputs(24);
    sig_not_from_EX <= sig_ID_EX_outputs(23);
    sig_add_offset_from_EX <= sig_ID_EX_outputs(22);
    sig_r_dest_from_EX <= sig_ID_EX_outputs(21 DOWNTO 19);
    sig_alu_func_from_EX <= sig_ID_EX_outputs(18);
    sig_func_from_EX <= sig_ID_EX_outputs(17 DOWNTO 16);
    sig_sp_from_EX <= sig_ID_EX_outputs(15 DOWNTO 0);

    EXECUTE_STAGE : ENTITY work.execute_stage
        PORT (
            rst => reset, -- Reset signal
            clk => clk, -- Clock signal
            is_immediate => sig_is_immediate_from_EX, -- Immediate signal
            -- signals for forward unit 
            forward1_signal => sig_forward1, -- Forward 1 signal
            forward2_signal => sig_forward2, -- Forward 2 signal
            -- signals for jumping
            jz_signal => sig_jz_from_EX, -- Jump zero signal
            jn_signal => sig_jn_from_EX, -- Jump negative signal
            jc_signal => sig_jc_from_EX, -- Jump carry signal
            jump_signal => sig_jmp_from_EX, -- Jump signal
            call_signal => sig_call_from_EX, -- Call signal
            jumping_out_signal => sig_conditional_jumps_from_EX, -- Conditional jumping signal
            -- signals for alu cntrl
            pass_data1_signal => sig_pass_data_1_from_EX, -- Pass data 1 signal
            pass_data2_signal => sig_pass_data_2_from_EX, -- Pass data 2 signal
            not_signal => sig_not_from_EX, -- Not signal
            add_offset_signal => sig_add_offset_from_EX, -- Add offset signal
            alu_func_signal => sig_alu_func_from_EX, -- Alu function signal
            alu_func => sig_func_from_EX, -- Alu function
            -- input port
            in_signal => sig_in_from_EX, -- In signal
            input_port => sig_input_port_from_EX, -- Input port
            -- data
            data1 => sig_read_data_1_from_EX, -- Data 1
            data2 => sig_read_data_2_from_EX, -- Data 2
            data_forward_mem => sig_data_forward_from_MEM, ------------------------------------------ Data forward memory
            data_forward_wb => sig_write_data_from_WB, ------------------------------------------- Data forward execute
            immediate => sig_immediate_bits_from_ID, -- Immediate
            rsrc1_from_excute => sig_r_src_1_data_from_EX, -- Source 1 from execute
            data_out => sig_alu_out_from_EX, -- Alu out
            -- flags
            set_Carry => sig_set_carry_from_EX, -- Set carry signal
            rti_from_wb_signal => sig_rti_from_WB, -- Return from interrupt signal
            flags_from_mem => sig_flags_from_MEM(2 DOWNTO 0), -- Flags from memory
            flags_out => sig_flags_from_EX-- Flags out
        );
END Behavioral;