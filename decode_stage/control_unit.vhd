LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY control_unit IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
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
        alu_func_signal : OUT STD_LOGIC
    );
END control_unit;

ARCHITECTURE Behavioral OF control_unit IS
BEGIN
    PROCESS (opcode)
    BEGIN
        ret_or_rti_signal <= '0';
        reg_write_signal <= '0';
        jmp_signal <= '0';
        mem_to_reg_signal <= '0';
        mem_read_signal <= '0';
        mem_write_signal <= '0';
        int_signal <= '0';
        set_carry_signal <= '0';
        rti_signal <= '0';
        sp_write_signal <= '0';
        add_or_subtract_signal <= '0';
        freeze_signal <= '0';
        call_signal <= '0';
        out_signal <= '0';
        in_signal <= '0';
        is_immediate_signal <= '0';
        jz_signal <= '0';
        jc_signal <= '0';
        jn_signal <= '0';
        pass_data_2_signal <= '0';
        pass_data_1_signal <= '0';
        not_signal <= '0';
        add_offset_signal <= '0';
        alu_func_signal <= '0';

        -- Decode OPCODE
        CASE opcode IS
            WHEN "00000" => --nop
                NULL;
            WHEN "00001" => -- hlt
                freeze_signal <= '1';
            WHEN "00010" => -- setc
                set_carry_signal <= '1';
            WHEN "00011" => -- add, sub, and, inc
                alu_func_signal <= '1';
                reg_write_signal <= '1';
            WHEN "00100" => -- iadd
                alu_func_signal <= '1';
                reg_write_signal <= '1';
                is_immediate_signal <= '1';
            WHEN "00101" => -- out
                out_signal <= '1';
                pass_data_1_signal <= '1';
            WHEN "00110" => -- in
                in_signal <= '1';
                reg_write_signal <= '1';
            WHEN "00111" => -- not
                reg_write_signal <= '1';
                not_signal <= '1';
            WHEN "01000" => -- move
                reg_write_signal <= '1';
                pass_data_1_signal <= '1';
            WHEN "01001" => -- push
                mem_write_signal <= '1';
                sp_write_signal <= '1';
            WHEN "01010" => -- pop
                mem_to_reg_signal <= '1';
                mem_read_signal <= '1';
                reg_write_signal <= '1';
                sp_write_signal <= '1';
                add_or_subtract_signal <= '1';
            WHEN "01011" => -- ldm
                reg_write_signal <= '1';
                is_immediate_signal <= '1';
                pass_data_2_signal <= '1';
            WHEN "01100" => -- ldd
                mem_to_reg_signal <= '1';
                mem_read_signal <= '1';
                reg_write_signal <= '1';
                alu_func_signal <= '1';
                is_immediate_signal <= '1';
            WHEN "01101" => -- std
                mem_write_signal <= '1';
                add_offset_signal <= '1';
                is_immediate_signal <= '1';
            WHEN "10000" => -- jz
                jz_signal <= '1';
            WHEN "10001" => -- jn
                jn_signal <= '1';
            WHEN "10010" => -- jc
                jc_signal <= '1';
            WHEN "10011" => -- jmp
                jmp_signal <= '1';
            WHEN "10100" => -- call
                call_signal <= '1';
                mem_write_signal <= '1';
                sp_write_signal <= '1';
                add_or_subtract_signal <= '1';
            WHEN "10101" => -- ret
                ret_or_rti_signal <= '1';
                mem_read_signal <= '1';
                sp_write_signal <= '1';
            WHEN "10110" => -- int
                int_signal <= '1';
                mem_write_signal <= '1';
            WHEN "10111" => -- rti
                ret_or_rti_signal <= '1';
                mem_read_signal <= '1';
                sp_write_signal <= '1';
                rti_signal <= '1';
            WHEN OTHERS =>
                NULL; -- Default: Do nothing
        END CASE;
    END PROCESS;
END Behavioral;