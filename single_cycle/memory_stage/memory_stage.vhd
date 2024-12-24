LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_stage IS
    PORT (
        clk : IN STD_LOGIC;
        sp_write_signal : IN STD_LOGIC;
        int_signal_from_meomery : IN STD_LOGIC;
        call_signal : IN STD_LOGIC;
        mem_write_signal : IN STD_LOGIC;
        mem_read_signal : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_output : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_input_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        sp : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp_write_back : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        first_write_mem_done : IN STD_LOGIC;

        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END ENTITY memory_stage;

ARCHITECTURE memory_arch OF memory_stage IS

    -- Internal signals
    SIGNAL pc_incremented : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL int_or_call : STD_LOGIC;
    SIGNAL mux01_input_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL expanded_flags : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL memory_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    expanded_flags <= (15 DOWNTO 3 => '0') & flags;
    -- Increment and decrement the program counter
    pc_incremented <= STD_LOGIC_VECTOR(unsigned(pc) + 1);

    -- Combine interrupt and return from interrupt signals
    int_or_call <= call_signal OR int_signal_from_meomery;

    memory_address_mux : ENTITY work.mux_2_input
        GENERIC MAP(size => 16)
        PORT MAP(
            input_0 => alu_output,
            input_1 => sp,
            sel => sp_write_signal,
            result => memory_address
        );

    -- Multiplexer for selecting input to the next stage
    mux00 : ENTITY work.mux_2_input
        GENERIC MAP(size => 16)
        PORT MAP(
            input_0 => alu_input_2,
            input_1 => pc_incremented,
            sel => int_or_call,
            result => mux01_input_0
        );

    -- Multiplexer for selecting data to write to memory
    mux01 : ENTITY work.mux_2_input
        GENERIC MAP(size => 16)
        PORT MAP(
            input_0 => mux01_input_0,
            input_1 => expanded_flags,
            sel => first_write_mem_done AND int_signal_from_meomery,
            result => memory_data_in
        );

    -- RAM instantiation
    ram_port_map : ENTITY work.ram
        GENERIC MAP(
            DATA_WIDTH => 16,
            ADDRESS_WIDTH => 16
        )
        PORT MAP(
            clk => clk,
            we => mem_write_signal,
            re => mem_read_signal,
            address => memory_address,
            data_in => memory_data_in,
            data_out => data_out
        );

END ARCHITECTURE memory_arch;