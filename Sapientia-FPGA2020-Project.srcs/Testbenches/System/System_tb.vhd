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
      DATA_WIDTH        : NATURAL := 16;
      A_WIDTH           : NATURAL := 4;
      TETA_WIDTH        : NATURAL := 4;
      AMP_WIDTH         : NATURAL := 4;
      OFF_WIDTH         : NATURAL := 16;
      LUT_ADDRESS_WIDTH : NATURAL := 5;
      LUT_WIDTH         : NATURAL := 8
    );
    port (
      src_clk      : in STD_LOGIC;
      src_ce       : in STD_LOGIC;
      reset        : in STD_LOGIC;
      start        : in STD_LOGIC;
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
  signal out_spi_sck       : STD_LOGIC;
  signal out_spi_miso      : STD_LOGIC;
  signal out_spi_mosi      : STD_LOGIC;
  signal out_spi_cs        : STD_LOGIC;

  signal stimulated_output : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  signal spi_value         : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  constant clock_period    : TIME                           := 10 ps;
  signal stop_the_clock    : BOOLEAN;

begin

  -- Insert values for generic parameters !!
  uut : System generic map(
    DATA_WIDTH        => 16,
    A_WIDTH           => 4,
    TETA_WIDTH        => 4,
    AMP_WIDTH         => 4,
    OFF_WIDTH         => 16,
    LUT_ADDRESS_WIDTH => 5,
    LUT_WIDTH         => 8)
  port map(
    src_clk      => src_clk,
    src_ce       => src_ce,
    reset        => reset,
    start        => start,
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

    wait for clock_period / 2;
    reset <= '1';

    wait for clock_period / 2;
    -- wait for 320 * clock_period;
    -- start <= '0';

    -- wait for 9800 * clock_period;
    -- wait for 10000 * clock_period;
    wait;
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
    if rising_edge(out_spi_cs) then spi_value <= stimulated_output;
    end if;
  end process;
end;