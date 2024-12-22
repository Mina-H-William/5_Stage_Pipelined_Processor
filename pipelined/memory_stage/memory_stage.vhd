LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_stage IS
    PORT (
        clk                         : IN STD_LOGIC;
        sp_write_signal             : IN STD_LOGIC;
        int_signal_from_meomery     : IN STD_LOGIC;
        int_signal_from_write_back  : IN STD_LOGIC;
        rti_signal_from_write_back  : IN STD_LOGIC;
        call_signal                 : IN STD_LOGIC;
        mem_write_signal            : IN STD_LOGIC;
        mem_read_signal             : IN STD_LOGIC;
        pc                          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_output                  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_input_2                 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        flags                       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        sp                          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp_write_back               : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        data_out                    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        memory_address_out          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END ENTITY memory_stage;

ARCHITECTURE memory_arch OF memory_stage IS
    COMPONENT mux_4_input
        GENERIC (
            size : INTEGER
        );
        PORT (
            input_0 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            input_1 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            input_2 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            input_3 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            sel     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            result  : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_2_input
        GENERIC (
            size : INTEGER
        );
        PORT (
            input_0 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            input_1 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            sel     : IN STD_LOGIC;
            result  : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ram
        GENERIC (
            DATA_WIDTH : INTEGER;
            ADDRESS_WIDTH : INTEGER
        );
        PORT (
            clk     : IN STD_LOGIC;
            we      : IN STD_LOGIC;
            re      : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            data_out: OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Internal signals
    SIGNAL pc_incremented : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL sp_decremented : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL int_or_rti : STD_LOGIC;
    SIGNAL int_or_call : STD_LOGIC;
    SIGNAL mux01_input_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux10_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL expanded_flags : STD_LOGIC_VECTOR(15 DOWNTO 0); 

    SIGNAL memory_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_we : STD_LOGIC;
    SIGNAL memory_re : STD_LOGIC;
BEGIN

    
    memory_address_out <= memory_address;
    
    expanded_flags <= (15 DOWNTO 3 => '0') & flags;
    -- Increment and decrement the program counter
    pc_incremented <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
    sp_decremented <= STD_LOGIC_VECTOR(unsigned(sp_write_back) - 1);

    -- Combine interrupt and return from interrupt signals
    int_or_rti <= rti_signal_from_write_back OR int_signal_from_write_back;
    int_or_call <= call_signal OR int_signal_from_meomery;

    -- Memory write and read enable signals
    memory_we <= mem_write_signal OR int_signal_from_write_back;
    memory_re <= mem_read_signal OR rti_signal_from_write_back;

    -- Multiplexer for memory address selection 
    mux10_sel <= sp_write_signal & int_or_rti;

    memory_address_mux : mux_4_input
    GENERIC MAP(size => 16)
    PORT MAP(
        input_0 => alu_output,
        input_1 => alu_output,
        input_2 => sp,
        input_3 => sp_decremented,
        sel => mux10_sel,
        result => memory_address
    );

    -- Multiplexer for selecting input to the next stage
    mux00 : mux_2_input
    GENERIC MAP(size => 16)
    PORT MAP(
        input_0 => alu_input_2,
        input_1 => pc_incremented,
        sel => int_or_call,
        result => mux01_input_0
    );

    -- Multiplexer for selecting data to write to memory
    mux01 : mux_2_input
    GENERIC MAP(size => 16)
    PORT MAP(
        input_0 => mux01_input_0,
        input_1 => expanded_flags,
        sel => int_signal_from_write_back,
        result => memory_data_in
    );

    -- RAM instantiation
    ram_port_map : ram
    GENERIC MAP(
        DATA_WIDTH => 16,
        ADDRESS_WIDTH => 16
    )
    PORT MAP(
        clk => clk,
        we => memory_we,
        re => memory_re,
        address => memory_address,
        data_in => memory_data_in,
        data_out => data_out
    );

END ARCHITECTURE memory_arch;