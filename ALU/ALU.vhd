library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is
    port (A, B          :       in std_logic_vector (15 downto 0);
          F             :       out std_logic_vector (15 downto 0);
          NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B : in std_logic;
          Cin           :       in std_logic;
          Cout, ZF      :       out std_logic);
end entity ALU;

architecture ALU_arch of ALU is
component full16bitAdder is  
	port (A, B      :   IN   std_logic_vector (15 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end component full16bitAdder;

signal NotB, NegB, FA1, FAB, FABC, FANegB, FANegBNegC, FANeg1    : std_logic_vector (15 downto 0);   
signal CB, NotC, CA1, CAB, CABC, CANegB, CANegBNegC, CANeg1      : std_logic;

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
    
    
    process (NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B)
    begin
        if  NopA = '1' then
            F    <= A;
        elsif ADDD = '1' then
            F    <= FAB;
            Cout <= CAB;
        elsif ADC = '1' then
            F    <= FABC;
            Cout <= CABC;
        elsif SUB = '1' or (SBC = '1' and Cin = '1') then
            F    <= FANegB;
            Cout <= CANegB;
        elsif SBC = '1' then
            F    <= FANegBNegC;
            Cout <= CANegBNegC;
        elsif ANDD = '1' then
            F <= A and B;
        elsif ORR = '1' then
            F <= A or B;
        elsif XNORR = '1' then
            F <= A xnor B;
        elsif IncA = '1' then
            F    <= FA1;
            Cout <= CA1;
        elsif DecA = '1' then
            F    <= FANeg1;
            Cout <= CANeg1;
        elsif Clear = '1' then
            F <= (others => '0');
        elsif NotA = '1' then
            F <= not A;
        elsif LSR_B = '1' then
            F <= '0' & B (15 downto 1);
        elsif ROR_B = '1' then
            F <= B(0) & B (15 downto 1);
        elsif RRC_B = '1' then
            F <= Cin & B (15 downto 1);
        elsif ASR_B = '1' then
            F <= B(15) & B (15 downto 1);
        elsif LSL_B = '1' then
            F <= B (14 downto 0) & '0';
        elsif ROL_B = '1' then
            F <= B (14 downto 0) & B(15);
        elsif RLC_B = '1' then
            F <= B (14 downto 0) & Cin;
        end if;
    end process;
end ALU_arch;