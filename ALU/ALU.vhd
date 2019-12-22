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
		  F         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end component full16bitAdder;

component mux4x1 is
    port (in3, in2, in1, in0  : std_logic;
          s1, s0       : std_logic;
          f       : out std_logic);
end component mux4x1;


signal NotB, NegB, FA1, FAB, FABC, FANegB, FANegBNegC, FANeg1, Fout, one    : std_logic_vector (15 downto 0);   
signal CB, NotC, CA1, CAB, CABC, CANegB, CANegBNegC, CANeg1      : std_logic;
signal ZFMout, oring, tempCout   :   std_logic;


begin
    NotB <= not B;
    NotC <= not Cin;
    one <= "0000000000000001";
    NegBAdder    : full16bitAdder  port map (NotB, one, '0', NegB, CB);
    
    IncA_Adder   : full16bitAdder  port map (A, "0000000000000001", Cin, FA1, CA1);
    DecA_Adder   : full16bitAdder  port map (A, "1111111111111111", '0', FANeg1, CANeg1);
    
    ADDD_Adder   : full16bitAdder  port map (A, B, '0', FAB, CAB);
    ADC_Adder    : full16bitAdder  port map (A, B, Cin, FABC, CABC);
    
    SUB_Adder    : full16bitAdder  port map (A, NegB, '0', FANegB, CANegB);
    SBC_Adder_C0 : full16bitAdder  port map (FANegB, "1111111111111111", CANegB, FANegBNegC, CANegBNegC); 
    
    ZFMux        : mux4x1 port map ('0', '1', ZFin, ZFin, en, oring, ZFMout);
    
    
    Fout    <= A when NopA = '1' else 
               FAB when ADDD = '1' else
               FABC when ADC = '1' else
               FANegB when SUB = '1' or (SBC = '1' and Cin = '1') else
               FANegBNegC when SBC = '1' else
               A and B when ANDD = '1' else
               A or B when ORR =  '1' else
               A xnor B when XNORR = '1' else
               FA1 when IncA = '1' else
               FANeg1 when DecA = '1' else
               (others => '0') when clear = '1' else
               not A when NotA = '1' else
               '0' & B (15 downto 1) when LSR_B = '1' else
               B(0) & B (15 downto 1) when ROR_B = '1' else
               Cin & B (15 downto 1) when RRC_B = '1' else
               B(15) & B (15 downto 1) when ASR_B = '1' else
               B (14 downto 0) & '0' when LSL_B = '1' else
               B (14 downto 0) & B(15) when ROL_B = '1' else
               B (14 downto 0) & Cin when RLC_B = '1';
            
    tempCout <= CAB when ADDD = '1' else
                CABC when ADC = '1' else
                CANegB when SUB = '1' or (SBC = '1' and Cin = '1') else
                CANegBNegC when SBC = '1' else
                CA1  when IncA = '1' else
                CANeg1 when DecA = '1';
                

	F <= Fout when en = '1';
    Cout <= tempCout when en = '1' else
            Cin when en = '0';
    
    oring <= Fout(0) or Fout(1) or Fout(2) or Fout(3) or Fout(4) or Fout(5) or Fout(6) or Fout(7)
                or Fout(8) or Fout(9) or Fout(10) or Fout(11) or Fout(12) or Fout(13) or Fout(14) or Fout(15);
    
	ZFout <= ZFMout;
    
end ALU_arch;