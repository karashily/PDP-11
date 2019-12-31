library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitDstMode is
    port(
    dstMode : in STD_LOGIC_VECTOR(2 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitDstMode;

architecture arch  of bitDstMode is 


begin
    address(0) <= dstMode(1);
    address(1) <= dstMode(2);
    address(2) <= '1';
    address(3) <= '0';
    address(4) <= '0';
end arch;

