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
Port ( src_clk : in STD_LOGIC;
           src_en : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           k1 : in STD_LOGIC_VECTOR (15 downto 0);
           k2 : in STD_LOGIC_VECTOR (15 downto 0);
           d : in STD_LOGIC_VECTOR (15 downto 0);
           phase : in STD_LOGIC_VECTOR (15 downto 0);
           Dout : out STD_LOGIC_VECTOR (15 downto 0));
end GenertorSqr;

architecture Behavioral of GenertorSqr is
type allapot_tipus is (RDY, UP, DOWN);

signal akt_all, kov_all: allapot_tipus;

signal I, I_next: std_logic_vector(15 downto 0);
signal outR: std_logic_vector(15 downto 0);

begin

I_REG: process(src_clk)
begin
 if src_clk'event and src_clk = '1' then
    I <= I_next;
 end if;
end process I_REG;

out_REG: process(src_clk)
begin
 if src_clk'event and src_clk = '1' then
    Dout <= outR;
 end if;
end process out_REG;

all_REG: process(src_clk)
begin
 if src_clk'event and src_clk = '1' then
    akt_all <= kov_all;
 end if;
end process all_REG;

with akt_all select
    I_next <= (others => '0') when RDY,
               I+1 when UP,
               I+1 when DOWN;

with akt_all select
    outR <= (others => '0') when RDY,
            d when UP,
            x"0000" when DOWN;


next_state:process(reset,akt_all, start, I,k1,k2)
begin
    case(akt_all) is
        when RDY =>
            if start = '1' then
                kov_all <= UP;
            else
                kov_all <= RDY;
            end if;
        when UP =>
            if I<k1  then
                kov_all <= UP;
            else
                kov_all <= DOWN;
            end if;
        when DOWN =>
            if I = k1+k2 then
                kov_all <= RDY;
            else
                kov_all <= DOWN;
            end if;
    end case;
end process next_state;
end Behavioral;
