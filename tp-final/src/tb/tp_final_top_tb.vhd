library ieee;
use ieee.std_logic_1164.all;

entity tp_final_top_tb is
end tp_final_top_tb;

architecture tp_final_top_tb_arch of tp_final_top_tb is

    -- Test Bench uses a 50 MHz Clock
    -- Want to interface to 115200 baud UART
    -- 50000000 / 115200 = 87 Clocks Per Bit.
    constant c_CLKS_PER_BIT : integer := 434;

    -- 1/115200 ~= 8680 ns.
    constant c_BIT_PERIOD : time := 8680 ns;

  -- Low-level byte-write
  procedure UART_WRITE_BYTE (
    i_data_in       : in  std_logic_vector(7 downto 0);
    signal o_serial : out std_logic
  ) is
  begin

    -- Send Start Bit
    o_serial <= '0';
    wait for c_BIT_PERIOD;

    -- Send Data Byte
    for ii in 0 to 7 loop
      o_serial <= i_data_in(ii);
      wait for c_BIT_PERIOD;
    end loop;  -- ii

    -- Send Stop Bit
    o_serial <= '1';
    wait for c_BIT_PERIOD;
    end UART_WRITE_BYTE;

    component tp_final_top is
    port
    (
        clk_pin_in : in std_logic;
        rst_pin_in : in std_logic;
        rx_pin_in : in std_logic;
        tx_pin_out : out std_logic
    );
    end component;

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal rx_tb : std_logic := '1';
    signal tx_tb : std_logic;

begin
    DUT : tp_final_top
    port map
    (
        clk_pin_in => clk_tb,
        rst_pin_in => rst_tb,
        rx_pin_in  => rx_tb,
        tx_pin_out => tx_tb
    );

    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0';

    send_byte: process
    begin
      -- Send a command to the UART
      wait until rising_edge(clk_tb);
      rx_tb <= '0';
      wait for c_BIT_PERIOD;

      rx_tb <= '1';
      wait for c_BIT_PERIOD;
      rx_tb <= '0';
      wait for c_BIT_PERIOD;
      rx_tb <= '1';
      wait for c_BIT_PERIOD;
      rx_tb <= '0';
      wait for c_BIT_PERIOD;
      rx_tb <= '1';
      wait for c_BIT_PERIOD;
      rx_tb <= '0';
      wait for c_BIT_PERIOD;
      rx_tb <= '0';
      wait for c_BIT_PERIOD;
      rx_tb <= '1';
      wait for c_BIT_PERIOD;

    -- -- Send Start Bit
    -- o_serial <= '0';
    -- wait for c_BIT_PERIOD;

    -- -- Send Data Byte
    -- for ii in 0 to 7 loop
    --   o_serial <= i_data_in(ii);
    --   wait for c_BIT_PERIOD;
    -- end loop;  -- ii

    -- -- Send Stop Bit
    -- o_serial <= '1';
    -- wait for c_BIT_PERIOD;
      wait until rising_edge(clk_tb);
    end process;
end tp_final_top_tb_arch;