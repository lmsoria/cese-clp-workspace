library IEEE;
use IEEE.std_logic_1164.all;

-- ENUNCIADO: Crear en VHDL un sumador de 4 bits de manera estructural. Simularlo.

entity sum_4bits is
port
(
    a_i: in std_logic_vector(3 downto 0);
    b_i: in std_logic_vector(3 downto 0);
    ci_i: in std_logic;
    s_o: out std_logic_vector(3 downto 0);
    co_o: out std_logic
);
end sum_4bits;

architecture sum_4bits_arq of sum_4bits is
    component sum_1bit is
    port
    (
        a_i: in std_logic;  -- A input
        b_i: in std_logic;  -- B input
        ci_i: in std_logic; -- Carry In
        s_o: out std_logic; -- Sum Out (A + B + CI)
        co_o: out std_logic -- Carry Out
    );
    end component;

    signal carries_aux: std_logic_vector(4 downto 0);
begin
    -- Descriptive section

    carries_aux(0) <= ci_i;

    sum1bit_0 : sum_1bit
    port map
    (
        a_i => a_i(0),
        b_i => b_i(0),
        ci_i => carries_aux(0),
        s_o => s_o(0),
        co_o => carries_aux(1)
    );

    sum1bit_1 : sum_1bit
    port map
    (
        a_i => a_i(1),
        b_i => b_i(1),
        ci_i => carries_aux(1),
        s_o => s_o(1),
        co_o => carries_aux(2)
    );

    sum1bit_2 : sum_1bit
    port map
    (
        a_i => a_i(2),
        b_i => b_i(2),
        ci_i => carries_aux(2),
        s_o => s_o(2),
        co_o => carries_aux(3)
    );

    sum1bit_3 : sum_1bit
    port map
    (
        a_i => a_i(3),
        b_i => b_i(3),
        ci_i => carries_aux(3),
        s_o => s_o(3),
        co_o => carries_aux(4)
    );

    co_o <= carries_aux(4);
end sum_4bits_arq;