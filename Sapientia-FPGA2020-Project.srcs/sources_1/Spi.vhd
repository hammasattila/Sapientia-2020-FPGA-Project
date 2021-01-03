----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 11/04/2020 03:39:58 PM
-- Module Name: spi - Behavioral
-- Project Name:  Waweform generator
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.all;

entity Spi is
    generic (
        CE  : STD_LOGIC := '1';
        RST : STD_LOGIC := '0');
    port (
        src_clk  : in STD_LOGIC;
        src_ce   : in STD_LOGIC;
        reset    : in STD_LOGIC;
        start    : in STD_LOGIC;
        data     : in STD_LOGIC_VECTOR (15 downto 0);

        SCK      : out STD_LOGIC;
        MISO     : in STD_LOGIC;
        MOSI     : out STD_LOGIC;
        CS       : out STD_LOGIC;

        status   : out STD_LOGIC;
        response : out STD_LOGIC_VECTOR(15 downto 0));
end Spi;

architecture Behavioral of Spi is
    constant SPI_CLK_DIV    : NATURAL := 10;
    constant SPI_CS_DELAY   : NATURAL := 2;
    constant SPI_DATA_WIDTH : NATURAL := 16;
    constant COUNTER_WIDTH  : NATURAL := 8;

    type STATE is (READY, INIT_A, CS_L, INIT_B, CLK_L, INIT_C, CLK_H, INIT_D, CS_H, FINISHED);

    signal stateCurrent, stateNext : STATE                                         := READY;

    signal rI, rINext, rK, rKNext  : STD_LOGIC_VECTOR(COUNTER_WIDTH - 1 downto 0)  := (others => '0');
    signal rData, rDataNext        : STD_LOGIC_VECTOR(SPI_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal rRes, rResNext          : STD_LOGIC_VECTOR(SPI_DATA_WIDTH - 1 downto 0) := (others => '0');
begin

    StateLogic : process (stateCurrent, start, Rk)
    begin
        case (stateCurrent) is
            when READY =>
                if start = '1' then stateNext <= INIT_A;
                else stateNext                <= READY;
                end if;
            when INIT_A =>
                stateNext <= CS_L;
            when CS_L =>
                if 0 < rK then stateNext <= CS_L;
                else stateNext           <= INIT_B;
                end if;
            when INIT_B =>
                stateNext <= CLK_L;
            when CLK_L =>
                if 0 < rK then stateNext <= CLK_L;
                else stateNext           <= INIT_C;
                end if;
            when INIT_C =>
                stateNext <= CLK_H;
            when CLK_H =>
                if 0 < rK then stateNext <= CLK_H;
                else stateNext           <= INIT_D;
                end if;
            when INIT_D =>
                if 0 < rI then stateNext <= CLK_L;
                else stateNext           <= CS_H;
                end if;
            when CS_H =>
                if 0 < rK then stateNext <= CS_H;
                else stateNext           <= FINISHED;
                end if;
            when FINISHED =>
                stateNext <= READY;
        end case;
    end process StateLogic;

    StateRegister : process (src_clk, src_ce, reset)
    begin
        if reset = RST then stateCurrent                             <= READY;
        elsif src_ce = CE and rising_edge(src_clk) then stateCurrent <= stateNext;
        end if;
    end process StateRegister;

    IRegister : process (src_clk, src_ce, reset)
    begin
        if src_ce = CE and rising_edge(src_clk) then rI <= rINext;
        end if;
    end process IRegister;

    with stateCurrent select rINext <= STD_LOGIC_VECTOR(to_unsigned(SPI_DATA_WIDTH - 1, COUNTER_WIDTH)) when INIT_A,
        rI - 1 when INIT_D,
        rI when others;

    KRegister : process (src_clk, src_ce, reset)
    begin
        if src_ce = CE and rising_edge(src_clk) then rK <= rKNext;
        end if;
    end process KRegister;

    with stateCurrent select rKNext <= STD_LOGIC_VECTOR(to_unsigned(SPI_CS_DELAY - 2, COUNTER_WIDTH)) when INIT_A,
        STD_LOGIC_VECTOR(to_unsigned(SPI_CLK_DIV/2 - 2, COUNTER_WIDTH)) when INIT_B | INIT_C | INIT_D,
        rK - 1 when CS_L | CLK_L | CLK_H | CS_H,
        rK when others;

    DataRegister : process (src_clk, src_ce, reset)
    begin
        if reset = RST then rData                             <= (others => '0');
        elsif src_ce = CE and rising_edge(src_clk) then rData <= rDataNext;
        end if;
    end process DataRegister;

    with stateCurrent select rDataNext <= data when INIT_A,
        rData(SPI_DATA_WIDTH - 2 downto 0) & rData(SPI_DATA_WIDTH - 1) when INIT_C,
        rData when others;

    ResponseRegister : process (src_clk, src_ce, reset)
    begin
        if reset = RST then rRes                             <= (others => '0');
        elsif src_ce = CE and rising_edge(src_clk) then rRes <= rResNext;
        end if;
    end process ResponseRegister;

    with stateCurrent select rResNext <= (others => '0') when INIT_A,
        rResNext(SPI_DATA_WIDTH - 2 downto 0) & MISO when CLK_L,
        rRes(SPI_DATA_WIDTH - 2 downto 0) & rRes(SPI_DATA_WIDTH - 1) when INIT_D,
        rRes when others;

    with stateCurrent select status <= '1' when FINISHED,
        '0' when others;

    process (stateCurrent)
    begin
        if stateCurrent = FINISHED then response <= rRes;
        end if;
    end process;

    with stateCurrent select SCK <= '0' when CLK_L | INIT_C,
        '1' when others;

    with stateCurrent select CS <= '0' when INIT_A | CS_L | INIT_B | CLK_L | INIT_C | CLK_H | INIT_D,
        '1' when others;

    with stateCurrent select MOSI <= '0' when READY,
        rData(0) when others;

end Behavioral;