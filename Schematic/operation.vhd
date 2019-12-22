library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity operation is
    port(
    ir : in STD_LOGIC_VECTOR(15 downto 0);
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
    NopA <= (not ir(15)) and (not ir(14)) and (not ir(13)) and (not ir(12)) and istwo;
    ADDD <= (not ir(15)) and (not ir(14)) and (not ir(13)) and ir(12) and istwo;
    ADC <= (not ir(15)) and (not ir(14)) and ir(13) and (not ir(12)) and istwo;
    SUB <= (((not ir(15)) and (not ir(14)) and ir(13) and ir(12)) 
    or (ir(15) and (not ir(14)) and (not ir(13)) and (not ir(12)))) 
    and istwo;
    SBC <= (not ir(15)) and ir(14) and (not ir(13)) and (not ir(12)) and istwo;
    ANDD <= (not ir(15)) and ir(14) and (not ir(13)) and ir(12) and istwo;
    ORR <= (not ir(15)) and ir(14) and ir(13) and (not ir(12)) and istwo;
    XNORR <= (not ir(15)) and ir(14) and ir(13) and ir(12) and istwo;

    -- 1-op
    IncA <= (not ir(11)) and (not ir(10)) and ir(9) and (not ir(8)) and isone;
    DecA <= (not ir(11)) and (not ir(10)) and ir(9) and ir(8) and isone;
    Clear <= (not ir(11)) and ir(10) and (not ir(9)) and (not ir(8)) and isone;
    NotA <= (not ir(11)) and ir(10) and (not ir(9)) and ir(8) and isone;
    LSR_B <= (not ir(11)) and ir(10) and ir(9) and (not ir(8)) and isone;
    ROR_B <= (not ir(11)) and ir(10) and ir(9) and ir(8) and isone;
    RRC_B <= ir(11) and (not ir(10)) and (not ir(9)) and (not ir(8)) and isone;
    ASR_B <= ir(11) and (not ir(10)) and (not ir(9)) and ir(8) and isone;
    LSL_B <= ir(11) and (not ir(10)) and ir(9) and (not ir(8)) and isone;
    ROL_B <= ir(11) and (not ir(10)) and ir(9) and ir(8) and isone;
    RLC_B <= ir(11) and ir(10) and (not ir(9)) and (not ir(8)) and isone;
end arch;

