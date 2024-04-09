library IEEE;
use IEEE.std_logic_1164.all;

entity aes_inverse_round is
port
(
    state_in: in std_logic_vector(127 downto 0);
    key_in: in std_logic_vector(127 downto 0);
    result_out: out std_logic_vector(127 downto 0)
);
end aes_inverse_round;

architecture aes_inverse_round_arch of aes_inverse_round is
    -- Declarative section

    component aes_inverse_sub_bytes is
    port
    (
        state_in: in std_logic_vector(127 downto 0);
        result_out: out std_logic_vector(127 downto 0)
    );
    end component;

    component aes_inverse_shift_rows is
    port
    (
        state_in: in std_logic_vector(127 downto 0);
        result_out: out std_logic_vector(127 downto 0)
    );
    end component;

    component aes_inverse_mix_columns is
    port
    (
        state_in: in std_logic_vector(127 downto 0);
        result_out: out std_logic_vector(127 downto 0)
    );
    end component;

    signal inverse_substituted_bytes: std_logic_vector(127 downto 0);
    signal inverse_shifted_rows: std_logic_vector(127 downto 0);
    signal inverse_mixed_columns: std_logic_vector(127 downto 0);
    signal added_round_key: std_logic_vector(127 downto 0);

begin

    SHIFT_ROWS : aes_inverse_shift_rows
    port map
    (
        state_in => state_in,
        result_out => inverse_shifted_rows
    );

    SUB_BYTES : aes_inverse_sub_bytes
    port map
    (
        state_in => inverse_shifted_rows,
        result_out => inverse_substituted_bytes
    );

    added_round_key <= inverse_substituted_bytes xor key_in;

    MIX_COLUMNS : aes_inverse_mix_columns
    port map
    (
        state_in => added_round_key,
        result_out => inverse_mixed_columns
    );

    result_out <= inverse_mixed_columns;

end aes_inverse_round_arch;