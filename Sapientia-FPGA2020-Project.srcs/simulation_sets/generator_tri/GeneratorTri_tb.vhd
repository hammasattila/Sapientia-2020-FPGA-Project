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
        Port ( src_clk : in STD_LOGIC;
             src_en : in STD_LOGIC;
             start : in STD_LOGIC;
             reset : in STD_LOGIC;
             k1 : in STD_LOGIC_VECTOR (15 downto 0);
             k2 : in STD_LOGIC_VECTOR (15 downto 0);
             d1 : in STD_LOGIC_VECTOR (15 downto 0);
             d2 : in STD_LOGIC_VECTOR (15 downto 0);
             phase : in STD_LOGIC_VECTOR (15 downto 0);
             Dout : out STD_LOGIC_VECTOR (15 downto 0));
  end component;

  signal src_clk: STD_LOGIC;
  signal src_en: STD_LOGIC;
  signal start: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal k1: STD_LOGIC_VECTOR (15 downto 0);
  signal k2: STD_LOGIC_VECTOR (15 downto 0);
  signal d1: STD_LOGIC_VECTOR (15 downto 0);
  signal d2: STD_LOGIC_VECTOR (15 downto 0);
  signal phase: STD_LOGIC_VECTOR (15 downto 0);
  signal Dout: STD_LOGIC_VECTOR (15 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: GeneratorTri port map ( src_clk => src_clk,
                               src_en  => src_en,
                               start   => start,
                               reset   => reset,
                               k1      => k1,
                               k2      => k2,
                               d1      => d1,
                               d2      => d2,
                               phase   => phase,
                               Dout    => Dout );

  stimulus: process
  begin
  
                          reset<='1';
                        start<='0';
                        wait for 100 ns;
                        reset<='0';
                        start<='0';
                                                
                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        k2<= STD_LOGIC_VECTOR(to_unsigned(123,16));
                        d1<= STD_LOGIC_VECTOR(to_unsigned(3,16));
                        d2<= STD_LOGIC_VECTOR(to_unsigned(1,16));
                        start <='1';
                        wait for 1 us;
                        start <='0';
                        wait for 2 us;
                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        k2<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        d1<= STD_LOGIC_VECTOR(to_unsigned(1,16));
                        d2<= STD_LOGIC_VECTOR(to_unsigned(1,16));
                        start <='1';
                        wait for 1 us;
                        start <='0';
                        wait for 1 us;
                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        k2<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        d1<= STD_LOGIC_VECTOR(to_unsigned(3,16));
                        d2<= STD_LOGIC_VECTOR(to_unsigned(3,16));
                        start <='1';
                        wait for 1 us;
                        start <='0';
                        wait for 1 us;
                        k1<= STD_LOGIC_VECTOR(to_unsigned(41,16));
                        k2<= STD_LOGIC_VECTOR(to_unsigned(1,16));
                        d1<= STD_LOGIC_VECTOR(to_unsigned(3,16));
                        d2<= STD_LOGIC_VECTOR(to_unsigned(123,16));
                        start <='1';

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
