library ieee;
use ieee.std_logic_1164.all;

entity circ is
    port(
        ir: in std_logic_vector(15 downto 0);
        flags : in std_logic_vector(15 downto 0);
        --enable: in std_logic;
        clk: in std_logic;
        s1,s3,s4,s5,s6,s7 :out std_logic_vector(7 downto 0);
        s2 :out std_logic_vector(3 downto 0)
    );
end circ;

architecture arch of circ is
    component control_store is 
        port (
            address: in std_logic_vector (4 downto 0);
            output: out std_logic_vector (24 downto 0)
        );
        end component;
    component branching is
        port(
        ir : in STD_LOGIC_VECTOR(15 downto 0);
        flags : in STD_LOGIC_VECTOR(15 downto 0);
        currentAR : in std_logic_vector(4 downto 0);
        b1,b2,b3,b4,b5,b6,b7,b8: in std_logic;
        address : out std_logic_vector(4 downto 0)
        );
        end component;
    component mir_dec is
        port(mir: in std_logic_vector(24 downto 0);
            --enable: in std_logic;
             s1,s3,s4,s5,s6,s7 :out std_logic_vector(7 downto 0);
             s2 :out std_logic_vector(3 downto 0);
             next_address_bef: out std_logic_vector(4 downto 0)
            );
        end component;
    

    signal microAR, current_address, next_address_branch_out: std_logic_vector(4 downto 0);
    signal microIR : std_logic_vector(24 downto 0);
    signal s11,s33,s44,s55,s66,s77 : std_logic_vector(7 downto 0);
    signal s22 : std_logic_vector(3 downto 0);

  begin

    branch: branching port map(ir,flags,current_address,s77(1),s77(4),s77(3),s77(2),s77(6),s77(5),s66(6),s77(7),next_address_branch_out);
    rom: control_store port map(microAR,microIR);
    mir_d: mir_dec port map(microIR,s11,s33,s44,s55,s66,s77,s22,current_address);

    process(clk)
    begin
        if rising_edge(clk) then
            microAR <= next_address_branch_out;
        end if;
    end process;
    s1 <= s11;
    s2 <= s22;
    s3 <= s33;
    s4 <= s44;
    s5 <= s55;
    s6 <= s66;
    s7 <= s77;

  end arch;
