----------------------------------------------------------------------------------
-- Company: Sapientia Hungarian University of Transylvania - Faculty of Technical and Human Sciences
-- Engineer: Attila Hammas
--
-- Create Date: 12/05/2020 12:48:38 PM
-- Module Name: System - Behavioral
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

entity System is
  generic (
    CE                : STD_LOGIC := '1';
    RST               : STD_LOGIC := '0';
    DATA_WIDTH        : NATURAL   := 12;
    A_WIDTH           : NATURAL   := 4;
    TETA_WIDTH        : NATURAL   := 8;
    AMP_WIDTH         : NATURAL   := 4;
    OFF_WIDTH         : NATURAL   := 12;
    LUT_ADDRESS_WIDTH : NATURAL   := 8);
  port (
    src_clk      : in STD_LOGIC;
    src_ce       : in STD_LOGIC;
    reset        : in STD_LOGIC;
    start        : in STD_LOGIC;
    
    a          : STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0);
    s          : in STD_LOGIC_VECTOR(1 downto 0);
    teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    amp        : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0) ;
    k0         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    k1         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    d0         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    d1         : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
    off        : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0) ;
    
    out_spi_sck  : out STD_LOGIC;
    out_spi_miso : in STD_LOGIC;
    out_spi_mosi : out STD_LOGIC;
    out_spi_cs   : out STD_LOGIC
  );
end System;

architecture Behavioral of System is

