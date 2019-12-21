library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bitSave is
    port(    
    dstMode : in std_logic_vector(2 downto 0);
    opcode : in std_logic_vector(3 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end bitSave;

architecture arch  of bitSave is 
signal regDir : std_logic;
signal isCmp : std_logic;
begin
    regDir <= (not dstMode(0)) and (not dstMode(1)) and (not dstMode(2));
    isCmp <= opcode(3) and (not opcode(1)) and (not opcode(2)) and (not opcode(0));
    address(0) <= isCmp or (not regDir);
    address(1) <= not isCmp;
    address(2) <= not isCmp;
    address(3) <= '0';
    address(4) <= '1';
end arch;

