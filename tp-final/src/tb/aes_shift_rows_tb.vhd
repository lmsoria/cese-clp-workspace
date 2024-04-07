library IEEE;
use IEEE.std_logic_1164.all;


entity aes_shift_rows_tb is
end aes_shift_rows_tb;

architecture aes_shift_rows_tb_arch of aes_shift_rows_tb is
    -- Declarative section
    component aes_shift_rows is
        port
        (
            state_in : in std_logic_vector (127 downto 0);
            result_out : out std_logic_vector (127 downto 0)
        );
    end component;

    signal tb_state_in: std_logic_vector(127 downto 0) := (others => '0');
    signal tb_result_out: std_logic_vector(127 downto 0);

begin
    -- Descriptive section

    stimulus_process: process
    begin
        tb_state_in <= x"000102030405060708090a0b0c0d0e0f"; -- expected output: x"00 05 0a 0f 04 09 0e 03 08 0d 02 07 0c 01 06 0b"
        wait for 100 ns;
        tb_state_in <= x"00112233445566778899aabbccddeeff"; -- expected output: x"00 55 aa ff 44 99 ee 33 88 dd 22 77 cc 11 66 bb"
        wait for 100 ns;
        tb_state_in <= x"ffeeddccbbaa99887766554433221100"; -- expected output: x"ff aa 55 00 bb 66 11 cc 77 22 dd 88 33 ee 99 44"
        wait for 100 ns;
        wait; -- Wait indefinitely
    end process stimulus_process;

    DUT: aes_shift_rows
    port map
    (
        state_in => tb_state_in,
        result_out => tb_result_out
    );
end aes_shift_rows_tb_arch;