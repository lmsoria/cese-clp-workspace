library IEEE;
use IEEE.std_logic_1164.all;

-- ENUNCIADO: Crear en VHDL un sumador de 4 bits de manera estructural. Simularlo.

entity sum_1bit is
port
(
    a_i: in std_logic;  -- A input
    b_i: in std_logic;  -- B input
    ci_i: in std_logic; -- Carry In
    s_o: out std_logic; -- Sum Out (A + B + CI)
    co_o: out std_logic -- Carry Out
);
end sum_1bit;

architecture sum_1bit_arq of sum_1bit is
    -- Declarative section
begin
    -- Descriptive section
    s_o <= a_i xor b_i xor ci_i;
    co_o <= (a_i and b_i) or (a_i and ci_i) or (b_i and ci_i);
end sum_1bit_arq;