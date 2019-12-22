library ieee;
use ieee.std_logic_1164.all;

entity ndff is 
  generic(n:integer := 32);
  port(clk,rst,load: in std_logic;
      d: in std_logic_vector (n-1 downto 0);
      q: out std_logic_vector (n-1 downto 0));
  end ndff;
  
architecture a_ndff of ndff is
  component dff is
    port(d,clk,rst,load: in std_logic;
        q: out std_logic);
  end component;
  begin
    loop1: for i in 0 to n-1 generate
      fx: dff port map (d(i),clk,rst,load,q(i));
    end generate;
  end a_ndff;