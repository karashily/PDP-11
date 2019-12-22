library ieee;
use ieee.std_logic_1164.all;

entity cpu is
  port(bidir: INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      src_sel: in std_logic_vector(2 downto 0);
      dst_sel: in std_logic_vector(2 downto 0);
      src_enable: in std_logic;
      dst_enable: in std_logic;
      wr: in std_logic;
      rd: in std_logic;
      clk: in std_logic);
end cpu;

architecture a_cpu of cpu is
  component register16 IS PORT(
    d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- output
  );
  END component;

  component decoder3x8 is
    port(input: in std_logic_vector(2 downto 0);
        enable: in std_logic;
        output: out std_logic_vector(7 downto 0));
  end component;
    
  component tri_state_buffer is
    generic(n: integer := 32);
    port( input: in std_logic_vector(n-1 downto 0);
        enable: in std_logic;
        output: out std_logic_vector(n-1 downto 0));
  end component;
  
  component ram IS
    PORT( clk : IN std_logic;
		  wr: IN std_logic;
		  address : IN  std_logic_vector(11 DOWNTO 0);
		  datain  : IN  std_logic_vector(15 DOWNTO 0);
		  dataout : OUT std_logic_vector(15 DOWNTO 0));
  end component;
  
  signal r0out: std_logic_vector(15 downto 0);
  signal r1out: std_logic_vector(15 downto 0);
  signal r2out: std_logic_vector(15 downto 0);
  signal r3out: std_logic_vector(15 downto 0);
  signal r4out: std_logic_vector(15 downto 0);
  signal r5out: std_logic_vector(15 downto 0);
  signal r6out: std_logic_vector(15 downto 0);
  signal r7out: std_logic_vector(15 downto 0);
  
  signal destout: std_logic_vector(15 downto 0);
  signal sourceout: std_logic_vector(15 downto 0);

  signal mdrout: std_logic_vector(15 downto 0);
  signal mdrin: std_logic_vector(15 downto 0);
  signal mdr_load: std_logic;
  
  signal marout: std_logic_vector(15 downto 0);
  
  signal src_dec: std_logic_vector(7 downto 0);
  signal dst_dec: std_logic_vector(7 downto 0);
  
  signal ram_data_out: std_logic_vector(15 downto 0);
  
  begin
    r0: register16 generic map(n=>16) port map(clk,'0',dst_dec(0),bidir,r0out);
    r1: register16 generic map(n=>16) port map(clk,'0',dst_dec(1),bidir,r1out);
    r2: register16 generic map(n=>16) port map(clk,'0',dst_dec(2),bidir,r2out);
    r3: register16 generic map(n=>16) port map(clk,'0',dst_dec(3),bidir,r3out);
    r4: register16 generic map(n=>16) port map(clk,'0',dst_dec(4),bidir,r4out);
    r5: register16 generic map(n=>16) port map(clk,'0',dst_dec(5),bidir,r5out);
    r6: register16 generic map(n=>16) port map(clk,'0',dst_dec(6),bidir,r6out);
    r7: register16 generic map(n=>16) port map(clk,'0',dst_dec(7),bidir,r7out);
    
    dest: register16 generic map(n=>16) port map(clk,'0',dst_dec(3),bidir,destout);
    source: register16 generic map(n=>16) port map(clk,'0',dst_dec(3),bidir,sourceout);

    mdr: register16 generic map(n=>16) port map(clk,'0',mdr_load,mdrin,mdrout);
    mar: register16 generic map(n=>16) port map(clk,'0',dst_dec(5),bidir,marout);
    
    tri0: tri_state_buffer generic map(n=>16) port map(r0out, src_dec(0), bidir);
    tri1: tri_state_buffer generic map(n=>16) port map(r1out, src_dec(1), bidir);
    tri2: tri_state_buffer generic map(n=>16) port map(r2out, src_dec(2), bidir);
    tri3: tri_state_buffer generic map(n=>16) port map(r3out, src_dec(3), bidir);    
    tri4: tri_state_buffer generic map(n=>16) port map(r4out, src_dec(4), bidir);
    tri5: tri_state_buffer generic map(n=>16) port map(r5out, src_dec(5), bidir);
    tri6: tri_state_buffer generic map(n=>16) port map(r6out, src_dec(6), bidir);
    tri7: tri_state_buffer generic map(n=>16) port map(r7out, src_dec(7), bidir);    
    
    trimdrout: tri_state_buffer generic map(n=>16) port map(mdrout, src_dec(4), bidir);
      
    ram1: ram port map(clk,wr,marout(11 downto 0),mdrout,ram_data_out); 
    
    mdr_load <= rd or dst_dec(4);
    
    mdrin <= ram_data_out when rd = '1'
          else bidir when dst_dec(4) = '1';
    
      
end a_cpu; 