LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_stage IS
    GENERIC (
        reg_size : INTEGER := 16;
        memory_address_size : INTEGER := 12);
    PORT (
        clk : IN STD_LOGIC;
        sp_write_signal : IN STD_LOGIC;
        int_signal : IN STD_LOGIC;
        rti_signal : IN STD_LOGIC;
        call_signal : IN STD_LOGIC;
        mem_write_signal : IN STD_LOGIC;
        mem_read_signal : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        alu_output : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        alu_input_2 : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        flags : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        sp : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);

        sp_out : OUT STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        alu_output_out : OUT STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        memory_address_out : OUT STD_LOGIC_VECTOR(memory_address_size - 1 DOWNTO 0);

        r_dest_in : IN STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
        r_dest_out : OUT STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);

        int_signal_out : OUT STD_LOGIC;
        rti_signal_out : OUT STD_LOGIC;
        ret_or_rti_signal_in : IN STD_LOGIC; -- Added as input
        ret_or_rti_signal_out : OUT STD_LOGIC; -- Added as output
        req_write_signal_in : IN STD_LOGIC; -- Added as input
        req_write_signal_out : OUT STD_LOGIC; -- Added as output
        mem_to_reg_signal_in : IN STD_LOGIC; -- Added as input
        mem_to_reg_signal_out : OUT STD_LOGIC -- Added as output

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
            sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_2_input
        GENERIC (
            size : INTEGER
        );
        PORT (
            input_0 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            input_1 : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ram
        GENERIC (
            DATA_WIDTH : INTEGER;
            ADDRESS_WIDTH : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            re : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Internal signals
    SIGNAL pc_incremented : STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
    SIGNAL pc_decremented : STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
    SIGNAL int_or_rti : STD_LOGIC;
    SIGNAL int_or_call : STD_LOGIC;
    SIGNAL mux01_input_0 : STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
    SIGNAL mux10_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL memory_address : STD_LOGIC_VECTOR(memory_address_size - 1 DOWNTO 0);
    SIGNAL memory_data_in : STD_LOGIC_VECTOR(reg_size - 1 DOWNTO 0);
    SIGNAL memory_we : STD_LOGIC;
    SIGNAL memory_re : STD_LOGIC;
BEGIN

    -- signals to bypass 
    ret_or_rti_signal_out <= ret_or_rti_signal_in;
    req_write_signal_out <= req_write_signal_in; -- Added to bypass section
    mem_to_reg_signal_out <= mem_to_reg_signal_in; -- Added to bypass section
    rti_signal_out <= rti_signal;
    int_signal_out <= int_signal;
    sp_out <= sp;
    alu_output_out <= alu_output;
    r_dest_out <= r_dest_in;
    memory_address_out <= memory_address;

    -- Increment and decrement the program counter
    pc_incremented <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
    pc_decremented <= STD_LOGIC_VECTOR(unsigned(pc) - 1);

    -- Combine interrupt and return from interrupt signals
    int_or_rti <= rti_signal OR int_signal;
    int_or_call <= call_signal OR int_signal;

    -- Memory write and read enable signals
    memory_we <= mem_write_signal OR int_signal;
    memory_re <= mem_read_signal OR rti_signal;

    -- Multiplexer for memory address selection 
    mux10_sel <= sp_write_signal & int_or_rti;

    memory_address_mux : mux_4_input
    GENERIC MAP(size => 16)
    PORT MAP(
        input_0 => alu_output(memory_address_size - 1 DOWNTO 0),
        input_1 => alu_output(memory_address_size - 1 DOWNTO 0),
        input_2 => sp(memory_address_size - 1 DOWNTO 0),
        input_3 => pc_decremented(memory_address_size - 1 DOWNTO 0),
        sel => mux10_sel,
        result => memory_address
    );

    -- Multiplexer for selecting input to the next stage
    mux00 : mux_2_input
    GENERIC MAP(size => reg_size)
    PORT MAP(
        input_0 => alu_input_2,
        input_1 => pc_incremented,
        sel => int_or_call,
        result => mux01_input_0
    );

    -- Multiplexer for selecting data to write to memory
    mux01 : mux_2_input
    GENERIC MAP(size => reg_size)
    PORT MAP(
        input_0 => mux01_input_0,
        input_1 => flags,
        sel => int_signal,
        result => memory_data_in
    );

    -- RAM instantiation
    ram_port_map : ram
    GENERIC MAP(
        DATA_WIDTH => reg_size,
        ADDRESS_WIDTH => memory_address_size
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