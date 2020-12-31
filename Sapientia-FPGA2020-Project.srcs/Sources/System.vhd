----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 12/05/2020 12:48:38 PM
-- Module Name: System - Behavioral
-- Project Name:  Waweform generator
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity System is
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
end System;

architecture Behavioral of System is

  constant LUT_SIZE : NATURAL := 2 ** LUT_ADDRESS_WIDTH;

  component ClockDivider
    generic (
    
    CE    : STD_LOGIC := '1';
    RST    : STD_LOGIC := '0';
      div : INTEGER := 2);
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      reset   : in STD_LOGIC;
      div_clk : out STD_LOGIC);
  end component;

  component GeneratorLUT
    generic (
      CE                : STD_LOGIC := '1';
      RST               : STD_LOGIC := '0';
      DATA_WIDTH        : NATURAL := 16;
      A_WIDTH           : NATURAL := 4;
      TETA_WIDTH        : NATURAL := 4;
      AMP_WIDTH         : NATURAL := 4;
      OFF_WIDTH         : NATURAL := 8;
      LUT_ADDRESS_WIDTH : NATURAL := 5;
      LUT_SIZE          : NATURAL := 2 ** 5;
      LUT_WIDTH         : NATURAL := 8);
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      reset   : in STD_LOGIC;
      start   : in STD_LOGIC;
      a       : in STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0);
      teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
      amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
      off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
      status  : out STD_LOGIC;
      output  : out STD_LOGIC_VECTOR(15 downto 0));
  end component;

  component Spi
    generic (  
      CE                : STD_LOGIC := '1';
      RST               : STD_LOGIC := '0'
    );
    port (
      src_clk  : in STD_LOGIC;
      src_ce   : in STD_LOGIC;
      reset    : in STD_LOGIC;
      start    : in STD_LOGIC;
      data     : in STD_LOGIC_VECTOR (15 downto 0);
      SCK      : out STD_LOGIC;
      MISO     : in STD_LOGIC;
      MOSI     : out STD_LOGIC;
      CS       : out STD_LOGIC;
      status   : out STD_LOGIC;
      response : out STD_LOGIC_VECTOR(15 downto 0));
  end component;

  signal a          : STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0)    := STD_LOGIC_VECTOR(to_unsigned(1, A_WIDTH));
  signal teta       : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed(-5, TETA_WIDTH));
  signal amp        : STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0)  := STD_LOGIC_VECTOR(to_unsigned(5, AMP_WIDTH));
  signal off        : STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0)  := STD_LOGIC_VECTOR(to_signed(0, OFF_WIDTH));

  signal gen_clk    : STD_LOGIC;
  signal gen_status : STD_LOGIC;
  signal gen_data   : STD_LOGIC_VECTOR(15 downto 0);
begin
  clkd : ClockDivider
  generic map(div => 32)
  port map(
    src_clk => src_clk,
    src_ce  => src_ce,
    reset   => reset,
    div_clk => gen_clk);

  genc : GeneratorLUT
  generic map(
    DATA_WIDTH        => DATA_WIDTH,
    A_WIDTH           => A_WIDTH,
    TETA_WIDTH        => TETA_WIDTH,
    AMP_WIDTH         => AMP_WIDTH,
    OFF_WIDTH         => OFF_WIDTH,
    LUT_ADDRESS_WIDTH => LUT_ADDRESS_WIDTH,
    LUT_SIZE          => LUT_SIZE,
    LUT_WIDTH         => LUT_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    reset   => reset,
    start   => start,
    a       => a,
    teta    => teta,
    amp     => amp,
    off     => off,
    status  => gen_status,
    output  => gen_data);

  spic : Spi
  port map(
    src_clk  => src_clk,
    src_ce   => src_ce,
    reset    => reset,
    start    => gen_status,
    data     => gen_data,
    SCK      => out_spi_sck,
    MISO     => out_spi_miso,
    MOSI     => out_spi_mosi,
    CS       => out_spi_cs,
    status   => open,
    response => open);
end Behavioral;