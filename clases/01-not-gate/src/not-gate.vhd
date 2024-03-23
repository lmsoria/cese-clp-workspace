library IEEE;
use IEEE.std_logic_1164.all;

entity not_gate is
    port(
        a_i: in std_logic;
        b_o: out std_logic
    );
end not_gate;

architecture not_gate_arq of not_gate is
    -- Declarative section
begin
    -- Descriptive section
    b_o <= not a_i;
end not_gate_arq;