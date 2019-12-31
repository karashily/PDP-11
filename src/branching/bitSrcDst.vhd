library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitSrcDst is
    port(
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitSrcDst;

architecture arch  of bitSrcDst is 

begin
    address(0) <= '1';
    address(1) <= flagStatus(0) and not(flagStatus(1));
    address(2) <= flagStatus(1) and not(flagStatus(0));
    address(3) <= flagStatus(0) and not(flagStatus(1));
    address(4) <= flagStatus(1) and not(flagStatus(0));
end arch;

