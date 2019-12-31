library ieee;
use ieee.std_logic_1164.all;

entity mir_dec is
  port(mir: in std_logic_vector(24 downto 0);
      --enable: in std_logic;
       s1,s3,s4,s5,s6,s7 :out std_logic_vector(7 downto 0);
       s2 :out std_logic_vector(3 downto 0);
        next_address_bef: out std_logic_vector(4 downto 0)
      );
end mir_dec;

architecture arch of mir_dec is

    component decoder3 is
        port(
        a : in STD_LOGIC_VECTOR(2 downto 0);
        en : in std_logic;
        b : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

   
    component decoder2 is
        port(
        a : in STD_LOGIC_VECTOR(1 downto 0);
        en : in std_logic;
        b : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    
    begin

        f1: decoder3 port map(mir(2 downto 0),'1',s1);
        f2: decoder2 port map(mir(4 downto 3),'1',s2);
        f3: decoder3 port map(mir(7 downto 5),'1',s3);
        f4: decoder3 port map(mir(10 downto 8),'1',s4);
        f5: decoder3 port map(mir(13 downto 11),'1',s5);
        f6: decoder3 port map(mir(16 downto 14),'1',s6);
        f7: decoder3 port map(mir(19 downto 17),'1',s7);
        next_address_bef <= mir(24 downto 20);
        --signals <= s7 & s6 & s5 & s4 & s3 & s2 & s1;

end arch;
