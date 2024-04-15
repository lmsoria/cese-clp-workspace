library IEEE;
use IEEE.std_logic_1164.all;

-- ENUNCIADO: Crear en VHDL un sumador completo de 1 bit. Simularlo.

entity sum_1bit_tb is
end sum_1bit_tb;

architecture sum_1bit_tb_arq of sum_1bit_tb is
    -- Declarative section

    component sum_1bit is
    port
    (
        a_i: in std_logic;
        b_i: in std_logic;
        ci_i: in std_logic;
        s_o: out std_logic;
        co_o: out std_logic
    );
    end component;

    signal a_tb: std_logic := '0';
    signal b_tb: std_logic := '0';
    signal ci_tb: std_logic := '0';
    signal s_tb: std_logic;
    signal co_tb: std_logic;

begin
    -- Descriptive section

    a_tb <= not a_tb after 10 ns;
    b_tb <= not b_tb after 20 ns;
    ci_tb <= not ci_tb after 40 ns;


    DUT: sum_1bit
    port map
    (
        a_i => a_tb,
        b_i => b_tb,
        ci_i => ci_tb,
        s_o => s_tb,
        co_o => co_tb
    );
end;