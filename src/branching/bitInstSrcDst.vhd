library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitInstSrcDst is
    port(
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitInstSrcDst;

architecture arch  of bitInstSrcDst is 

begin
    address(0) <= not(flagStatus(0)) and not(flagStatus(1));
    address(1) <= '1';
    address(2) <= '0';
    address(3) <= '1';
    address(4) <= '1';
end arch;

