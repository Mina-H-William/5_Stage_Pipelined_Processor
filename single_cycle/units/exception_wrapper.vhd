LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exception_wrapper IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- Reset signal (active high)
        stack_pointer_address : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Stack pointer address
        memory_address : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Memory address to write
        pc_from_decode : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Program counter from decode stage
        pc_from_mem : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- Program counter from memory stage
        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- EPC output
        empty_stack_exception : OUT STD_LOGIC; -- Empty Stack Exception
        invalid_memory_exception : OUT STD_LOGIC -- Invalid Memory Address Exception
    );
END exception_wrapper;

ARCHITECTURE Behavioral OF exception_wrapper IS
    -- Internal signals for exceptions
    SIGNAL stack_exc : STD_LOGIC;
    SIGNAL mem_exc : STD_LOGIC;

    -- Signal for EPC output
    SIGNAL epc_output : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
    -- Instantiate the exception_detection_unit
    EXCEPTION_DETECTOR : ENTITY work.exception_detection_unit
        PORT MAP(
            stack_pointer_address => stack_pointer_address,
            memory_address => memory_address,
            empty_stack_exception => stack_exc,
            invalid_memory_exception => mem_exc
        );

    -- Instantiate the EPC
    EPC_UNIT : ENTITY work.epc
        PORT MAP(
            clk => clk,
            reset => reset,
            stack_exception => stack_exc,
            mem_exception => mem_exc,
            pc_from_decode => pc_from_decode,
            pc_from_mem => pc_from_mem,
            data_out => epc_output
        );

    -- Connect EPC output to wrapper output
    data_out <= epc_output;

    -- Connect exceptions to wrapper outputs
    empty_stack_exception <= stack_exc;
    invalid_memory_exception <= mem_exc;

END Behavioral;