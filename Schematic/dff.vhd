library ieee;
use ieee.std_logic_1164.all;

entity dff is
  port(d, clk, rst, load: in std_logic;
      q: out std_logic);
end dff;

architecture a_dff of dff is
  begin
    process(clk, rst, load)
      begin
        if(rst ='1') then
          q <= '0';
        elsif rising_edge(clk) and load = '1' then
          q <= d;
        end if;
    end process;
  end a_dff;
