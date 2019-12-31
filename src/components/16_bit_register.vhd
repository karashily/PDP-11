LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY register16 IS PORT(
    d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- output
);
END register16;

ARCHITECTURE description OF register16 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= "0000000000000000";
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
END description;
