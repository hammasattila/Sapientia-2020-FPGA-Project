----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 12/04/2020 10:21:00 PM
-- Module Name: ClockDivider - Behavioral
-- Project Name:  Waweform generator
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ClockDivider_tb is
end;

architecture bench of ClockDivider_tb is

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

  signal src_clk : STD_LOGIC;
  signal src_ce  : STD_LOGIC;
  signal reset   : STD_LOGIC;
  signal div_clk : STD_LOGIC;

  constant clock_period : TIME := 10 ns;
  signal stop_the_clock : BOOLEAN;

begin

  -- Insert values for generic parameters !!
  uut : ClockDivider generic map(div => 2)
  port map(
    src_clk => src_clk,
    src_ce  => src_ce,
    reset   => reset,
    div_clk => div_clk);

  stimulus : process
  begin

    src_ce <= '1';
    reset  <= '0';
    wait for clock_period / 2;
    reset <= '1';
    wait for 56 * clock_period;
    src_ce <= '0';
    wait for 16 * clock_period;
    reset <= '0';
    wait for 16 * clock_period;

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

end;