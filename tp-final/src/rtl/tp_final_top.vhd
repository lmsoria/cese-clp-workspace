library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity tp_final_top is
port
(
    clk_pin_in : in std_logic;
    rst_pin_in : in std_logic;
    rx_pin_in  : in std_logic;
    tx_pin_out : out std_logic
);
end tp_final_top;

architecture tp_final_top_arch of tp_final_top is

    constant BAUD_RATE: positive := 115200;
    constant CLOCK_FREQUENCY: positive := 125e6;

    component aes_encoder is
    port
    (
        plain_text_in  : in std_logic_vector(127 downto 0);
        key_in         : in std_logic_vector(127 downto 0);
        cypher_text_out: out std_logic_vector(127 downto 0)
    );
    end component;

    component aes_decoder is
    port
    (
        cypher_text_in : in std_logic_vector(127 downto 0);
        key_in         : in std_logic_vector(127 downto 0);
        plain_text_out : out std_logic_vector(127 downto 0)
    );
    end component;

    component uart is
    generic
    (
        baud                : positive;
        clock_frequency     : positive
    );
    port
    (
        clock               : in  std_logic;
        reset               : in  std_logic;
        data_stream_in      : in  std_logic_vector(7 downto 0);
        data_stream_in_stb  : in  std_logic;
        data_stream_in_ack  : out std_logic;
        data_stream_out     : out std_logic_vector(7 downto 0);
        data_stream_out_stb : out std_logic;
        tx                  : out std_logic;
        rx                  : in  std_logic
    );
    end component;

    component generic_fifo is
    generic
    (
        fifo_width  : positive := 32;
        fifo_depth  : positive := 1024
    );
    port
    (
        clock       : in std_logic;
        reset       : in std_logic;
        write_data  : in std_logic_vector(FIFO_WIDTH-1 downto 0);
        read_data   : out std_logic_vector(FIFO_WIDTH-1 downto 0);
        write_en    : in std_logic;
        read_en     : in std_logic;
        full        : out std_logic;
        empty       : out std_logic;
        level       : out std_logic_vector(integer(ceil(log2(real(fifo_depth))))-1 downto 0)
    );
    end component;

    -- UART Signals
    signal uart_data_in : std_logic_vector(7 downto 0);  -- Data to transmit
    signal uart_data_out : std_logic_vector(7 downto 0); -- Received data
    signal uart_data_in_stb : std_logic := '0';
    signal uart_data_in_ack : std_logic := '0';
    signal uart_data_out_stb : std_logic := '0';

    -- Buffer signals
    constant BUFFER_DEPTH : integer := 2;
    signal fifo_data_out : std_logic_vector(7 downto 0);
    signal fifo_data_in  : std_logic_vector(7 downto 0);
    signal fifo_data_in_stb : std_logic;
    signal fifo_data_out_stb : std_logic;
    signal fifo_full : std_logic;
    signal fifO_empty : std_logic;

    -- AES Signals
    signal plain_text_bus_in : std_logic_vector(127 downto 0);
    signal plain_text_bus_out : std_logic_vector(127 downto 0);
    signal cipher_text_bus : std_logic_vector(127 downto 0);
    signal key_bus : std_logic_vector(127 downto 0);

begin

    -- Fixed Key
    key_bus <=
        std_logic_vector(to_unsigned(67, 8)) & -- 'C'
        std_logic_vector(to_unsigned(69, 8)) & -- 'E'
        std_logic_vector(to_unsigned(83, 8)) & -- 'S'
        std_logic_vector(to_unsigned(69, 8)) & -- 'E'
        std_logic_vector(to_unsigned(45, 8)) & -- '-'
        std_logic_vector(to_unsigned(67, 8)) & -- 'C'
        std_logic_vector(to_unsigned(76, 8)) & -- 'L'
        std_logic_vector(to_unsigned(80, 8)) & -- 'P'
        std_logic_vector(to_unsigned(45, 8)) & -- '-'
        std_logic_vector(to_unsigned(50, 8)) & -- '2'
        std_logic_vector(to_unsigned(48, 8)) & -- '0'
        std_logic_vector(to_unsigned(45, 8)) & -- '-'
        std_logic_vector(to_unsigned(50, 8)) & -- '2'
        std_logic_vector(to_unsigned(48, 8)) & -- '0'
        std_logic_vector(to_unsigned(50, 8)) & -- '2'
        std_logic_vector(to_unsigned(51, 8));  -- '3';

    plain_text_bus_in <= (127 downto 8 => '0') & uart_data_out;
    uart_data_in <= plain_text_bus_out(7 downto 0);

    AES128_ENCODER: aes_encoder
    port map
    (
        plain_text_in   => plain_text_bus_in,
        key_in          => key_bus,
        cypher_text_out => cipher_text_bus
    );

    AES128_DECODER: aes_decoder
    port map
    (
        cypher_text_in => cipher_text_bus,
        key_in         => key_bus,
        plain_text_out => plain_text_bus_out
    );

    UART_INSTANCE : uart
    generic map
    (
        baud                => BAUD_RATE,
        clock_frequency     => CLOCK_FREQUENCY
    )
    port map
    (
        clock               => clk_pin_in,
        reset               => rst_pin_in,
        data_stream_in      => uart_data_in,
        data_stream_in_stb  => uart_data_in_stb,
        data_stream_in_ack  => uart_data_in_ack,
        data_stream_out     => uart_data_out,
        data_stream_out_stb => uart_data_out_stb,
        tx                  => tx_pin_out,
        rx                  => rx_pin_in
    );


    -- Intermediate buffer for storing bytes received by the UART
    -- Bytes stored in this buffer are immediately retransmitted.
    RX_BUFFER : generic_fifo
    generic map
    (
        fifo_width  => 8,
        fifo_depth  => BUFFER_DEPTH
    )
    port map
    (
        clock        => clk_pin_in,
        reset        => rst_pin_in,
        write_data   => fifo_data_in,
        read_data    => fifo_data_out,
        write_en     => fifo_data_in_stb,
        read_en      => fifo_data_out_stb,
        full         => fifo_full,
        empty        => fifo_empty,
        level        => open
    );

    uart_loopback : process (clk_pin_in)
    begin
        if rising_edge(clk_pin_in) then
            if rst_pin_in = '1' then
                uart_data_in_stb <= '0';
                fifo_data_out_stb <= '0';
                fifo_data_in_stb <= '0';
            else
                -- Acknowledge data receive strobes and set up a transmission
                -- request
                fifo_data_in_stb <= '0';
                if uart_data_out_stb = '1' and fifo_full = '0' then
                    fifo_data_in_stb <= '1';
                    fifo_data_in <= uart_data_out;
                end if;
                -- Clear transmission request strobe upon acknowledge.
                if uart_data_in_ack = '1' then
                    uart_data_in_stb <= '0';
                end if;
                -- Transmit any data in the buffer
                fifo_data_out_stb <= '0';
                if fifo_empty = '0' then
                    if uart_data_in_stb = '0' then
                        uart_data_in_stb <= '1';
                        fifo_data_out_stb <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end tp_final_top_arch;