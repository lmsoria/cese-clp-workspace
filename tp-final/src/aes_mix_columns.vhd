library IEEE;
use IEEE.std_logic_1164.all;

entity aes_mix_columns is
    port
    (
        state_in : in std_logic_vector (127 downto 0);
        result_out : out std_logic_vector (127 downto 0)
    );
end aes_mix_columns;

architecture aes_mix_columns_arch of aes_mix_columns is
    -- Declarative section

    -- Standard 4x4 matrix which holds 16x 8-bit values (128 bits in total).
    type matrix is array(15 downto 0) of std_logic_vector(7 downto 0);

    -- Intermediate signals used to hold the "results" of the operations.
    signal matrix_current : matrix;
    signal original : matrix;
    signal doubled : matrix;
    signal tripled : matrix;
    signal result : matrix;

    component multiply_by_1_2_and_3 is
        port
        (
            byte_in : in std_logic_vector (7 downto 0);
            byte_by_1_out : out std_logic_vector (7 downto 0);
            byte_by_2_out : out std_logic_vector (7 downto 0);
            byte_by_3_out : out std_logic_vector (7 downto 0)
        );
    end component;

    begin
    -- Descriptive section.

    map_to_matrix: for i in 15 downto 0 generate
        matrix_current(15-i) <= state_in((8*i)+7 downto (8*i));
        MULTIPLIER_i: multiply_by_1_2_and_3
        port map
        (
            byte_in => matrix_current(i),
            byte_by_1_out => original(i),
            byte_by_2_out => doubled(i),
            byte_by_3_out => tripled(i)
        );
    end generate;

    -- TODO: Write me in a more compact way!

    -- Row 0 [2 3 1 1].
    result(0) <= doubled(0) xor tripled(1) xor original(2) xor original(3);
    result(4) <= doubled(4) xor tripled(5) xor original(6) xor original(7);
    result(8) <= doubled(8) xor tripled(9) xor original(10) xor original(11);
    result(12) <= doubled(12) xor tripled(13) xor original(14) xor original(15);

    -- Row 1 [1 2 3 1].
    result(1) <= original(0) xor doubled(1) xor tripled(2) xor original(3);
    result(5) <= original(4) xor doubled(5) xor tripled(6) xor original(7);
    result(9) <= original(8) xor doubled(9) xor tripled(10) xor original(11);
    result(13) <= original(12) xor doubled(13) xor tripled(14) xor original(15);

    -- Row 2 [1 1 2 3].
    result(2) <= original(0) xor original(1) xor doubled(2) xor tripled(3);
    result(6) <= original(4) xor original(5) xor doubled(6) xor tripled(7);
    result(10) <= original(8) xor original(9) xor doubled(10) xor tripled(11);
    result(14) <= original(12) xor original(13) xor doubled(14) xor tripled(15);

    -- Row 3 [3 1 1 2].
    result(3) <= tripled(0) xor original(1) xor original(2) xor doubled(3);
    result(7) <= tripled(4) xor original(5) xor original(6) xor doubled(7);
    result(11) <= tripled(8) xor original(9) xor original(10) xor doubled(11);
    result(15) <= tripled(12) xor original(13) xor original(14) xor doubled(15);

    matrix_to_result: for i in 15 downto 0 generate
        result_out(((8*i) + 7) downto (8*i)) <= result(15 - i);
    end generate;

end aes_mix_columns_arch;