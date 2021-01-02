----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 12/05/2020 01:55:06 PM
-- Module Name: System_tb - Behavioral
-- Project Name:  Waweform generator
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity System_tb is
end;

architecture bench of System_tb is

  component System
    generic (
    CE                : STD_LOGIC := '1';
    RST               : STD_LOGIC := '0';
    DATA_WIDTH        : NATURAL   := 12;
    A_WIDTH           : NATURAL   := 4;
    TETA_WIDTH        : NATURAL   := 8;
    AMP_WIDTH         : NATURAL   := 4;
    OFF_WIDTH         : NATURAL   := 12;
    LUT_ADDRESS_WIDTH : NATURAL   := 8);
    port (
      src_clk      : in STD_LOGIC;
      src_ce       : in STD_LOGIC;
      reset        : in STD_LOGIC;
      start        : in STD_LOGIC;
    a          : STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0);
    s          : in STD_LOGIC_VECTOR(1 downto 0);
    teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    amp        : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0) ;
    k0         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    k1         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    d0         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    d1         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    off        : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0) ;
      out_spi_sck  : out STD_LOGIC;
      out_spi_miso : in STD_LOGIC;
      out_spi_mosi : out STD_LOGIC;
      out_spi_cs   : out STD_LOGIC
    );
  end component;

  signal src_clk           : STD_LOGIC;
  signal src_ce            : STD_LOGIC;
  signal reset             : STD_LOGIC;
  signal start             : STD_LOGIC;
  signal a          : STD_LOGIC_VECTOR(3 downto 0);
  signal s                 : STD_LOGIC_VECTOR(1 downto 0);
  signal teta    : STD_LOGIC_VECTOR(7 downto 0);
  signal amp        : STD_LOGIC_VECTOR(3 downto 0);
  signal k0         :  STD_LOGIC_VECTOR(7 downto 0);
  signal k1         :  STD_LOGIC_VECTOR(7 downto 0);
  signal d0         :  STD_LOGIC_VECTOR(7 downto 0);
  signal d1         :  STD_LOGIC_VECTOR(7 downto 0);
  signal off        :  STD_LOGIC_VECTOR(11 downto 0) ;
  signal out_spi_sck       : STD_LOGIC;
  signal out_spi_miso      : STD_LOGIC;
  signal out_spi_mosi      : STD_LOGIC;
  signal out_spi_cs        : STD_LOGIC;

  signal stimulated_output : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  signal spi_value         : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  constant clock_period    : TIME                           := 50 ns;
  signal stop_the_clock    : BOOLEAN;

begin

  -- Insert values for generic parameters !!
  uut : System port map(
    src_clk      => src_clk,
    src_ce       => src_ce,
    reset        => reset,
    start        => start,
    a=>a,
    s            => s,
    teta => teta,
    amp=>amp,
    k0  => k0  ,
    k1  => k1  ,
    d0  => d0  ,
    d1  => d1  ,
    off => off ,
    out_spi_sck  => out_spi_sck,
    out_spi_miso => out_spi_miso,
    out_spi_mosi => out_spi_mosi,
    out_spi_cs   => out_spi_cs);

  stimulus : process
  begin

    reset        <= '0';
    src_ce       <= '1';
    start        <= '1';
    out_spi_miso <= '0';
    
    
    k0 <=   STD_LOGIC_VECTOR(to_signed(16, 8));
k1  <= STD_LOGIC_VECTOR(to_signed(16, 8));
d0  <= STD_LOGIC_VECTOR(to_signed(255, 8));
d1  <=STD_LOGIC_VECTOR(to_signed(255, 8));
off <= STD_LOGIC_VECTOR(to_signed(0, 12));

    wait for clock_period / 2;
    reset <= '1';

    wait for clock_period / 2;
    
    s            <= "00";
    a<=STD_LOGIC_VECTOR(to_signed(12, 4));
    teta         <= STD_LOGIC_VECTOR(to_signed(70, 8));
    amp <=STD_LOGIC_VECTOR(to_signed(0, 4));
    wait for 20000 * clock_period;
    a<=STD_LOGIC_VECTOR(to_signed(15, 4));
    teta         <= STD_LOGIC_VECTOR(to_signed(0, 8));
    amp <=STD_LOGIC_VECTOR(to_signed(2, 4));
    wait for 10000 * clock_period;
    
    
    s <= "01";
    teta         <= STD_LOGIC_VECTOR(to_signed(128, 8));
    wait for 10000 * clock_period;
    amp<=STD_LOGIC_VECTOR(to_signed(1, 4));
    wait for 10000 * clock_period;
    teta         <= STD_LOGIC_VECTOR(to_signed(0, 8));
    amp<=STD_LOGIC_VECTOR(to_signed(4, 4));
    wait for 10000 * clock_period;
    
    
    s <= "10";
    amp <=STD_LOGIC_VECTOR(to_signed(1, 4));
    wait for 30000 * clock_period;
    
    amp <=STD_LOGIC_VECTOR(to_signed(3, 4));
    k0 <= STD_LOGIC_VECTOR(to_signed(1, 8));
    wait for 30000 * clock_period;
    
    k0 <= STD_LOGIC_VECTOR(to_signed(16, 8));
    k1 <= STD_LOGIC_VECTOR(to_signed(32, 8));
    d1 <= STD_LOGIC_VECTOR(to_signed(127, 8));
    amp <=STD_LOGIC_VECTOR(to_signed(0, 4));
    wait for 20000 * clock_period;
    
    
    s <= "11";
    k0 <= STD_LOGIC_VECTOR(to_signed(8, 8));
        k1 <= STD_LOGIC_VECTOR(to_signed(8, 8));
    d0 <= STD_LOGIC_VECTOR(to_signed(0, 8));
    wait for 10000 * clock_period;

    reset <= '0';
    wait for 5 * clock_period;

    stop_the_clock <= true;

    wait;
  end process;

  clocking : process
  begin
    while not stop_the_clock loop
      src_clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

  SPIOutput : process (out_spi_sck)
  begin
    if rising_edge(out_spi_sck) then stimulated_output <= stimulated_output(14 downto 0) & stimulated_output(15);
    end if;
    if falling_edge(out_spi_sck) then stimulated_output(0) <= out_spi_mosi;
    end if;
  end process SPIOutput;

  process (out_spi_cs)
  begin
    if rising_edge(out_spi_cs) and reset = '1' then spi_value <= stimulated_output;
    end if;
  end process;
end;