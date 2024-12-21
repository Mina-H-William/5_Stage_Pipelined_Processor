library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pipeline_register is
    generic (
        WIDTH : integer := 32  -- Generic parameter for data width
    );
    port (
        clk         : in STD_LOGIC;                 -- Clock signal
        flush       : in STD_LOGIC;                 -- flush signal (active high)
        data_in     : in STD_LOGIC_VECTOR (WIDTH-1 downto 0); -- Input data
        data_out    : out STD_LOGIC_VECTOR (WIDTH-1 downto 0) -- Output data
    );
end pipeline_register;
                                        -- from up to down (up max value [width - 1])
architecture Behavioral of pipeline_register is
    signal register_value : STD_LOGIC_VECTOR (WIDTH-1 downto 0);
begin
    process(clk)
    begin
        if flush = '1' then
            -- Reset the register value
            register_value <= (others => '0');
        elsif rising_edge(clk) then
            -- Update the register value on the clock edge if enabled
            register_value <= data_in;
        end if;
    end process;

    -- Output the register value
    data_out <= register_value;

end Behavioral;