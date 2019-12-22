library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity operation is
    port(
    ir: in STD_LOGIC_VECTOR(15 downto 0);
    en : in std_logic;
    NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B : out std_logic
    );
end operation;

architecture arch  of operation is 

signal istwo , isone , isbr , isno : std_logic;
begin
    isone <= ir(15) and ir(14) and ir(13) and (not ir(12));
    isbr <= ir(15) and ir(14) and (not ir(13));
    isno <= ir(15) and ir(14) and ir(13) and ir(12) and (not ir(11));
    istwo <= (not isone) and (not isbr) and (not isno);
    
    -- 2-op
    NopA <= (not ir(15)) and (not ir(14)) and (not ir(13)) and (not ir(12)) and istwo and en;
    ADDD <= (not ir(15)) and (not ir(14)) and (not ir(13)) and ir(12) and istwo and en;
    ADC <= (not ir(15)) and (not ir(14)) and ir(13) and (not ir(12)) and istwo and en;
    SUB <= (((not ir(15)) and (not ir(14)) and ir(13) and ir(12)) 
    or (ir(15) and (not ir(14)) and (not ir(13)) and (not ir(12)))) 
    and istwo and en;
    SBC <= (not ir(15)) and ir(14) and (not ir(13)) and (not ir(12)) and istwo and en;
    ANDD <= (not ir(15)) and ir(14) and (not ir(13)) and ir(12) and istwo and en;
    ORR <= (not ir(15)) and ir(14) and ir(13) and (not ir(12)) and istwo and en;
    XNORR <= (not ir(15)) and ir(14) and ir(13) and ir(12) and istwo and en;

    -- 1-op
    IncA <= (not ir(11)) and (not ir(10)) and ir(9) and (not ir(8)) and isone and en;
    DecA <= (not ir(11)) and (not ir(10)) and ir(9) and ir(8) and isone and en;
    Clear <= (not ir(11)) and ir(10) and (not ir(9)) and (not ir(8)) and isone and en;
    NotA <= (not ir(11)) and ir(10) and (not ir(9)) and ir(8) and isone and en;
    LSR_B <= (not ir(11)) and ir(10) and ir(9) and (not ir(8)) and isone and en;
    ROR_B <= (not ir(11)) and ir(10) and ir(9) and ir(8) and isone and en;
    RRC_B <= ir(11) and (not ir(10)) and (not ir(9)) and (not ir(8)) and isone and en;
    ASR_B <= ir(11) and (not ir(10)) and (not ir(9)) and ir(8) and isone and en;
    LSL_B <= ir(11) and (not ir(10)) and ir(9) and (not ir(8)) and isone and en;
    ROL_B <= ir(11) and (not ir(10)) and ir(9) and ir(8) and isone and en;
    RLC_B <= ir(11) and ir(10) and (not ir(9)) and (not ir(8)) and isone and en;
end arch;

