library IEEE;
use IEEE.std_logic_1164.all;

entity full16bitAdder is  
	port (A, B      :   IN   std_logic_vector (15 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (15 downto 0);
		  Cout      :   OUT  std_logic);
end entity full16;

architecture    full16Arch  of full16bitAdder is

component full1bitAdder is
    port(x, y, cin      :   IN std_logic;
        cout, sum       :   OUT std_logic);
end component;

signal carry : std_logic_vector (15 downto 0);

begin
loop1:  for i in 0 to 15 generate
            g0: if i = 0 generate
                    f0: fullAdder port map (A(i), B(i), Cin, carry(i), F(i));
            end generate g0;
        
            gx: if i > 0 generate
                    f1: fullAdder port map  (A(i), B(i), carry(i-1), carry(i), F(i));
            end generate gx;
        end generate;
    cout <= carry(15);
    
end full16Arch;