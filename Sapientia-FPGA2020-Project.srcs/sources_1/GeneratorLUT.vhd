----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
-- 
-- Create Date: 12/02/2020 08:24:20 AM
-- Module Name: Generator - Behavioral
-- Project Name:  Waweform generator
--
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity GeneratorLUT is
    generic (
        CE                : STD_LOGIC := '1';
        RST               : STD_LOGIC := '0';
        DATA_WIDTH        : NATURAL   := 16;
        A_WIDTH           : NATURAL   := 4;
        TETA_WIDTH        : NATURAL   := 4;
        AMP_WIDTH         : NATURAL   := 4;
        OFF_WIDTH         : NATURAL   := 8;
        LUT_ADDRESS_WIDTH : NATURAL   := 5;
        LUT_SIZE          : NATURAL   := 2 ** 5;
        LUT_WIDTH         : NATURAL   := 8);
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
end GeneratorLUT;

architecture Behavioral of GeneratorLUT is
    -- sinLUT az generálva
    type LUT is array (NATURAL range 0 to LUT_SIZE - 1) of STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);
    constant sinLUT : LUT := (STD_LOGIC_VECTOR(to_unsigned(127, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(152, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(176, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(198, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(233, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(245, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(252, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(255, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(252, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(245, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(233, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(198, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(176, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(152, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(127, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(102, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(78, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(56, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(37, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(21, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(21, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(37, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(56, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(78, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(102, LUT_WIDTH)));

    type STATE is (READY, SPEED_AMPLITUDE, PHASE_OFFSET, MEM_PRINT, FINISH);
    signal rState, rStateNext     : STATE                                            := READY;
    signal rCounter, rCounterNext : STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    signal rAddress, rAddressNext : STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    signal rData, rDataNext       : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)        := (others => '0');
    signal rOut, rOutNext         : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)        := (others => '0');

begin
    ------ STATE
    StateRegister : process (src_clk, src_ce, reset)
    begin
        if reset = RST then rState                             <= READY;
        elsif src_ce = CE and rising_edge(src_clk) then rState <= rStateNext;
        end if;
    end process StateRegister;

    StateLogic : process (rState, start)
    begin
        case (rState) is
        when READY => if start = '1' then rStateNext <= SPEED_AMPLITUDE;
            else rStateNext                              <= READY;
            end if;
        when SPEED_AMPLITUDE => rStateNext <= PHASE_OFFSET;
        when PHASE_OFFSET    => rStateNext    <= MEM_PRINT;
        when MEM_PRINT       => rStateNext       <= FINISH;
        when FINISH          => rStateNext          <= SPEED_AMPLITUDE;
        end case;
    end process StateLogic;
------ COUNTER
CounterRegister : process (src_clk, src_ce, reset)
begin
    if reset = RST then rCounter                             <= (others => '0');
    elsif src_ce = CE and rising_edge(src_clk) then rCounter <= rCounterNext;
    end if;
end process CounterRegister;

with rState select rCounterNext <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rCounter)) + 1, rCounterNext'length)) when MEM_PRINT,
    rCounter when others;
------ CÍM
AddressRegister : process (src_clk, src_ce, reset)
begin
    if reset = RST then rAddress                             <= (others => '0');
    elsif src_ce = CE and rising_edge(src_clk) then rAddress <= rAddressNext;
    end if;
end process AddressRegister;

with rState select rAddressNext <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rCounter)) * to_integer(unsigned(a)), rAddressNext'length)) when SPEED_AMPLITUDE,
    STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rAddress)) + to_integer(signed(teta)), rAddressNext'length)) when PHASE_OFFSET,
    rAddress when others;

------ ADAT                                     
DataRegister : process (src_clk, src_ce, reset)
begin
    if reset = RST then rData                             <= (others => '0');
    elsif src_ce = CE and rising_edge(src_clk) then rData <= rDataNext;
    end if;
end process DataRegister;

with rState select rDataNext <= (DATA_WIDTH - 1 downto LUT_WIDTH => '0') & sinLUT(to_integer(UNSIGNED(rAddress))) when MEM_PRINT,
    STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rData)) * to_integer(unsigned(amp)), rDataNext'length)) when SPEED_AMPLITUDE,
    STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rData)) + to_integer(signed(off)), rDataNext'length)) when PHASE_OFFSET,
    rData when others;

OutRegister : process (src_clk, src_ce, reset)
begin
    if reset = RST then rOut                             <= (others => 'Z');
    elsif src_ce = CE and rising_edge(src_clk) then rOut <= rOutNext;
    end if;
end process OutRegister;

with rState select rOutNext <= rData when MEM_PRINT,
    rOut when others;

with rState select status <= '1' when FINISH,
    '0' when others;

output <= rOut;
end Behavioral;