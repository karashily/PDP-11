library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitRegDirIndir is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    dstMode : in STD_LOGIC_VECTOR(2 downto 0); 
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitRegDirIndir;

architecture arch  of bitRegDirIndir is 

signal regDirSrc , regDirDst , regIndirSrcDst:std_logic;
begin
    regDirSrc <= flagStatus(0) and (not flagStatus(1)) and (not srcMode(0)) and (not srcMode(1)) and (not srcMode(2));
    regDirDst <= flagStatus(1) and (not flagStatus(0)) and (not dstMode(0)) and (not dstMode(1)) and (not dstMode(2));
    regIndirSrcDst <= (flagStatus(0) and (not flagStatus(1)) and (not srcMode(2)) and (not srcMode(1)) and srcMode(0)) or (flagStatus(1) and (not flagStatus(0)) and (not dstMode(0)) and (not dstMode(1)) and dstMode(2));
    address(0) <= (regDirSrc or regDirDst) and not(regIndirSrcDst);
    address(1) <= (regDirSrc or regIndirSrcDst) and not(regDirDst);
    address(2) <= not ((regDirSrc or regIndirSrcDst) and not(regDirDst));
    address(3) <= (regDirSrc or regIndirSrcDst) and not(regDirDst);
    address(4) <= not ((regDirSrc or regIndirSrcDst) and not(regDirDst));
end arch;

