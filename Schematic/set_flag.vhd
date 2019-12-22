library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity setFlag is
    port(
        flagsin:in STD_LOGIC_VECTOR(15 downto 0);
        setflag00,setflag01,setflag10,setflag11: in std_logic;
        flagsout:out STD_LOGIC_VECTOR(15 downto 0)

    );
end setFlag;


architecture arch  of setFlag is 

component mux2x1 is
    port (in1, in0  : in std_logic;
        s       : in std_logic;
        f       : out std_logic);
end component;


signal en:std_logic;
signal o1,o2,i1,i2:std_logic;

begin
    flagsout(1 downto 0) <= flagsin(1 downto 0);
    flagsout(15 downto 4) <= flagsin(15 downto 4);

    i1 <= flagsin(2);
    i2 <= flagsin(3);
    en <= setflag00 or setflag01 or setflag10 or setflag11;
    o1 <= setflag01 or setflag11;
    o2 <= setflag10 or setflag11;

    u0:mux2x1 port map(o1,i1,en,flagsout(2));
    u1:mux2x1 port map(o2,i2,en,flagsout(3));
    



end arch;

