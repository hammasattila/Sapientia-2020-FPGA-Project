----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
-- 
-- Create Date: 12/02/2020 08:24:20 AM
-- Module Name: generator - Behavioral
-- Project Name:  Waweform generator
--
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity Generator is
    Port (src_clk : in STD_LOGIC;
          src_ce  : in STD_LOGIC;
          reset   : in STD_LOGIC;
          phase   : in STD_LOGIC_VECTOR(4 downto 0);
          output  : out STD_LOGIC_VECTOR(7 downto 0) );
end Generator;

architecture Behavioral of Generator is

    -- sinLUT az generálva
    constant LUT_ADDRESS_WIDTH : NATURAL := 5;
    constant LUT_SIZE  : NATURAL := 2 ** LUT_ADDRESS_WIDTH;
    constant LUT_WIDTH : NATURAL := 8;
    type LUT is array (NATURAL range 0 to 31) of STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);
    constant sinLUT : LUT := (STD_LOGIC_VECTOR(to_unsigned(127, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(152, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(176, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(198, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(233, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(245, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(252, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(255, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(252, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(245, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(233, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(198, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(176, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(152, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(127, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(102, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(78, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(56, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(37, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(21, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(21, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(37, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(56, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(78, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(102, LUT_WIDTH)));    

    constant DATA_WIDTH : NATURAL := 16;
    signal rCounter, rCounterNext : STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    signal rPhase, rPhaseNext     : STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    signal rLUT, rLUTNext         : STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0)         := (others => '0');
    
begin


    
------ COUNTER
    CounterRegister : process(src_clk, src_ce, reset)
    begin
        if  reset = '1' then
            rCounter <= (others => '0');
        elsif src_ce = '1' and rising_edge(src_clk) then
            rCounter <= rCounterNext;
        end if;
    end process CounterRegister;
    
    rPhaseNext <= std_logic_vector(to_unsigned(to_integer(unsigned(rCounter)) + 1, rCounterNext'length));
    
    
------ FÁZIS
    PhaseRegister : process(src_clk, src_ce, reset)
    begin
        if  reset = '1' then
            rPhase <= (others => '0');
        elsif src_ce = '1' and rising_edge(src_clk) then
            rPhase <= rPhaseNext;
        end if;
    end process PhaseRegister;
    
    rPhaseNext <= std_logic_vector(to_unsigned(to_integer(unsigned(rCounter)) + to_integer(unsigned(phase)), rPhaseNext'length));


    
------ LUT                                     
    LUTRegister : process(src_clk, src_ce, reset)
    begin
        if  reset = '1' then
            rLUT <= (others => 'Z');
        elsif src_ce = '1' and rising_edge(src_clk) then
            rLUT <= rLUTNext;
        end if;
    end process LUTRegister;
    
    rLUTNext <= sinLUT(to_integer(UNSIGNED(rPhase)));
    
    output <= rLUT;
     
end Behavioral;
