library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity main is
    port(
    ir : in STD_LOGIC_VECTOR(15 downto 0);
    flags : in STD_LOGIC_VECTOR(15 downto 0);
    currentAR : in std_logic_vector(4 downto 0);
    b1,b2,b3,b4,b5,b6,b7,b8: in std_logic;
    address : out std_logic_vector(4 downto 0)
    );
end main;

architecture arch  of main is 



component bitDirIndir is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    dstMode : in STD_LOGIC_VECTOR(2 downto 0); 
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitDstMode is
    port(
    dstMode : in STD_LOGIC_VECTOR(2 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitInstSrcDst is
    port(
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitRegDirIndir is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    dstMode : in STD_LOGIC_VECTOR(2 downto 0); 
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitSave is
    port(    
    dstMode : in std_logic_vector(2 downto 0);
    opcode : in std_logic_vector(3 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitSrcDst is
    port(
    flagStatus : in std_logic_vector(1 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component bitSrcMode is
    port(
    srcMode : in STD_LOGIC_VECTOR(2 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;

component wide is
    port(
    ir : in std_logic_vector(15 downto 0);
    flags : in std_logic_vector(15 downto 0);
    address : out std_logic_vector(4 downto 0)
    );
end component;


signal add1,add2,add3,add4,add5,add6,add7,add8,add9 : std_logic_vector(4 downto 0);
signal srcMode,dstMode : std_logic_vector(2 downto 0);
signal flagStatus : std_logic_vector(1 downto 0);
signal b9 : std_logic ; 
signal b1arr : std_logic_vector(4 downto 0) ;
signal b2arr : std_logic_vector(4 downto 0) ;
signal b3arr : std_logic_vector(4 downto 0) ;
signal b4arr : std_logic_vector(4 downto 0) ;
signal b5arr : std_logic_vector(4 downto 0) ;
signal b6arr : std_logic_vector(4 downto 0) ;
signal b7arr : std_logic_vector(4 downto 0) ;
signal b8arr : std_logic_vector(4 downto 0) ;
signal b9arr : std_logic_vector(4 downto 0) ;


begin
    b9 <= (not b1) and (not b2) and (not b3) and (not b4) and (not b5) and (not b6) and (not b7) and (not b8);
    b1arr <= (others => b1);
    b2arr <= (others => b2);
    b3arr <= (others => b3);
    b4arr <= (others => b4);
    b5arr <= (others => b5);
    b6arr <= (others => b6);
    b7arr <= (others => b7);
    b8arr <= (others => b8);
    b9arr <= (others => b9);

    srcMode <= ir(11 downto 9);
    dstMode <= ir(5 downto 3);
    flagStatus <= flags(3 downto 2);

    u1:bitDirIndir port map(srcMode,dstMode,flagStatus,add1);
    u2:bitDstMode port map (dstMode,add2);
    u3:bitInstSrcDst port map (flagStatus,add3);
    u4:bitRegDirIndir port map (srcMode,dstMode,flagStatus,add4);
    u5:bitSave port map (dstMode,ir(15 downto 12),add5);
    u6:bitSrcDst port map(flagStatus,add6);
    u7:bitSrcMode port map(srcMode,add7);
    u8:wide port map(ir,flags,add8);
    add9 <= currentAR;
    address <= (add1 and b1arr) or (add2 and b2arr) or (add3 and b3arr) or (add4 and b4arr) or (add5 and b5arr) or (add6 and b6arr) or (add7 and b7arr) or (add8 and b8arr) or (add9 and b9arr);
    

end arch;