-- sinLUT az generálva
constant LUT_SIZE  : NATURAL := 256;
constant LUT_WIDTH : NATURAL := 12;
type LUT is array (NATURAL range 0 to LUT_SIZE - 1) of STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);
constant sinLUT : LUT := (STD_LOGIC_VECTOR(to_unsigned(2047, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2097, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2147, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2197, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2247, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2297, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2347, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2396, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2446, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2495, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2544, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2592, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2641, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2689, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2736, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2783, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2830, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2876, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2922, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2967, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3011, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3055, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3099, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3142, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3184, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3225, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3266, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3306, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3345, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3384, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3421, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3458, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3529, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3563, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3597, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3629, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3660, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3691, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(3720, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3749, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3776, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3802, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3828, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3852, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3875, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3897, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3938, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3956, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3974, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3990, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4005, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4019, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4032, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4044, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4054, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4063, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4071, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4078, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4084, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4088, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4091, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4093, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4094, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4093, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4091, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4088, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4084, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4078, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4071, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4063, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4054, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4044, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4032, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4019, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(4005, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3990, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3974, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3956, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3938, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3897, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3875, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3852, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3828, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3802, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3776, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3749, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3720, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3691, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3660, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3629, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3597, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3563, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3529, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3458, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3421, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3384, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3345, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3306, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3266, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3225, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3184, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3142, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3099, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3055, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(3011, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2967, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2922, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2876, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(2830, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2783, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2736, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2689, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2641, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2592, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2544, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2495, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2446, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2396, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2347, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2297, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2247, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2197, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2147, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2097, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2047, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1996, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1946, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1896, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1846, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1796, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1746, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1697, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1647, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1598, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1549, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1501, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1452, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1404, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1357, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1310, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1263, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1171, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1126, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1082, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1038, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(994, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(951, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(909, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(868, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(827, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(787, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(748, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(709, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(672, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(635, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(599, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(564, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(530, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(496, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(464, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(433, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(402, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(373, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(344, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(317, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(291, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(265, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(241, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(218, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(196, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(175, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(155, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(137, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(119, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(103, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(88, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(74, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(61, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(49, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(39, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(30, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(22, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(15, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(5, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(0, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(5, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(9, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(15, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(22, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(30, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(39, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(49, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(61, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(74, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(88, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(103, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(119, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(137, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(155, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(175, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(196, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(218, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(241, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(265, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(291, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(317, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(344, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(373, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(402, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(433, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(464, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(496, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(530, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(564, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(599, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(635, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(672, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(709, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(748, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(787, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(827, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(868, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(909, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(951, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(994, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1038, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1082, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1126, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1171, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1263, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1310, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1357, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1404, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1452, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1501, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1549, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1598, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1647, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1697, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1746, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1796, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1846, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1896, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1946, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1996, LUT_WIDTH)));
constant randLUT : LUT := (STD_LOGIC_VECTOR(to_unsigned(704, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(338, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1107, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(418, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(498, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(994, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(62, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(473, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(137, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1283, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(817, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(557, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(516, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(210, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1068, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(332, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(303, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(183, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(61, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(570, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(742, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1107, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(968, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(854, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(707, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1274, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2022, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1558, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1511, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(233, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1368, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1861, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1573, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(850, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(442, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(848, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1518, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(748, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1000, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1441, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1988, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1416, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1037, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1826, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(447, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(601, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1194, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(640, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(698, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1443, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1306, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(141, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(399, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(209, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1834, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2036, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1394, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1303, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1869, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1200, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2004, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1179, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(194, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(905, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1515, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1665, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(382, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(172, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1001, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(290, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(783, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(588, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(656, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(206, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(435, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(557, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1433, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(497, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(872, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1110, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(840, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(514, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1106, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1105, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1170, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1949, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1014,LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1154, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(958, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(656, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(298, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2021, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(819, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(770, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(562, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1681, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(82, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(401, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(178, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(178, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(114, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(284, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1280, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1944, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(94, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(768, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1079, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1217, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1678, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(863, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1725, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(189, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1272, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1553, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(27, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(298, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1872, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(155, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(735, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1791, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(744, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(970, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(679, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(36, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1280, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1246, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1953, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1688, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1442, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1749, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1387, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(501, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(398, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(83, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(531, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1230, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(268, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(484, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(75, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1023, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1185, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(214, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1964, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(482, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(476, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(605, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1931, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1560, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2042, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1061, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1333, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(978, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1762, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(325, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(210, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(931, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(447, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1840, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(473, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1078, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1669, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1442, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1750, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(270, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(410, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(14, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(533, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1452, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1262, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1494, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(482, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1341, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1031, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(299, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1564, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1861, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1921, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1504, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1607, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(214, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1626, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1331, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(421, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(918, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1041, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(292, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(37, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1668, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(464, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(86, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1225, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1900, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(205, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(79, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(868, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(110, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(681, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1009, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(770, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(471, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1126, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1404, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1974, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1832, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1177, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(483, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2025, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1382, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2014, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1956, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1931, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(975, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1235, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1964, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(687, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(409, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(496, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(537, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(559, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2038, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(973, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(430, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(294, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(308, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1805, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1760, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(879, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(47, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1050, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2013, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(147, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(805, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(933, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(123, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1722, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(2026, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(366, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1439, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(992, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(442, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(258, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1702, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(896, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(770, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1503, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(216, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1972, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(40, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(938, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1391, LUT_WIDTH)),STD_LOGIC_VECTOR(to_unsigned(1708, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(829, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1600, LUT_WIDTH)), STD_LOGIC_VECTOR(to_unsigned(1789, LUT_WIDTH)));
  component ClockDivider
    generic (

      CE  : STD_LOGIC := '1';
      RST : STD_LOGIC := '0';
      div : INTEGER   := 2);
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      reset   : in STD_LOGIC;
      div_clk : out STD_LOGIC);
  end component;
  component GeneratorLUT
    generic (
      CE                : STD_LOGIC;
      RST               : STD_LOGIC;
      DATA_WIDTH        : NATURAL;
      A_WIDTH           : NATURAL;
      TETA_WIDTH        : NATURAL;
      AMP_WIDTH         : NATURAL;
      OFF_WIDTH         : NATURAL;
      LUT_ADDRESS_WIDTH : NATURAL;
      LUT_SIZE          : NATURAL;
      LUT_WIDTH         : NATURAL);
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      reset   : in STD_LOGIC;
      start   : in STD_LOGIC;
      a       : in STD_LOGIC_VECTOR(A_WIDTH - 1 downto 0);
      teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
      amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
      off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
      addr    : out STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0);
      val     : in  STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);
      status  : out STD_LOGIC;
      output  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0));
  end component;
  component GeneratorTri is
    generic (
      CE         : STD_LOGIC;
      RST        : STD_LOGIC;
      DATA_WIDTH : NATURAL;
      TETA_WIDTH : NATURAL;
      AMP_WIDTH  : NATURAL;
      OFF_WIDTH  : NATURAL
    );
    port (
      src_clk : in STD_LOGIC;
      src_ce  : in STD_LOGIC;
      start   : in STD_LOGIC;
      reset   : in STD_LOGIC;
      k1      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      k2      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      d1      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      d2      : in STD_LOGIC_VECTOR (TETA_WIDTH - 1 downto 0);
      teta    : in STD_LOGIC_VECTOR(TETA_WIDTH - 1 downto 0);
      amp     : in STD_LOGIC_VECTOR(AMP_WIDTH - 1 downto 0);
      off     : in STD_LOGIC_VECTOR(OFF_WIDTH - 1 downto 0);
      status  : out STD_LOGIC;
      dout    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
  end component;
  component GenertorSqr
    generic (
      CE         : STD_LOGIC;
      RST        : STD_LOGIC;
      DATA_WIDTH : NATURAL;
      TETA_WIDTH : NATURAL;
      AMP_WIDTH  : NATURAL;
      OFF_WIDTH  : NATURAL
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
      status  : out STD_LOGIC;
      dout    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
  end component;
  component Spi
    generic (
      CE  : STD_LOGIC := '1';
      RST : STD_LOGIC := '0'
    );
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
  end component;

      signal addr    : STD_LOGIC_VECTOR(LUT_ADDRESS_WIDTH - 1 downto 0);
  signal val     :  STD_LOGIC_VECTOR(LUT_WIDTH - 1 downto 0);

  signal gen_clk    : STD_LOGIC;
  signal gen_status : STD_LOGIC;
  signal lut_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal tri_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal sqr_data   : STD_LOGIC_VECTOR(11 downto 0);
  signal gen_data   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
  clkd : ClockDivider
  generic map(div => 32)
  port map(
    src_clk => src_clk,
    src_ce  => src_ce,
    reset   => reset,
    div_clk => gen_clk);

  genc : GeneratorLUT
  generic map(
    CE                => CE,
    RST               => RST,
    DATA_WIDTH        => DATA_WIDTH,
    A_WIDTH           => A_WIDTH,
    TETA_WIDTH        => TETA_WIDTH,
    AMP_WIDTH         => AMP_WIDTH,
    OFF_WIDTH         => OFF_WIDTH,
    LUT_ADDRESS_WIDTH => LUT_ADDRESS_WIDTH,
    LUT_SIZE          => LUT_SIZE,
    LUT_WIDTH         => LUT_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    reset   => reset,
    start   => start,
    a       => a,
    teta    => teta,
    amp     => amp,
    off     => off,
    addr => addr,
    val => val,
    status  => gen_status,
    output  => lut_data);

  gent : GeneratorTri
  generic map(
    CE         => CE,
    RST        => RST,
    DATA_WIDTH => DATA_WIDTH,
    TETA_WIDTH => TETA_WIDTH,
    AMP_WIDTH  => AMP_WIDTH,
    OFF_WIDTH  => OFF_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    start   => start,
    reset   => reset,
    k1      => k0,
    k2      => k1,
    d1      => d0,
    d2      => d1,
    teta    => teta,
    amp     => amp,
    off     => off,
    status  => open,
    dout    => tri_data);

  gens : GenertorSqr
  generic map(
    CE         => CE,
    RST        => RST,
    DATA_WIDTH => DATA_WIDTH,
    TETA_WIDTH => TETA_WIDTH,
    AMP_WIDTH  => AMP_WIDTH,
    OFF_WIDTH  => OFF_WIDTH)
  port map(
    src_clk => gen_clk,
    src_ce  => src_ce,
    start   => start,
    reset   => reset,
    k1      => k0,
    k2      => k1,
    teta    => teta,
    amp     => amp,
    off     => off,
    status  => open,
    dout    => sqr_data);

  spic : Spi
  port map(
    src_clk  => src_clk,
    src_ce   => src_ce,
    reset    => reset,
    start    => gen_status,
    data     => gen_data,
    SCK      => out_spi_sck,
    MISO     => out_spi_miso,
    MOSI     => out_spi_mosi,
    CS       => out_spi_cs,
    status   => open,
    response => open);

  with s select gen_data(11 downto 0) <=
    tri_data when "10",
    sqr_data when "11",
    lut_data when others;
    
  with s select val <= sinLUT(to_integer(UNSIGNED(addr))) when "00",
  randLUT(to_integer(UNSIGNED(addr))) when "01",
  (others => '0') when others;

end Behavioral;