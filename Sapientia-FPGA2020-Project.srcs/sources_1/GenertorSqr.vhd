----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2021 01:33:47 AM
-- Design Name: 
-- Module Name: GenertorSqr - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity GenertorSqr is
generic (
    CE         : STD_LOGIC := '1';
    RST        : STD_LOGIC := '0';
    DATA_WIDTH : NATURAL   := 12;
    TETA_WIDTH : NATURAL   := 8;
    AMP_WIDTH  : NATURAL   := 4;
    OFF_WIDTH  : NATURAL   := 12
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
        status: out STD_LOGIC;
        dout    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
end GenertorSqr;

architecture Behavioral of GenertorSqr is
    type STATE is (READY, PHASE_AMPLITUDE, PHASE_OFFSET, CALC_PRINT, FINISH);
    type PHASE is (UP, DOWN);

    signal rState, rStateNext     : STATE;
    signal rPhase, rPhaseNext     : PHASE;

    signal rCounter, rCounterNext : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    signal rI, rINext, rN         : STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    signal rData, rDataNext       : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal mult1, mult2           : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

begin

    ------ STATE
    StateRegister : process (src_clk, src_ce, reset)
    begin
        if reset = RST then rState                             <= READY;
        elsif src_ce = CE and rising_edge(src_clk) then rState <= rStateNext;
        end if;
    end process StateRegister;

    StateLogic : process (reset, rState, start, rI, k1, k2)
    begin
        case (rState) is
            when READY =>
                if start = '1' then rStateNext <= PHASE_AMPLITUDE;
                else rStateNext                <= READY;
                end if;
            when PHASE_AMPLITUDE => rStateNext <= PHASE_OFFSET;
            when PHASE_OFFSET    => rStateNext    <= CALC_PRINT;
            when CALC_PRINT      => rStateNext      <= FINISH;
            when FINISH          => rStateNext          <= PHASE_AMPLITUDE;
        end case;
    end process StateLogic;

    ------ PHASE
    PhaseRegister : process (src_clk, src_ce, rPhaseNext)
    begin
        if src_ce = CE and rising_edge(src_clk) then rPhase <= rPhaseNext;
        end if;
    end process PhaseRegister;

    rPhaseNext <= UP when rI < k1 else DOWN;

    ------ Counter
    RegisterCounter : process (src_clk, src_ce)
    begin
        if src_ce = CE and rising_edge(src_clk) then rCounter <= rCounterNext;
        end if;
    end process RegisterCounter;

    rCounterNext <= (others => '0') when rState = READY
        else STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rCounter)) + 1, rCounterNext'length)) when rState = CALC_PRINT and rI < rN - 1
        else (others => '0') when rState = CALC_PRINT and rI = rN - 1
        else rCounter;

    ------ I
    RegisterI : process (src_clk, src_ce)
    begin
        if src_ce = CE and rising_edge(src_clk) then rI <= rINext;
        end if;
    end process RegisterI;

    with rState select rINext <=
        (others => '0') when READY,
        STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rCounter)) + to_integer(unsigned(teta)), rINext'length)) when PHASE_AMPLITUDE,
        rI when others;

    ------ Data
    RegisterData : process (src_clk, src_ce)
    begin
        if src_ce = CE and rising_edge(src_clk) then rData <= rDataNext;
        end if;
    end process RegisterData;

    rN        <= k1 + k2;

    rDataNext <= (others => '0') when rState = READY
        -- else rI * d1 when rState = READY and rPhase = UP
        else (others => '1') when rState = CALC_PRINT and rPhase = UP
        else (others => '0') when rState = CALC_PRINT and rPhase = DOWN
        else (to_integer(UNSIGNED(amp)) - 1 downto 0 => '0') & rData(DATA_WIDTH - 1 downto to_integer(UNSIGNED(amp))) when rState = PHASE_AMPLITUDE
        else STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(rData)) + to_integer(signed(off)), rDataNext'length)) when rState = PHASE_OFFSET
        else rData;

    ------ Out
    RegisterOut : process (src_clk, src_ce, rState)
    begin
        if src_ce = CE and rising_edge(src_clk) and rState = CALC_PRINT then dout <= rData;
        end if;
    end process RegisterOut;
    
    with rState select status <= '1' when FINISH,
    '0' when others;
end Behavioral;