library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitDirIndir is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    dstMode : in STD_LOGIC_VECTOR(2 downto 0); 
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitDirIndir;

architecture arch  of bitDirIndir is 


begin
    address(0) <= (((not flagStatus(1)) and flagStatus(0)) and (not srcMode(2))) or (((not flagStatus(0)) and flagStatus(1)) and (not dstMode(2)));
    address(1) <= '0';
    address(2) <= '1';
    address(3) <= '1';
    address(4) <= '0';
end arch;

