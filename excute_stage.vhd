
--------------------- need to take a look at this file (immediate mux after forward mux)  ---------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY excute_stage IS
    PORT (
        rst : IN STD_LOGIC; -- Reset signal
        clk : IN STD_LOGIC; -- Clock signal
        is_immediate : IN STD_LOGIC; -- Immediate signal
        -- signals for forward unit 
        forward1_signal : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Forward 1 signal
        forward2_signal : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Forward 2 signal
        -- signals for jumping
        jz_signal : IN STD_LOGIC; -- Jump zero signal
        jn_signal : IN STD_LOGIC; -- Jump negative signal
        jc_signal : IN STD_LOGIC; -- Jump carry signal
        jump_signal : IN STD_LOGIC; -- Jump signal
        call_signal : IN STD_LOGIC; -- Call signal
        jumping_out_signal : OUT STD_LOGIC; -- Conditional jumping signal
        -- signals for alu cntrl
        pass_data1_signal : IN STD_LOGIC; -- Pass data 1 signal
        pass_data2_signal : IN STD_LOGIC; -- Pass data 2 signal
        not_signal : IN STD_LOGIC; -- Not signal
        add_offset_signal : IN STD_LOGIC; -- Add offset signal
        alu_func_signal : IN STD_LOGIC; -- Alu function signal
        alu_func : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Alu function
        -- input port
        in_signal : IN STD_LOGIC; -- In signal
        input_port : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Input port
        -- data
        data1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data 1
        data2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data 2
        data_forward_mem : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data forward memory
        data_forward_wb : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data forward execute
        immediate : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Immediate
        rsrc1_from_excute : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- Source 1 from execute
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- Alu out
        -- flags
        set_Carry : IN STD_LOGIC; -- Set carry signal
        rti_from_wb_signal : IN STD_LOGIC; -- Return from interrupt signal
        flags_from_mem : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags from memory
        flags_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0) -- Flags out
    );
END excute_stage;

ARCHITECTURE behavior OF excute_stage IS
    --signals for alu cntrl
    SIGNAL alu_control : STD_LOGIC_VECTOR (3 DOWNTO 0); -- Alu control signal

    --signals for forward unit
    SIGNAL data2_before_forward : STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data 2 before forward
    SIGNAL data1_after_forward : STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data 1 after forward
    SIGNAL data2_after_forward : STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data 2 after forward

    --signals for alu
    SIGNAL alu_out : STD_LOGIC_VECTOR (15 DOWNTO 0); -- Alu out
    SIGNAL flags_alu_out : STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags alu out
    SIGNAL flags_enable_alu_out : STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags

    --signals for ccr
    SIGNAL flags_ccr : STD_LOGIC_VECTOR (2 DOWNTO 0); -- Flags
    SIGNAL is_jz : STD_LOGIC; -- Jump zero signal
    SIGNAL is_jn : STD_LOGIC; -- Jump negative signal
    SIGNAL is_jc : STD_LOGIC; -- Jump carry signal

BEGIN

    -- alu controler

    alu_controller : ENTITY work.alu_controller
        PORT MAP(
            func => alu_func,
            pass_data1_signal => pass_data1_signal,
            pass_data2_signal => pass_data2_signal,
            not_signal => not_signal,
            add_offset_signal => add_offset_signal,
            alu_func_signal => alu_func_signal,
            alu_control => alu_control
        );

    --mux_2_input for data2 , immediate value with select is immediate and output is data2_before_forward

    mux_2_input_data2_before_forward : ENTITY work.mux_2_input
        GENERIC MAP(
            size => 16
        )
        PORT MAP(
            sel => is_immediate,
            input_0 => data2,
            input_1 => immediate,
            result => data2_before_forward
        );

    -- mux_4_input for data1 , data_forward_mem , data_forward_wb, zeros
    -- sel is forward1_signal and output data1_after_forward

    mux_4_input_data1_after_forward : ENTITY work.mux_4_input
        GENERIC MAP(
            size => 16
        )
        PORT MAP(
            input_0 => data1,
            input_1 => data_forward_mem,
            input_2 => data_forward_wb,
            input_3 => "0000000000000000",
            sel => forward1_signal,
            result => data1_after_forward
        );

    rsrc1_from_excute <= data1_after_forward;

    -- mux_4_input for data2_before_forward , data_forward_mem , data_forward_wb, zeros
    -- sel is forward2_signal
    -- output data2_after_forward

    mux_4_input_data2_after_forward : ENTITY work.mux_4_input
        GENERIC MAP(
            size => 16
        )
        PORT MAP(
            input_0 => data2_before_forward,
            input_1 => data_forward_mem,
            input_2 => data_forward_wb,
            input_3 => "0000000000000000",
            sel => forward2_signal,
            result => data2_after_forward
        );

    -- alu 
    -- inputs : data1_after_forward , data2_after_forward , alu_control
    -- outputs : alu_out , flags_alu_out , flags_enable_alu_out

    alu : ENTITY work.alu
        PORT MAP(
            input_1 => data1_after_forward,
            input_2 => data2_after_forward,
            alu_control => alu_control,
            flags_enable_out => flags_enable_alu_out,
            result => alu_out,
            flags => flags_alu_out
        );

    -- mux_2_input_for_alu_out 
    -- inputs : flags_alu_out , input_port
    -- sel : in_signal
    -- output : excute_data_out

    mux_2_input_for_alu_out : ENTITY work.mux_2_input
        GENERIC MAP(
            size => 16
        )
        PORT MAP(
            sel => in_signal,
            input_0 => alu_out,
            input_1 => input_port,
            result => data_out
        );

    -- ccr
    -- inputs : flags_from_mem , flags_alu_out, flags_enable_alu_out , set_Carry , rti_from_wb_signal, rst , clk
    -- outputs : flags_ccr

    ccr : ENTITY work.ccr
        PORT MAP(
            rst => rst,
            clk => clk,
            rti_signal => rti_from_wb_signal,
            set_carry => set_Carry,
            flags_enable_from_alu => flags_enable_alu_out,
            flags_from_alu => flags_alu_out,
            flags_in_rti => flags_from_mem,
            flags_out => flags_ccr
        );

    flags_out <= flags_ccr;

    -- conditional jumping
    --and_2_input_jz
    -- inputs : flags_ccr(2) , jz_signal
    -- output : is_jz

    and_2_input_jz : ENTITY work.and_2_input_1_bit
        PORT MAP(
            input_0 => flags_ccr(2),
            input_1 => jz_signal,
            result => is_jz
        );

    --and_2_input_jn
    -- inputs : flags_ccr(1) , jn_signal
    -- output : is_jn

    and_2_input_jn : ENTITY work.and_2_input_1_bit
        PORT MAP(
            input_0 => flags_ccr(1),
            input_1 => jn_signal,
            result => is_jn
        );

    --and_2_input_jc
    -- inputs : flags_ccr(0) , jc_signal
    -- output : is_jc

    and_2_input_jc : ENTITY work.and_2_input_1_bit
        PORT MAP(
            input_0 => flags_ccr(0),
            input_1 => jc_signal,
            result => is_jc
        );

    --or_5_input_jumping_out
    -- inputs : is_jz , is_jn , is_jc , jump_signal , call_signal
    -- output : jumping_out_signal

    or_5_input_jumping_out : ENTITY work.or_5_input_1_bit
        PORT MAP(
            input_0 => is_jz,
            input_1 => is_jn,
            input_2 => is_jc,
            input_3 => jump_signal,
            input_4 => call_signal,
            result => jumping_out_signal
        );

END behavior;