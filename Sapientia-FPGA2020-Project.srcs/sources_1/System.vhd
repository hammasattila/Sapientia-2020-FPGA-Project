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
    CE                : STD_LOGIC := '1';
    RST               : STD_LOGIC := '0';
    DATA_WIDTH        : NATURAL   := 12;
    A_WIDTH           : NATURAL   := 4;
    TETA_WIDTH        : NATURAL   := 8;
    AMP_WIDTH         : NATURAL   := 4;
    OFF_WIDTH         : NATURAL   := 12;
    LUT_ADDRESS_WIDTH : NATURAL   := 8;
    LUT_WIDTH         : NATURAL   := 12);
  port (
    src_clk      : in STD_LOGIC;
    src_ce       : in STD_LOGIC;
    reset        : in STD_LOGIC;
    start        : in STD_LOGIC;
    
    s          : in STD_LOGIC_VECTOR(1 downto 0);
    teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    
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

      CE  : STD_LOGIC := '1';
      RST : STD_LOGIC := '0';
      div : INTEGER   := 2);
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      reset   : in STD_LOGIC;
      div_clk : out STD_LOGIC);
  end component;
  component GeneratorLUT
    generic (
      CE                : STD_LOGIC;
      RST               : STD_LOGIC;
      DATA_WIDTH        : NATURAL;
      A_WIDTH           : NATURAL;
      TETA_WIDTH        : NATURAL;
      AMP_WIDTH         : NATURAL;
      OFF_WIDTH         : NATURAL;
      LUT_ADDRESS_WIDTH : NATURAL;
      LUT_SIZE          : NATURAL;
      LUT_WIDTH         : NATURAL);
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
      output  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0));
  end component;
  component GeneratorTri is
    generic (
      CE         : STD_LOGIC;
      RST        : STD_LOGIC;
      DATA_WIDTH : NATURAL;
      TETA_WIDTH : NATURAL;
      AMP_WIDTH  : NATURAL;
      OFF_WIDTH  : NATURAL
    );
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      start   : in STD_LOGIC;
      reset   : in STD_LOGIC;
      k1      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      k2      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      d1      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      d2      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
      amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
      off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
      status  : out STD_LOGIC;
      dout    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
  end component;
  component GenertorSqr
    generic (
      CE         : STD_LOGIC;
      RST        : STD_LOGIC;
      DATA_WIDTH : NATURAL;
      TETA_WIDTH : NATURAL;
      AMP_WIDTH  : NATURAL;
      OFF_WIDTH  : NATURAL
    );
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      start   : in STD_LOGIC;
      reset   : in STD_LOGIC;
      k1      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      k2      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
      amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
      off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
      status  : out STD_LOGIC;
      dout    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
  end component;
  component Spi
    generic (
      CE  : STD_LOGIC := '1';
      RST : STD_LOGIC := '0'
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
  signal k0         : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed(32, TETA_WIDTH));
  signal k1         : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed(32, TETA_WIDTH));
  signal d0         : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed(127, TETA_WIDTH));
  signal d1         : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed(127, TETA_WIDTH));
  signal amp        : STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0)  := STD_LOGIC_VECTOR(to_unsigned(3, AMP_WIDTH));
  signal amp_big    : STD_LOGIC_VECTOR(11 downto 0);
  signal off        : STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0)  := STD_LOGIC_VECTOR(to_signed(0, OFF_WIDTH));

  signal gen_clk    : STD_LOGIC;
  signal gen_status : STD_LOGIC;
  signal lut_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal tri_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal sqr_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal gen_data   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
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
    CE                => CE,
    RST               => RST,
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
    output  => lut_data);

  gent : GeneratorTri
  generic map(
    CE         => CE,
    RST        => RST,
    DATA_WIDTH => DATA_WIDTH,
    TETA_WIDTH => TETA_WIDTH,
    AMP_WIDTH  => AMP_WIDTH,
    OFF_WIDTH  => OFF_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    start   => start,
    reset   => reset,
    k1      => k0,
    k2      => k1,
    d1      => d0,
    d2      => d1,
    teta    => teta,
    amp     => amp,
    off     => off,
    status  => open,
    dout    => tri_data);

  gens : GenertorSqr
  generic map(
    CE         => CE,
    RST        => RST,
    DATA_WIDTH => DATA_WIDTH,
    TETA_WIDTH => TETA_WIDTH,
    AMP_WIDTH  => AMP_WIDTH,
    OFF_WIDTH  => OFF_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    start   => start,
    reset   => reset,
    k1      => k0,
    k2      => k1,
    teta    => teta,
    amp     => amp,
    off     => off,
    status  => open,
    dout    => sqr_data);

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
    
    amp_big <= amp & d0;

  with s select gen_data(11 downto 0) <=
    tri_data when "10",
    sqr_data when "11",
    lut_data when others;

end Behavioral;