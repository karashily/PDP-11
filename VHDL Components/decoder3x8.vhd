library ieee;
use ieee.std_logic_1164.all;

entity decoder3x8 is
  port(input: in std_logic_vector(2 downto 0);
      enable: in std_logic;
      output: out std_logic_vector(7 downto 0));
end decoder3x8;

architecture a_dec of decoder3x8 is
  begin
    output(0) <= not input(2) and not input(1) and not input(0) and enable;
    output(1) <= not input(2) and not input(1) and input(0) and enable;
    output(2) <= not input(2) and input(1) and not input(0) and enable;
    output(3) <= not input(2) and input(1) and input(0) and enable;
    output(4) <= input(2) and not input(1) and not input(0) and enable;
    output(5) <= input(2) and not input(1) and input(0) and enable;
    output(6) <= input(2) and input(1) and not input(0) and enable;
    output(7) <= input(2) and input(1) and input(0) and enable;
end a_dec;