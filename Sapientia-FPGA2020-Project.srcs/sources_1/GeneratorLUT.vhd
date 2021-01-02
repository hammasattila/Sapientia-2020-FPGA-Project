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
        output  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0));
end GeneratorLUT;

architecture Behavioral of GeneratorLUT is
    -- sinLUT az generálva
--constant LUT_SIZE  : NATURAL := 256;
--constant LUT_WIDTH : NATURAL := 12;
type LUT is array (NATURAL range 0 to LUT_SIZE - 1) of STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);
constant sinLUT : LUT := (STD_LOGIC_VECTOR(to_unsigned(2047, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2097, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2147, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2197, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2247, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2297, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2347, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2396, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2446, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2495, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2544, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2592, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2641, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2689, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2736, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2783, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2830, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2876, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2922, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2967, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3011, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3055, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3099, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3142, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3184, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3225, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3266, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3306, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3345, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3384, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3421, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3458, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3529, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3563, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3597, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3629, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3660, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3691, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(3720, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3749, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3776, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3802, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3828, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3852, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3875, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3897, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3938, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3956, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3974, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3990, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4005, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4019, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4032, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4044, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4054, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4063, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4071, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4078, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4084, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4088, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4091, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4093, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4094, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4093, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4091, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4088, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4084, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4078, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4071, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4063, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4054, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4044, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4032, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4019, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4005, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3990, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3974, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3956, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3938, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3897, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3875, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3852, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3828, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3802, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3776, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3749, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3720, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3691, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3660, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3629, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3597, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3563, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3529, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3458, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3421, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3384, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3345, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3306, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3266, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3225, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3184, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3142, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3099, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3055, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3011, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2967, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2922, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2876, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(2830, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2783, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2736, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2689, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2641, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2592, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2544, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2495, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2446, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2396, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2347, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2297, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2247, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2197, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2147, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2097, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2047, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1996, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1946, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1896, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1846, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1796, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1746, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1697, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1647, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1598, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1549, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1501, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1452, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1404, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1357, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1310, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1263, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1171, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1126, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1082, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1038, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(994, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(951, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(909, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(868, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(827, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(787, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(748, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(709, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(672, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(635, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(599, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(564, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(530, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(496, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(464, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(433, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(402, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(373, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(344, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(317, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(291, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(265, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(241, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(218, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(196, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(175, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(155, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(137, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(119, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(103, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(88, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(74, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(61, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(49, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(39, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(30, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(22, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(15, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(5, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(5, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(15, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(22, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(30, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(39, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(49, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(61, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(74, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(88, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(103, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(119, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(137, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(155, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(175, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(196, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(218, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(241, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(265, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(291, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(317, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(344, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(373, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(402, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(433, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(464, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(496, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(530, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(564, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(599, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(635, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(672, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(709, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(748, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(787, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(827, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(868, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(909, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(951, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(994, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1038, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1082, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1126, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1171, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1263, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1310, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1357, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1404, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1452, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1501, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1549, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1598, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1647, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1697, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1746, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1796, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1846, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1896, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1946, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1996, LUT_WIDTH)));

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

-- (DATA_WIDTH - 1 downto LUT_WIDTH => '0') & 
with rState select rDataNext <= sinLUT(to_integer(UNSIGNED(rAddress))) when MEM_PRINT,
--    STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rData)) * to_integer(unsigned(amp)), rDataNext'length)) when SPEED_AMPLITUDE,
    (to_integer(UNSIGNED(amp)) - 1 downto 0 => '0') & rData(DATA_WIDTH - 1 downto to_integer(UNSIGNED(amp))) when SPEED_AMPLITUDE,
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