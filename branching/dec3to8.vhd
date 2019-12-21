library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity decoder3 is
 port(
 a : in STD_LOGIC_VECTOR(2 downto 0);
 en : in std_logic;
 b : out STD_LOGIC_VECTOR(7 downto 0)
 );
end decoder3;



architecture bhv of decoder3 is

component decoder2 is
    port(
    a : in STD_LOGIC_VECTOR(1 downto 0);
    en : in std_logic;
    b : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal m0: STD_LOGIC;
signal m1: STD_LOGIC;

begin

m0 <= NOT a(2) AND en;
m1 <= a(2) AND en;

u0:decoder2 port map (a(1 downto 0) , m1 , b(7 downto 4));
u1:decoder2 port map (a(1 downto 0) , m0 , b(3 downto 0));

end bhv;