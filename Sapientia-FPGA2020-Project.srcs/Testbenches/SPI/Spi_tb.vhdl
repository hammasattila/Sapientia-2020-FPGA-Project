-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Spi_tb is
end;

architecture bench of Spi_tb is

  component Spi
      Port ( src_clk : in STD_LOGIC;
             src_ce  : in STD_LOGIC; 
             reset   : in STD_LOGIC;
             start   : in STD_LOGIC;
             data    : in STD_LOGIC_VECTOR (15 downto 0);
             SCK     : out STD_LOGIC;
             MISO    : in STD_LOGIC;
             MOSI    : out STD_LOGIC;
             CS      : out STD_LOGIC;
             status  : out STD_LOGIC;
             response: out STD_LOGIC_VECTOR(15 downto 0) );
  end component;

  signal src_clk: STD_LOGIC;
  signal src_ce: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal start: STD_LOGIC;
  signal data: STD_LOGIC_VECTOR (15 downto 0);
  signal SCK: STD_LOGIC;
  signal MISO: STD_LOGIC;
  signal MOSI: STD_LOGIC;
  signal CS: STD_LOGIC;
  signal status: STD_LOGIC;
  signal response: STD_LOGIC_VECTOR(15 downto 0) ;

  constant clock_period: time := 4 ns;
  signal stop_the_clock: boolean;
  signal stimulated_output  : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  signal stimulated_response: STD_LOGIC_VECTOR (15 downto 0) := x"07FF";

begin

  uut: Spi port map ( src_clk  => src_clk,
                      src_ce   => src_ce,
                      reset    => reset,
                      start    => start,
                      data     => data,
                      SCK      => SCK,
                      MISO     => MISO,
                      MOSI     => MOSI,
                      CS       => CS,
                      status   => status,
                      response => response );

  MISO <= stimulated_response(0);
  
  
  Stimulus: process
  begin
    -- Put initialisation code here
    src_ce <= '0';
    reset <= '1';
    start <= '0';
    data <= (others => '0');
    wait for clock_period;
    
    reset <= '0';
    wait for clock_period;
    
    src_ce <= '1';
    data <= STD_LOGIC_VECTOR(to_unsigned(54321, 16));
    wait for clock_period;
    
    start <= '1';
    wait for clock_period;
    
    start <= '0';
    wait for (16 * 10 * 2 + 30)*clock_period;
    
    
    

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  SPIResponse: process(SCK)
  begin
    if rising_edge(SCK) then
        stimulated_output <= stimulated_output(14 downto 0) & stimulated_output(15);
        stimulated_response <= stimulated_response(14 downto 0) & stimulated_response(15);
    end if;
    if falling_edge(SCK) then
        stimulated_output(0) <= MOSI;
    end if;
    
  end process SPIResponse;


  Clocking: process
  begin
    while not stop_the_clock loop
      src_clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;