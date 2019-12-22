library IEEE;
use IEEE.std_logic_1164.all;

entity incrementor is
    port (inp       :   in std_logic_vector (15 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (15 downto 0));
end entity incrementor;

architecture incrementorArch of incrementor is
component full16bitAdder is  
	port (A, B      :   IN   std_logic_vector (15 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end component full16bitAdder;

signal incPC : std_logic_vector (15 downto 0);
signal temp : std_logic;

begin
        u0 : full16bitAdder port map (inp, "0000000000000001", '0', incPC, temp);
        
        op <= incPC when en = '1';
end incrementorArch;