library IEEE;
use IEEE.std_logic_1164.all;

entity aes_sub_bytes_tb is
end aes_sub_bytes_tb;

architecture aes_sub_bytes_tb_arch of aes_sub_bytes_tb is
    -- Declarative section

    component aes_sub_bytes is
        port
        (
            state_in: in std_logic_vector(127 downto 0);
            result_out: out std_logic_vector(127 downto 0)
        );
    end component;

    signal tb_state_in: std_logic_vector(127 downto 0) := (others => '0');
    signal tb_result_out: std_logic_vector(127 downto 0);

begin

    stimulus_process: process
    begin
        tb_state_in <= x"000102030405060708090a0b0c0d0e0f"; -- expected output: x"63 7c	77 7b f2 6b 6f c5 30 01 67 2b fe d7 ab 76"
        wait for 100 ns;
        tb_state_in <= x"00102030405060708090a0b0c0d0e0f0"; -- expected output: x"63 ca b7 04 09 53 d0 51 cd 60 e0 e7 ba 70 e1 8c"
        wait for 100 ns;
        tb_state_in <= x"00112233445566778899aabbccddeeff"; -- expected output: x"63 82 93 c3 1b fc 33 f5 c4 ee ac ea 4b c1 28 16"
        wait for 100 ns;
        wait; -- Wait indefinitely
    end process stimulus_process;

    -- Descriptive section
    DUT: aes_sub_bytes
        port map
        (
            state_in => tb_state_in,
            result_out => tb_result_out
        );

end aes_sub_bytes_tb_arch;