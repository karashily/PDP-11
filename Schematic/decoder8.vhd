library ieee;
use ieee.std_logic_1164.all;

entity decoder8 is
  port(input: in std_logic_vector(2 downto 0);
      enable: in std_logic;
      output: out std_logic_vector(7 downto 0));
end decoder8;

architecture a_dec of decoder8 is
  begin
    output <= "00000000" when enable = '0' 
        else "00000001" when input = "000"
        else "00000010" when input = "001"
        else "00000100" when input = "010"
        else "00001000" when input = "011"
        else "00010000" when input = "100"
        else "00100000" when input = "101"
        else "01000000" when input = "110"
        else "10000000" when input = "111";
end a_dec;
