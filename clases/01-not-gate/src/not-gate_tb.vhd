library IEEE;
use IEEE.std_logic_1164.all;

entity not_gate_tb is
end not_gate_tb;

architecture not_gate_tb_arq of not_gate_tb is
    -- Declarative section

    component not_gate is
        port(
            a_i: in std_logic;
            b_o: out std_logic
        );
    end component not_gate;

    signal a_tb: std_logic := '1';
    signal b_tb: std_logic;

begin
    -- Descriptive section

    a_tb <= '0' after 100 ns, '1' after 250 ns, '0' after 300 ns;

    DUT: not_gate
        port map(
            a_i => a_tb,
            b_o => b_tb
        );
end;