library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity wide is
    port(
    ir : in std_logic_vector(15 downto 0);
    flags : in std_logic_vector(15 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end wide;

architecture arch  of wide is 

component decoder3 is
    port(
    a : in STD_LOGIC_VECTOR(2 downto 0);
    en : in std_logic;
    b : out STD_LOGIC_VECTOR(7 downto 0)
    );
end component;

signal istwo , isone , isbr , isno : std_logic;
signal zeroFlag, carryFlag : std_logic;
signal BranchType : std_logic_vector(7 downto 0);
signal branch : std_logic; -- determine if i will branch or go to end
signal nop,hlt : std_logic;
signal BR,BEQ,BNE,BLO,BLS,BHI,BHS : std_logic;
begin
    isone <= ir(15) and ir(14) and ir(13) and (not ir(12));
    isbr <= ir(15) and ir(14) and (not ir(13));
    isno <= ir(15) and ir(14) and ir(13) and ir(12) and (not ir(11));
    istwo <= (not isone) and (not isbr) and (not isno);
    hlt <= (not ir(10)) and isno;
    nop <= ir(10) and isno;
    -- condition of branching
    -- assume flags(0) = Zero flag
    -- assume flags(1) = carry flag
    zeroFlag <= flags(0);
    carryFlag <= flags(1);

    u0:decoder3 port map (ir(12 downto 10) , '1' , BranchType);

    BR <= BranchType(0);
    BEQ <= zeroFlag and BranchType(1);
    BNE <= not zeroFlag and BranchType(2);
    BLO <= not carryFlag and BranchType(3);
    BLS <= zeroFlag and (not carryFlag) and BranchType(4);
    BHI <= carryFlag and BranchType(5);
    BHS <= zeroFlag and carryFlag and BranchType(6);

    branch <= (BR or BEQ or BNE or BLO or BLS or BHI or BHS);

    --

    address <= "01110" when (isbr = '1' and branch = '1') else
     "10001" when (isbr = '1' and branch = '0') else
     "01011" when (isone = '1') else
     "00000" when (istwo = '1')else
     "00001" when (hlt = '1') else
     "10001" when (nop = '1') ;

    


end arch;

