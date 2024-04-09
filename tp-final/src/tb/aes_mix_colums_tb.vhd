library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity aes_mix_columns_tb is
end aes_mix_columns_tb;

architecture aes_mix_columns_tb_arch of aes_mix_columns_tb is
    -- Declarative section

    component aes_mix_columns is
    port
    (
        state_in : in std_logic_vector (127 downto 0);
        result_out : out std_logic_vector (127 downto 0)
    );
    end component;

    component aes_inverse_mix_columns is
    port
    (
        state_in : in std_logic_vector (127 downto 0);
        result_out : out std_logic_vector (127 downto 0)
    );
    end component;

    signal tb_state_in: std_logic_vector(127 downto 0) := (others => '0');
    signal tb_normal_result_out: std_logic_vector(127 downto 0);
    signal tb_inverted_result_out: std_logic_vector(127 downto 0);

begin
    -- Descriptive section

    stimulus_process: process
    begin
        tb_state_in <= x"db135345f20a225c01010101c6c6c6c6";
        wait for 100 ns;

        tb_state_in <= x"01010101c6c6c6c6f20a225cd4d4d4d5";
        wait for 100 ns;

        tb_state_in <= x"2d26314cd4bf5d302d26314cd4bf5d30";
        wait for 100 ns;

        wait; -- Wait indefinitely
    end process stimulus_process;

    NORMAL_MIX_COLUMNS: aes_mix_columns
    port map
    (
        state_in => tb_state_in,
        result_out => tb_normal_result_out
    );

    INVERSE_MIX_COLUMNS: aes_inverse_mix_columns
    port map
    (
        state_in => tb_state_in,
        result_out => tb_inverted_result_out
    );
end aes_mix_columns_tb_arch;