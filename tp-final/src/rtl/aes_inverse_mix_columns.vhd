library ieee;
use ieee.std_logic_1164.all;

entity aes_inverse_mix_columns is
port
(
    state_in : in std_logic_vector (127 downto 0);
    result_out : out std_logic_vector (127 downto 0)
);
end aes_inverse_mix_columns;

architecture aes_mix_columns_arch of aes_inverse_mix_columns is
    -- Declarative section

    -- Standard 4x4 matrix which holds 16x 8-bit values (128 bits in total).
    type matrix is array(15 downto 0) of std_logic_vector(7 downto 0);

    -- Intermediate signals used to hold the "results" of the operations.
    signal vector_input : matrix;
    signal times_09 : matrix;
    signal times_11 : matrix;
    signal times_13 : matrix;
    signal times_14 : matrix;
    signal result : matrix;

    component multiply_by_9 is
    port
    (
        byte_in : in std_logic_vector (7 downto 0);
        byte_out : out std_logic_vector (7 downto 0)
    );
    end component;

    component multiply_by_11 is
    port
    (
        byte_in : in std_logic_vector (7 downto 0);
        byte_out : out std_logic_vector (7 downto 0)
    );
    end component;

    component multiply_by_13 is
    port
    (
        byte_in : in std_logic_vector (7 downto 0);
        byte_out : out std_logic_vector (7 downto 0)
    );
    end component;

    component multiply_by_14 is
    port
    (
        byte_in : in std_logic_vector (7 downto 0);
        byte_out : out std_logic_vector (7 downto 0)
    );
    end component;

    begin
    -- Descriptive section.

    -- Map the 128-bit plain bus into 16 vectors of 8 bits, and connect these bytes to the multipliers.
    state_to_matrix: for i in 15 downto 0 generate
        -- If vector_input = [ab cd 12 34 | ff aa ff bb | ...] then consider:
        -- [ab cd 12 34] as the first vector (aka vector_input(0), the first element of the array),
        -- [ff aa ff bb] as the second vector (aka vector_input(1), the second element of the array) and so on.
        vector_input(15-i) <= state_in((8*i)+7 downto (8*i));

        MULTIPLIER_BY_9_i: multiply_by_9
        port map
        (
            byte_in => vector_input(i),
            byte_out => times_09(i)
        );

        MULTIPLIER_BY_11_i: multiply_by_11
        port map
        (
            byte_in => vector_input(i),
            byte_out => times_11(i)
        );

        MULTIPLIER_BY_13_i: multiply_by_13
        port map
        (
            byte_in => vector_input(i),
            byte_out => times_13(i)
        );

        MULTIPLIER_BY_14_i: multiply_by_14
        port map
        (
            byte_in => vector_input(i),
            byte_out => times_14(i)
        );
    end generate;

    -- Perform the matrix multiplication by summing up (ie XOR'ing) the coefficients for each element
    matrix_multiplication: for i in 0 to 3 generate
        result(i*4 + 0) <= times_14(i*4 + 0) xor times_11(i*4 + 1) xor times_13(i*4 + 2) xor times_09(i*4 + 3); -- Row 0 [14 11 13 09].
        result(i*4 + 1) <= times_09(i*4 + 0) xor times_14(i*4 + 1) xor times_11(i*4 + 2) xor times_13(i*4 + 3); -- Row 1 [09 14 11 13].
        result(i*4 + 2) <= times_13(i*4 + 0) xor times_09(i*4 + 1) xor times_14(i*4 + 2) xor times_11(i*4 + 3); -- Row 2 [13 09 14 11].
        result(i*4 + 3) <= times_11(i*4 + 0) xor times_13(i*4 + 1) xor times_09(i*4 + 2) xor times_14(i*4 + 3); -- Row 3 [11 13 09 14].
    end generate;

    -- Now that we have the results, let's convert the vectors back to a 128-bit bus
    matrix_to_result: for i in 15 downto 0 generate
        result_out(((8*i) + 7) downto (8*i)) <= result(15 - i);
    end generate;

end aes_mix_columns_arch;