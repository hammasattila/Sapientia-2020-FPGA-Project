----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2021 12:53:35 AM
-- Design Name: 
-- Module Name: GeneratorTri_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity GeneratorTri_tb is
end;

architecture bench of GeneratorTri_tb is

  component GeneratorTri
      generic (
          CE         : STD_LOGIC := '1';
          RST        : STD_LOGIC := '0';
          DATA_WIDTH : NATURAL   := 16;
          TETA_WIDTH : NATURAL   := 8;
          AMP_WIDTH  : NATURAL   := 4;
          OFF_WIDTH  : NATURAL   := 16
      );
      port (
          src_clk : in STD_LOGIC;
          src_ce  : in STD_LOGIC;
          start   : in STD_LOGIC;
          reset   : in STD_LOGIC;
          k1      : in STD_LOGIC_VECTOR (7 downto 0);
          k2      : in STD_LOGIC_VECTOR (7 downto 0);
          d1      : in STD_LOGIC_VECTOR (7 downto 0);
          d2      : in STD_LOGIC_VECTOR (7 downto 0);
          teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
          amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
          off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
          status: out STD_LOGIC;
          dout    : out STD_LOGIC_VECTOR (15 downto 0));
  end component;

  signal src_clk: STD_LOGIC;
  signal src_ce: STD_LOGIC;
  signal start: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal k1: STD_LOGIC_VECTOR (7 downto 0);
  signal k2: STD_LOGIC_VECTOR (7 downto 0);
  signal d1: STD_LOGIC_VECTOR (7 downto 0);
  signal d2: STD_LOGIC_VECTOR (7 downto 0);
  signal teta: STD_LOGIC_VECTOR(8 - 1 downto 0);
  signal amp: STD_LOGIC_VECTOR(4 - 1 downto 0);
  signal off: STD_LOGIC_VECTOR(16 - 1 downto 0);
          signal status: STD_LOGIC;
  signal dout: STD_LOGIC_VECTOR (15 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

    uut: GeneratorTri  port map ( src_clk    => src_clk,
                                  src_ce     => src_ce,
                                  start      => start,
                                  reset      => reset,
                                  k1         => k1,
                                  k2         => k2,
                                  d1         => d1,
                                  d2         => d2,
                                  teta       => teta,
                                  amp        => amp,
                                  off        => off,
                                  status     => status,
                                  dout       => dout );

  stimulus: process
  begin
  
                        reset<='0';
                        start<='0';
                        src_ce <='1';
                        teta <= STD_LOGIC_VECTOR(to_unsigned(0,8));
                        amp <= STD_LOGIC_VECTOR(to_unsigned(1,4));
                        off <= STD_LOGIC_VECTOR(to_unsigned(0,16));
                        wait for 100 ns;
                        reset<='1';
                        start<='0';
                                                
                        k1<= STD_LOGIC_VECTOR(to_unsigned(64,8));
                        k2<= STD_LOGIC_VECTOR(to_unsigned(0,8));
                        d1<= STD_LOGIC_VECTOR(to_unsigned(1,8));
                        d2<= STD_LOGIC_VECTOR(to_unsigned(1,8));
                        start <='1';
                        wait for 1 us;
--                        start <='0';
--                        wait for 2 us;
--                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,8));
--                        k2<= STD_LOGIC_VECTOR(to_unsigned(41,8));
--                        d1<= STD_LOGIC_VECTOR(to_unsigned(1,8));
--                        d2<= STD_LOGIC_VECTOR(to_unsigned(1,8));
--                        start <='1';
--                        wait for 1 us;
--                        start <='0';
--                        wait for 1 us;
--                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,8));
--                        k2<= STD_LOGIC_VECTOR(to_unsigned(41,8));
--                        d1<= STD_LOGIC_VECTOR(to_unsigned(3,8));
--                        d2<= STD_LOGIC_VECTOR(to_unsigned(3,8));
--                        start <='1';
--                        wait for 1 us;
--                        start <='0';
--                        wait for 1 us;
--                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,8));
--                        k2<= STD_LOGIC_VECTOR(to_unsigned(1,8));
--                        d1<= STD_LOGIC_VECTOR(to_unsigned(3,8));
--                        d2<= STD_LOGIC_VECTOR(to_unsigned(123,8));
--                        start <='1';
wait;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      src_clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
