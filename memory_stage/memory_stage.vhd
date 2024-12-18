LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_stage IS
    GENERIC (
        reg_size : integer := 16; memory_address_size : integer := 12);
    PORT (
        clk : IN std_logic;
        sp_write_signal : IN std_logic;  
        int_signal : IN std_logic;  
        rti_signal : IN std_logic;
        call_signal : IN std_logic;
        mem_write_signal : IN std_logic;
        mem_read_signal : IN std_logic;
        pc : IN std_logic_vector(reg_size-1 DOWNTO 0);
        alu_output : IN std_logic_vector(reg_size-1 DOWNTO 0);
        alu_input_2 : IN std_logic_vector(reg_size-1 DOWNTO 0);
        flags : IN std_logic_vector(reg_size-1 DOWNTO 0);
        sp : IN std_logic_vector(reg_size-1 DOWNTO 0);
        data_out : OUT std_logic_vector(reg_size-1 DOWNTO 0);

        sp_out : OUT std_logic_vector(reg_size-1 DOWNTO 0);
        alu_output_out : OUT std_logic_vector(reg_size-1 DOWNTO 0);
        
        r_dest_in : IN std_logic_vector(reg_size-1 DOWNTO 0);
        r_dest_out : OUT std_logic_vector(reg_size-1 DOWNTO 0);

        int_signal_out : OUT std_logic;
        rti_signal_out : OUT std_logic;
        ret_or_rti_signal_in : IN std_logic;  -- Added as input
        ret_or_rti_signal_out : OUT std_logic;  -- Added as output
        req_write_signal_in : IN std_logic;  -- Added as input
        req_write_signal_out : OUT std_logic;  -- Added as output
        mem_to_reg_signal_in : IN std_logic;  -- Added as input
        mem_to_reg_signal_out : OUT std_logic  -- Added as output
        
    );
END ENTITY memory_stage;

ARCHITECTURE memory_arch OF memory_stage IS
    COMPONENT mux_4_input
        GENERIC (
            size : integer
        );
        PORT (
            input_0 : IN std_logic_vector(size-1 DOWNTO 0);
            input_1 : IN std_logic_vector(size-1 DOWNTO 0);
            input_2 : IN std_logic_vector(size-1 DOWNTO 0);
            input_3 : IN std_logic_vector(size-1 DOWNTO 0);
            sel : IN std_logic_vector(1 DOWNTO 0);
            result : OUT std_logic_vector(size-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_2_input
        GENERIC (
            size : integer
        );
        PORT (
            input_0 : IN std_logic_vector(size-1 DOWNTO 0);
            input_1 : IN std_logic_vector(size-1 DOWNTO 0);
            sel : IN std_logic;
            result : OUT std_logic_vector(size-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ram
        GENERIC (
            DATA_WIDTH : integer;
            ADDRESS_WIDTH : integer
        );
        PORT (
            clk : IN std_logic;
            we : IN std_logic;
            re : IN std_logic;
            address : IN std_logic_vector(ADDRESS_WIDTH-1 DOWNTO 0);
            data_in : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
            data_out : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
        );
    END COMPONENT;

    -- Internal signals
    SIGNAL pc_incremented : std_logic_vector(reg_size-1 DOWNTO 0);
    SIGNAL pc_decremented : std_logic_vector(reg_size-1 DOWNTO 0);
    SIGNAL int_or_rti : std_logic;
    SIGNAL int_or_call : std_logic;
    SIGNAL mux01_input_0 : std_logic_vector(reg_size-1 DOWNTO 0);
    SIGNAL mux10_sel : std_logic_vector(1 DOWNTO 0);

    SIGNAL memory_address : std_logic_vector(memory_address_size-1 DOWNTO 0);
    SIGNAL memory_data_in : std_logic_vector(reg_size-1 DOWNTO 0);
    SIGNAL memory_we : std_logic;
    SIGNAL memory_re : std_logic;
BEGIN

    -- signals to bypass 
    ret_or_rti_signal_out <= ret_or_rti_signal_in;
    req_write_signal_out <= req_write_signal_in;  -- Added to bypass section
    mem_to_reg_signal_out <= mem_to_reg_signal_in;  -- Added to bypass section
    rti_signal_out <= rti_signal;
    int_signal_out <= int_signal;
    sp_out <= sp; 
    alu_output_out <= alu_output;
    r_dest_out <= r_dest_in;

    -- Increment and decrement the program counter
    pc_incremented <= std_logic_vector(unsigned(pc) + 1);
    pc_decremented <= std_logic_vector(unsigned(pc) - 1);

    -- Combine interrupt and return from interrupt signals
    int_or_rti <= rti_signal OR int_signal;
    int_or_call <= call_signal OR int_signal;

    -- Memory write and read enable signals
    memory_we <= mem_write_signal OR int_signal;
    memory_re <= mem_read_signal OR rti_signal;

    -- Multiplexer for memory address selection 
    mux10_sel <= sp_write_signal &  int_or_rti;

    memory_address_mux: mux_4_input
        GENERIC MAP (size => 16)
        PORT MAP (
            input_0 => alu_output(memory_address_size-1 DOWNTO 0),  
            input_1 => alu_output(memory_address_size-1 DOWNTO 0),  
            input_2 => sp(memory_address_size-1 DOWNTO 0),  
            input_3 => pc_decremented(memory_address_size-1 DOWNTO 0),  
            sel     => mux10_sel,
            result  => memory_address    
        );
    
    -- Multiplexer for selecting input to the next stage
    mux00: mux_2_input
        GENERIC MAP (size => reg_size)
        PORT MAP (
            input_0 => alu_input_2,  
            input_1 => pc_incremented, 
            sel     => int_or_call,
            result  => mux01_input_0    
        );

    -- Multiplexer for selecting data to write to memory
    mux01: mux_2_input
        GENERIC MAP (size => reg_size)
        PORT MAP (
            input_0 => mux01_input_0,  
            input_1 => flags, 
            sel     => int_signal,
            result  => memory_data_in    
        );

    -- RAM instantiation
    ram_port_map: ram
        GENERIC MAP (
            DATA_WIDTH => reg_size,
            ADDRESS_WIDTH => memory_address_size
        )
        PORT MAP (
            clk => clk,
            we => memory_we,
            re => memory_re,
            address => memory_address,
            data_in => memory_data_in,
            data_out => data_out
        );

END ARCHITECTURE memory_arch;
