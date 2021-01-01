----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 12/30/2020 09:15:17 PM
-- Module Name: GeneratorTri - Behavioral
-- Project Name:  Waweform generator
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity GeneratorTri is
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
end GeneratorTri;

architecture Behavioral of GeneratorTri is
    type allapot_tipus is (RDY, UP, DOWN);

    signal akt_all, kov_all : allapot_tipus;

    signal I, I_next        : STD_LOGIC_VECTOR(15 downto 0);
    signal outR             : STD_LOGIC_VECTOR(15 downto 0);
    signal mult1, mult2     : STD_LOGIC_VECTOR(31 downto 0);

begin

    I_REG : process (src_clk)
    begin
        if rising_edge(src_clk) then I <= I_next;
        end if;
    end process I_REG;

    out_REG : process (src_clk)
    begin
        if rising_edge(src_clk) then Dout <= outR;
        end if;
    end process out_REG;

    all_REG : process (src_clk)
    begin
        if rising_edge(src_clk) then akt_all <= kov_all;
        end if;
    end process all_REG;

    with akt_all select
        I_next <= (others => '0') when RDY,
        STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(I)) + 1, I_next'length)) when others;

    mult1 <= I * d1;
    mult2 <= (k2 - I + k1) * d2;

    with akt_all select
        outR <= (others => '0') when RDY,
        mult1(15 downto 0) when UP,
        mult2(15 downto 0) when DOWN;
    next_state : process (reset, akt_all, start, I, k1, k2)
    begin
        case(akt_all) is
            when RDY =>
            if start = '1' then kov_all <= UP;
            else kov_all                <= RDY;
            end if;
            when UP =>
            if I < k1 then kov_all <= UP;
            else kov_all           <= DOWN;
            end if;
            when DOWN =>
            if I = k1 + k2 then kov_all <= RDY;
            else kov_all                <= DOWN;
            end if;
        end case;
    end process next_state;
end Behavioral;