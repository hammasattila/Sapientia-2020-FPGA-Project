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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ClockDivider is
    generic (
        CE  : STD_LOGIC := '1';
        RST : STD_LOGIC := '0';
        div : INTEGER   := 2);
    port (
        src_clk : in STD_LOGIC;
        src_ce  : in STD_LOGIC;
        reset   : in STD_LOGIC;
        div_clk : out STD_LOGIC := '0');
end ClockDivider;

architecture Behavioral of ClockDivider is
    signal clkNext : STD_LOGIC := '0';
begin
    process (src_clk, src_ce, reset)
        variable count : INTEGER := 0;

    begin
        if reset = RST then count := 0;
            clkNext <= '0';
        elsif src_ce = CE and rising_edge(src_clk) then count := count + 1;
            if div = count then count                             := 0;
                clkNext <= not clkNext;
            end if;
        end if;
    end process;

    div_clk <= clkNext;

end Behavioral;