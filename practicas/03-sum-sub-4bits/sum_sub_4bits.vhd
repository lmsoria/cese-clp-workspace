library IEEE;
use IEEE.std_logic_1164.all;

entity sum_sub_4bits is
port
(
    a_i: in std_logic_vector(3 downto 0);  -- 4-bit A input
    b_i: in std_logic_vector(3 downto 0);  -- 4-bit B input
    ci_i: in std_logic;                    -- Carry In for the 1st bit
    op_i: in std_logic;                    -- Operation control (0: add, 1: subtract)
    s_o: out std_logic_vector(3 downto 0); -- 4-bit Sum Out
    co_o: out std_logic                    -- Carry Out
);
end sum_sub_4bits;

architecture sum_sub_4bits_arq of sum_sub_4bits is
    -- Internal signals
    signal aux: std_logic_vector(4 downto 0);
    signal tmp_b_i : std_logic_vector(3 downto 0);

    -- Component instantiation
    component sum_1bit is
    port
    (
        a_i: in std_logic;   -- A input
        b_i: in std_logic;   -- B input
        ci_i: in std_logic;  -- Carry In
        s_o: out std_logic;  -- Sum Out (A + B + CI)
        co_o: out std_logic  -- Carry Out
    );
    end component;

    -- Declarative section
begin

    tmp_b_i(0) <= b_i(0) xor op_i;
    tmp_b_i(1) <= b_i(1) xor op_i;
    tmp_b_i(2) <= b_i(2) xor op_i;
    tmp_b_i(3) <= b_i(3) xor op_i;

    aux(0) <= op_i;

    -- Descriptive section
    sum0: sum_1bit
    port map
    (
        a_i  => a_i(0),
        b_i  => tmp_b_i(0),
        ci_i => ci_i,
        s_o  => s_o(0),
        co_o => aux(1)
    );

    sum1: sum_1bit
    port map
    (
        a_i  => a_i(1),
        b_i  => tmp_b_i(1),
        ci_i => aux(1),
        s_o  => s_o(1),
        co_o => aux(2)
    );

    sum2: sum_1bit
    port map
    (
        a_i  => a_i(2),
        b_i  => tmp_b_i(2),
        ci_i => aux(2),
        s_o  => s_o(2),
        co_o => aux(3)
    );

    sum3: sum_1bit
    port map
    (
        a_i  => a_i(3),
        b_i  => tmp_b_i(3),
        ci_i => aux(3),
        s_o  => s_o(3),
        co_o => aux(4)
    );

    co_o <= aux(4) xor op_i;

end sum_sub_4bits_arq;
