library IEEE;
use IEEE.std_logic_1164.all;

entity decrementor is
    port (inp       :   in std_logic_vector (15 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (15 downto 0));
end entity decrementor;

architecture decrementorArch of decrementor is
component full16bitAdder is  
	port (A, B      :   IN   std_logic_vector (15 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end component full16bitAdder;

signal decPC : std_logic_vector (15 downto 0);
signal temp : std_logic;

begin
        u0 : full16bitAdder port map (inp, "1111111111111111", '0', decPC, temp);
        
        op <= decPC when en = '1';
end decrementorArch;