library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
  port(input: in std_logic_vector(1 downto 0);
      enable: in std_logic;
      output: out std_logic_vector(3 downto 0));
end decoder2x4;

architecture a_dec of decoder2x4 is
  begin
    output(0) <= not input(1) and not input(0) and enable;
    output(1) <= not input(1) and input(0) and enable;
    output(2) <= input(1) and not input(0) and enable;
    output(3) <= input(1) and input(0) and enable;
  end a_dec;
