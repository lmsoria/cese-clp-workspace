library IEEE;
use IEEE.std_logic_1164.all;

entity aes_decoder is
port
(
    cypher_text_in: in std_logic_vector(127 downto 0);
    key_in: in std_logic_vector(127 downto 0);
    clk_in: in std_logic;
    plain_text_out: out std_logic_vector(127 downto 0)
);
end aes_decoder;

architecture aes_decoder_arch of aes_decoder is

    -- Declarative section
    type round_data is array (1 to 9) of std_logic_vector(127 downto 0);
    type key_array is array(0 to 10) of std_logic_vector(127 downto 0);

    component aes_key_expander is
    port
    (
        key_in: in std_logic_vector(127 downto 0);  -- 16 bytes key
        round_keys_out: out std_logic_vector((128*11) - 1 downto 0) -- We generate 11 round keys as result
    );
    end component;

    component aes_inverse_round is
    port
    (
        state_in: in std_logic_vector(127 downto 0);
        key_in: in std_logic_vector(127 downto 0);
        result_out: out std_logic_vector(127 downto 0)
    );
    end component;

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

    signal round_keys: std_logic_vector((128*11) - 1 downto 0);
    signal inverse_substituted_bytes: std_logic_vector(127 downto 0);
    signal inverse_shifted_rows: std_logic_vector(127 downto 0);
    signal keys : key_array;
    signal round_inputs: round_data;
    signal round_outputs: round_data;

begin

    -- 01. Instantiate aes_key_expander
    KEY_EXPANDER : aes_key_expander
    port map
    (
        key_in => key_in,
        round_keys_out => round_keys
    );

    -- 02. Route the expanded key (1408 bits) to individual keys (11 x 128bits).
    -- For the decoder the first key must be the last expanded key, and the last key must be the original key.
    EXPAND_KEYS: for i in 0 to 10 generate
        keys(i) <= round_keys( (128*(11-i) - 1) downto (128*(10-i)) );
    end generate;

    -- 03. Instantiate the rounds 1 to 9 and connect them to the signal arrays
    GENERATE_ROUNDS: for i in 1 to 9 generate
    ROUND_i: aes_inverse_round
    port map
    (
        state_in => round_inputs(i),
        key_in => keys(10 - i),
        result_out => round_outputs(i)
    );
    end generate;

    -- 04. Connect each round input with the previous round's output, with exception
    -- of the first round which is the XOR operation between the cypher text and the last expanded key
    round_inputs(1) <= cypher_text_in xor keys(10);
    CONNECT_ROUNDS: for i in 2 to 9 generate
        round_inputs(i) <= round_outputs(i - 1);
    end generate;

    -- 05. The last round (number 10) is quite similar, but without the MixColumns step.
    -- We're doing it manually


    -- 05.01: Inverse Shift rows
    INVERSE_SHIFT_ROWS : aes_inverse_shift_rows
    port map
    (
        state_in => round_outputs(9),
        result_out => inverse_shifted_rows
    );

    -- 05.02: Inverse Substitute bytes from the last round
    INVERSE_SUB_BYTES : aes_inverse_sub_bytes
    port map
    (
        state_in => inverse_shifted_rows,
        result_out => inverse_substituted_bytes
    );

    -- 05.03: Add the original key, and with this we have the cypher text!
    plain_text_out <= inverse_substituted_bytes xor keys(0);

end aes_decoder_arch;