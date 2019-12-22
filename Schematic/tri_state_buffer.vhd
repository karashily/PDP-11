library ieee;
use ieee.std_logic_1164.all;

entity tri_state_buffer is
  generic(n: integer := 32);
  port( input: in std_logic_vector(n-1 downto 0);
      enable: in std_logic;
      output: out std_logic_vector(n-1 downto 0));
end tri_state_buffer;

architecture a_tri of tri_state_buffer is
  begin 
    process(enable)
      begin
        if enable = '1' then
          output <= input;
        else
          output <= (others=>'Z');
        end if;
    end process;
end a_tri;
