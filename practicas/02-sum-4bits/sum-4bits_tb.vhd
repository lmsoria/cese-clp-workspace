library IEEE;
use IEEE.std_logic_1164.all;

-- ENUNCIADO: Crear en VHDL un sumador de 4 bits de manera estructural. Simularlo.

entity sum_4bits_tb is
end sum_4bits_tb;

architecture sum_4bits_tb_arq of sum_4bits_tb is
    -- Declarative section

    component sum_4bits is
    port
    (
        a_i: in std_logic_vector(3 downto 0);
        b_i: in std_logic_vector(3 downto 0);
        ci_i: in std_logic;
        s_o: out std_logic_vector(3 downto 0);
        co_o: out std_logic
    );
    end component;

    signal a_tb: std_logic_vector(3 downto 0) := "0000";
    signal b_tb: std_logic_vector(3 downto 0) := "0000";
    signal ci_tb: std_logic_vector(3 downto 0) := "0000";
    signal s_tb: std_logic_vector(3 downto 0);
    signal co_tb: std_logic_vector(3 downto 0);

begin
    -- Descriptive section

    a_tb <= not a_tb after 10 ns;
    b_tb <= not b_tb after 20 ns;
    ci_tb <= not ci_tb after 40 ns;

    DUT: sum_4bits
    port map
    (
        a_i => a_tb,
        b_i => b_tb,
        ci_i => ci_tb,
        s_o => s_tb,
        co_o => co_tb
    );
end;