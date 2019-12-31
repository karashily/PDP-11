library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
    port (in1, in0  : in std_logic;
        s       : in std_logic;
        f       : out std_logic);
end entity mux2x1;

architecture mux21Arch of mux2x1 is
begin
    with s select
        f <= in0 when '0',
             in1 when '1',
             '0' WHEN OTHERS;
end mux21Arch;