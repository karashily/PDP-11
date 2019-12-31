library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity decoder2 is
 port(
 a : in STD_LOGIC_VECTOR(1 downto 0);
 en : in std_logic;
 b : out STD_LOGIC_VECTOR(3 downto 0)
 );
end decoder2;
 
architecture bhv of decoder2 is
begin

b(0) <= not a(1) and not a(0) and en;
b(1) <= not a(1) and a(0) and en;
b(2) <= a(1) and not a(0) and en;
b(3) <= a(1) and a(0) and en;
 
end bhv;