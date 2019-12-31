LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity full1bitAdder is
    port(x, y, cin      :   IN std_logic;
        cout, sum       :   OUT std_logic);
end entity;

architecture fullAdderArch of full1bitAdder is
component halfAdder is
    port(x, y       :   IN std_logic;
        cout, f     :   OUT std_logic);
end component;

signal out1, out2, cout1, cout2   :   std_logic;

begin
	hA1: halfAdder  port map (cin, out2, cout1, out1);
	hA2: halfAdder  port map (x, y, cout2, out2);
	
	process (out1, cout1, cout2)
	begin
        sum     <= out1;
        cout    <= cout1 or cout2;
  end process;
end fullAdderArch;    