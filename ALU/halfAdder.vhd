LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity halfAdder is
    port(x, y       :   IN std_logic;
        cout, f     :   OUT std_logic);
end entity halfAdder;

architecture halfAdderArch of halfAdder is
begin process (x, y)
    begin
        f       <=  x xor y;
        cout    <=  x and y;
    end process;
end halfAdderArch;