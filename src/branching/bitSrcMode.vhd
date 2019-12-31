library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitSrcMode is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitSrcMode;

architecture arch  of bitSrcMode is 


begin
    address(0) <= srcMode(0);
    address(1) <= srcMode(1);
    address(2) <= '1';
    address(3) <= '0';
    address(4) <= '0';
end arch;

