library IEEE;
use IEEE.std_logic_1164.all;

entity substitute_N_bytes is
    generic
    (
        N_bytes : natural := 4
    );
    port
    (
        data_in: in std_logic_vector((N_bytes * 8 - 1) downto 0);
        data_out: out std_logic_vector((N_bytes * 8 - 1) downto 0)
    );
end substitute_N_bytes;

architecture substitute_N_bytes_arch of substitute_N_bytes is
    -- Declarative section
    component s_box is
        port
        (
            byte_in : in std_logic_vector (7 downto 0);
            byte_out : out std_logic_vector (7 downto 0)
        );
    end component;
begin
    -- Descriptive section.

    -- Use a generate statement for "cascading" the LUTs on the corresponding bytes positions
    sub_bytes_generate: for i in 0 to (N_bytes - 1) generate
        s_box_inst: s_box
        port map
        (
            byte_in => data_in(8*(i + 1) - 1 downto 8*i),
            byte_out => data_out(8*(i + 1) - 1 downto 8*i)
        );
    end generate;
end substitute_N_bytes_arch;