library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is
    port (A, B             :       in std_logic_vector (15 downto 0);
          F                :       out std_logic_vector (15 downto 0);
          NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B : in std_logic;
          Cin, ZFin, en    :       in std_logic;
          Cout, ZFout      :       out std_logic);
end entity ALU;

architecture ALU_arch of ALU is
component full16bitAdder is  
	port (A, B      :   IN   std_logic_vector (15 downto 0);
  		  Cin       :   IN   std_logic;
		  Fout         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end component full16bitAdder;

component mux4x1 is
    port (in3, in2, in1, in0  : std_logic;
          s1, s0       : std_logic;
          f       : out std_logic);
end component mux4x1;


signal NotB, NegB, FA1, FAB, FABC, FANegB, FANegBNegC, FANeg1, Fout    : std_logic_vector (15 downto 0);   
signal CB, NotC, CA1, CAB, CABC, CANegB, CANegBNegC, CANeg1      : std_logic;
signal ZFMout, oring, tempCout   :   std_logic;


begin
    NotB <= not B;
    NotC <= not Cin;
    NegBAdder    : full16bitAdder  port map (NotB, "0000000000000001", '0', NegB, CB);
    
    IncA_Adder   : full16bitAdder  port map (A, "0000000000000001", Cin, FA1, CA1);
    DecA_Adder   : full16bitAdder  port map (A, "1111111111111111", '0', FANeg1, CANeg1);
    
    ADDD_Adder   : full16bitAdder  port map (A, B, '0', FAB, CAB);
    ADC_Adder    : full16bitAdder  port map (A, B, Cin, FABC, CABC);
    
    SUB_Adder    : full16bitAdder  port map (A, NegB, '0', FANegB, CANegB);
    SBC_Adder_C0 : full16bitAdder  port map (FANegB, "1111111111111111", CANegB, FANegBNegC, CANegBNegC); 
    
    ZFMux        : mux4x1 port map ('0', '1', ZFin, ZFin, en, oring, ZFMout);
    
    process (NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B)
    begin
        if  NopA = '1' then
            Fout    <= A;
        elsif ADDD = '1' then
            Fout    <= FAB;
            tempCout <= CAB;
        elsif ADC = '1' then
            Fout    <= FABC;
            tempCout <= CABC;
        elsif SUB = '1' or (SBC = '1' and Cin = '1') then
            Fout    <= FANegB;
            tempCout <= CANegB;
        elsif SBC = '1' then
            Fout    <= FANegBNegC;
            tempCout <= CANegBNegC;
        elsif ANDD = '1' then
            Fout <= A and B;
        elsif ORR = '1' then
            Fout <= A or B;
        elsif XNORR = '1' then
            Fout <= A xnor B;
        elsif IncA = '1' then
            Fout    <= FA1;
            tempCout <= CA1;
        elsif DecA = '1' then
            Fout    <= FANeg1;
            tempCout <= CANeg1;
        elsif Clear = '1' then
            Fout <= (others => '0');
        elsif NotA = '1' then
            Fout <= not A;
        elsif LSR_B = '1' then
            Fout <= '0' & B (15 downto 1);
        elsif ROR_B = '1' then
            Fout <= B(0) & B (15 downto 1);
        elsif RRC_B = '1' then
            Fout <= Cin & B (15 downto 1);
        elsif ASR_B = '1' then
            Fout <= B(15) & B (15 downto 1);
        elsif LSL_B = '1' then
            Fout <= B (14 downto 0) & '0';
        elsif ROL_B = '1' then
            Fout <= B (14 downto 0) & B(15);
        elsif RLC_B = '1' then
            Fout <= B (14 downto 0) & Cin;
        end if;
    end process;
    
    process (en)
    begin
        if en = '1' then
            F <= Fout;
            Cout <= tempCout;
            oring <= Fout(0) or Fout(1) or Fout(2) or Fout(3) or Fout(4) or Fout(5) or Fout(6) or Fout(7)
                or Fout(8) or Fout(9) or Fout(10) or Fout(11) or Fout(12) or Fout(13) or Fout(14) or Fout(15);
        end if;
    end process;
    
    ZFout <= ZFMout;
    
end ALU_arch;