----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2020 04:05:22 PM
-- Design Name: 
-- Module Name: Generator_tb - Behavioral
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


-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Generator_tb is
end;

architecture bench of Generator_tb is
 constant DATA_WIDTH         : NATURAL := 16;
 constant A_WIDTH            : NATURAL := 4;
 constant TETA_WIDTH         : NATURAL := 4;
 constant AMP_WIDTH          : NATURAL := 4;
 constant OFF_WIDTH          : NATURAL := 16;
 constant LUT_ADDRESS_WIDTH  : NATURAL := 5;
 constant LUT_SIZE           : NATURAL := 2 ** LUT_ADDRESS_WIDTH;
 constant LUT_WIDTH          : NATURAL := 8;

  component Generator
      Generic (DATA_WIDTH         : NATURAL := 16;
               A_WIDTH            : NATURAL := 4;
               TETA_WIDTH         : NATURAL := 4;
               AMP_WIDTH          : NATURAL := 4;
               OFF_WIDTH          : NATURAL := 8;
               LUT_ADDRESS_WIDTH  : NATURAL := 5;
               LUT_SIZE           : NATURAL := 2 ** 5;
               LUT_WIDTH          : NATURAL := 8);
      Port (src_clk : in STD_LOGIC;
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

  signal src_clk: STD_LOGIC;
  signal src_ce: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal start: STD_LOGIC;
  signal a: STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0);
  signal teta: STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
  signal amp: STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
  signal off: STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
  signal status: STD_LOGIC;
  signal output: STD_LOGIC_VECTOR(15 downto 0);

  constant clock_period: time := 1 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: Generator generic map ( DATA_WIDTH        => DATA_WIDTH,
                               A_WIDTH           => A_WIDTH,
                               TETA_WIDTH        => TETA_WIDTH,
                               AMP_WIDTH         => AMP_WIDTH,
                               OFF_WIDTH         => OFF_WIDTH,
                               LUT_ADDRESS_WIDTH => LUT_ADDRESS_WIDTH,
                               LUT_SIZE          => LUT_SIZE,
                               LUT_WIDTH         => LUT_WIDTH )
                    port map ( src_clk           => src_clk,
                               src_ce            => src_ce,
                               reset             => reset,
                               start             => start,
                               a                 => a,
                               teta              => teta,
                               amp               => amp,
                               off               => off,
                               status            => status,
                               output            => output );

  stimulus: process
  begin
  
    reset <= '1';
    wait for clock_period / 2;
    reset <= '0';
    a <= std_logic_vector(to_unsigned(1, A_WIDTH));
    teta <= std_logic_vector(to_signed(0, TETA_WIDTH));
    amp <= std_logic_vector(to_unsigned(5, AMP_WIDTH));
    off <= std_logic_vector(to_signed(0, OFF_WIDTH));
    wait for clock_period / 2;
    src_ce <= '1';
    start <= '1';
    wait for clock_period;
    start <= '0';

    wait for 990 * clock_period;
    reset <= '1';
    wait for 5 * clock_period;
    
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
