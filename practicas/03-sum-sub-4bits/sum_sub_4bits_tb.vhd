library IEEE;
use IEEE.std_logic_1164.all;

entity sum_sub_4bits_tb is
end sum_sub_4bits_tb;

architecture sum_sub_4bits_tb_arq of sum_sub_4bits_tb is
    -- Declarative section
    component sum_sub_4bits is
        port
        (
            a_i: in std_logic_vector(3 downto 0);  -- 4-bit A input
            b_i: in std_logic_vector(3 downto 0);  -- 4-bit B input
            ci_i: in std_logic;                    -- Carry In for the 1st bit
            op_i: in std_logic;                    -- Operation control (1: add, 0: subtract)
            s_o: out std_logic_vector(3 downto 0); -- 4-bit Sum Out
            co_o: out std_logic                    -- Carry Out
        );
        end component;



    -- Testing variables
    signal a_tb  : std_logic_vector(3 downto 0) := "0000";
    signal b_tb  : std_logic_vector(3 downto 0) := "0000";
    signal ci_tb : std_logic := '0';
    signal op_tb : std_logic := '0';
    signal s_tb  : std_logic_vector(3 downto 0);
    signal co_tb : std_logic;
begin
    -- Descriptive section

    DUT: sum_sub_4bits
    port map
    (
        a_i => a_tb,
        b_i => b_tb,
        ci_i => ci_tb,
        op_i => op_tb,
        s_o => s_tb,
        co_o => co_tb
    );

    stimulus_process: process
    begin
        a_tb <= "0000";
        b_tb <= "0000";
        ci_tb <= '0';
        op_tb <= '1';
        wait for 10 ns;

        a_tb <= "0000";
        b_tb <= "0000";
        ci_tb <= '1';
        op_tb <= '1';
        wait for 10 ns;

        a_tb <= "0001";
        b_tb <= "0000";
        ci_tb <= '1';
        op_tb <= '1';
        wait for 10 ns;

        a_tb <= "0001";
        b_tb <= "0001";
        ci_tb <= '1';
        op_tb <= '1';
        wait for 10 ns;



        a_tb <= "0000";
        b_tb <= "0000";
        ci_tb <= '0';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "0000";
        b_tb <= "0000";
        ci_tb <= '1';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "0001";
        b_tb <= "0000";
        ci_tb <= '1';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "0001";
        b_tb <= "0001";
        ci_tb <= '1';
        op_tb <= '0';
        wait for 10 ns;


        a_tb <= "1100";
        b_tb <= "0101";
        ci_tb <= '0';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "1001";
        b_tb <= "1100";
        ci_tb <= '1';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "1111";
        b_tb <= "0000";
        ci_tb <= '1';
        op_tb <= '0';
        wait for 10 ns;

        a_tb <= "1111";
        b_tb <= "0001";
        ci_tb <= '1';
        op_tb <= '1';
        wait for 10 ns;

        wait; -- Wait indefinitely
    end process stimulus_process;


end sum_sub_4bits_tb_arq;
