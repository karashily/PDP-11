library ieee;
use ieee.std_logic_1164.all;

entity src_dst_dec is
  port(input: in std_logic;
      status: in std_logic_vector(1 downto 0);
      srcout: out std_logic;
      dstout: out std_logic);
end src_dst_dec;

architecture a_dec of src_dst_dec is
  begin
    srcout <= input and not status(1) and status(0);
    dstout <= input and status(1) and not status(0);
end a_dec;
