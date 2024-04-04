library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity aes_key_expander is
    port
    (
        clk_in : in std_logic;
        rst_in : in std_logic;
        key_in: in std_logic_vector(127 downto 0);  -- 16 bytes key
        round_keys_out: out std_logic_vector((128*11) - 1 downto 0) -- We generate 11 round keys as result
    );
end aes_key_expander;

architecture aes_key_expander_arch of aes_key_expander is
    -- Declarative section
    constant N_ROUNDS : natural := 10;

    component g_function_word is
        generic
        (
            N_round : natural := 1
        );
        port
        (
            word_in : in std_logic_vector(31 downto 0);
            word_out: out std_logic_vector(31 downto 0)
        );
    end component;

    -- We need to generate 44 32-bit keys (4 first words are the the actual key, and the remaining ones are generated)
    type key_words is array (0 to 4*(N_ROUNDS + 1) - 1) of std_logic_vector(31 downto 0);
    signal words : key_words := (others => (others => '0'));

    -- We need to perform the g() function to 9 words (3, 7, 11, 15, 19, 23, 27, 31, 35 and 39)
    type generated_words is array (0 to N_ROUNDS - 1) of std_logic_vector(31 downto 0);
    signal g_words : generated_words := (others => (others => '0'));

begin
    -- Descriptive section
    -- Instantiate g_function_word DUTs and connect them
    G_FUNCTIONS: for i in 0 to N_ROUNDS-1 generate
    G_FUNCTION_i: g_function_word
        generic map
        (
            N_round => i + 1
        )
        port map
        (
            word_in => words(4*i + 3),
            word_out => g_words(i)
        );
    end generate;

    expand_key : process(clk_in)
    -- declarative part
    begin
        -- Serial instructions
        words(0) <= key_in(127 downto 96);
        words(1) <= key_in(95 downto 64);
        words(2) <= key_in(63 downto 32);
        words(3) <= key_in(31 downto 0);
        for i in 1 to (N_ROUNDS) loop
            words(4*i + 0) <= words(4*(i-1)) xor g_words(i-1);
            words(4*i + 1) <= words(4*(i-1) + 1) xor words(4*i + 0);
            words(4*i + 2) <= words(4*(i-1) + 2) xor words(4*i + 1);
            words(4*i + 3) <= words(4*(i-1) + 3) xor words(4*i + 2);
        end loop;
    end process expand_key;

    round_keys_concatenation: process(clk_in)
    begin
        round_keys_out <= (others => '0');
        for i in 0 to N_ROUNDS loop
            round_keys_out((i+1)*32-1 downto i*32) <= words(i); -- Assign each round key to the appropriate slice
        end loop;
    end process round_keys_concatenation;

end aes_key_expander_arch;