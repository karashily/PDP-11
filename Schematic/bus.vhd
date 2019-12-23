library ieee;
use ieee.std_logic_1164.all;

entity cpu is
  port(bidir: INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      src_sel: in std_logic_vector(2 downto 0);
      dst_sel: in std_logic_vector(2 downto 0);
      src_enable: in std_logic;
      dst_enable: in std_logic;
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
	PORT(
		clk : IN std_logic;
		wr  : IN std_logic;
		address : IN  std_logic_vector(11 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
  END component;

  component circ is
    port(
        ir: in std_logic_vector(15 downto 0);
        flags : in std_logic_vector(15 downto 0);
        --enable: in std_logic;
        clk: in std_logic;
        s1,s3,s4,s5,s6,s7 :out std_logic_vector(7 downto 0);
        s2 :out std_logic_vector(3 downto 0)
    );
  end component;

  component src_dst_dec is
    port(input: in std_logic;
        status: in std_logic_vector(1 downto 0);
        srcout: out std_logic;
        dstout: out std_logic);
  end component;

  component setFlag is
    port(
        flagsin:in STD_LOGIC_VECTOR(15 downto 0);
        setflag00,setflag01,setflag10,setflag11: in std_logic;
        flagsout:out STD_LOGIC_VECTOR(15 downto 0)
    );
  end component;
  
  component ALU is
    port (A, B             :       in std_logic_vector (15 downto 0);
          F                :       out std_logic_vector (15 downto 0);
          NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B : in std_logic;
          Cin, ZFin        :       in std_logic;
          Cout, ZFout      :       out std_logic);
  end component;

  component operation is
    port(
    ir: in STD_LOGIC_VECTOR(15 downto 0);
    en : in std_logic;
    NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B : out std_logic
    );
  end component;

  component incrementor is
    port (inp       :   in std_logic_vector (15 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (15 downto 0));
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

  signal irout: std_logic_vector(15 downto 0);
  
  signal flagout: std_logic_vector(15 downto 0) := "0000000000000000";
  signal flagin: std_logic_vector(15 downto 0) := "0000000000000000";

  signal src_dec: std_logic_vector(7 downto 0);
  signal dst_dec: std_logic_vector(7 downto 0);
  
  signal ram_data_out: std_logic_vector(15 downto 0);
  
  signal wr: std_logic;
  signal rd: std_logic;

  signal s1,s3,s4,s5,s6,s7: std_logic_vector(7 downto 0);
  signal s2 : std_logic_vector(3 downto 0);

  -- outputs of src/dst decoders
  signal source_out_temp: std_logic;
  signal source_in_temp: std_logic;

  signal dest_out_temp: std_logic;
  signal dest_in_temp: std_logic;
  
  signal Rsrc_out_temp: std_logic;
  signal Rsrc_in_temp: std_logic;
  
  signal Rdst_out_temp: std_logic;
  signal Rdst_in_temp: std_logic;

  -- Tri-states enables
  signal source_out: std_logic;
  signal source_in: std_logic;

  signal dest_out: std_logic;
  signal dest_in: std_logic;

  signal Rsrc_out: std_logic;
  signal Rsrc_in: std_logic;

  signal Rdst_out: std_logic;
  signal Rdst_in: std_logic;

  signal setflagout: std_logic_vector(15 downto 0) := "0000000000000000";
  signal AluCFout: std_logic := '0';
  signal AluZFout: std_logic := '0';

  signal Rsrc_out_dec_out: std_logic_vector(7 downto 0);
  signal Rsrc_in_dec_out: std_logic_vector(7 downto 0);

  signal Rdst_out_dec_out: std_logic_vector(7 downto 0);
  signal Rdst_in_dec_out: std_logic_vector(7 downto 0);

  signal reg_tri_enable: std_logic_vector(7 downto 0);
  signal reg_load: std_logic_vector(7 downto 0);

  --
  signal PCenable: std_logic_vector(7 downto 0);
  --

  signal AluB: std_logic_vector(15 downto 0);

  signal zout: std_logic_vector(15 downto 0);
  signal yout: std_logic_vector(15 downto 0);

  signal zin: std_logic_vector(15 downto 0);

  -- operation signals
  signal NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B: std_logic;

  signal AluAdd, AluIncA, AluDecA: std_logic;

  signal PCin: std_logic_vector(15 downto 0);
  signal PCincOut: std_logic_vector(15 downto 0);

  signal PCload: std_logic;

  signal offset: std_logic_vector(15 downto 0);

  begin
    -- registers
    r0: register16 port map(bidir,reg_load(0),'0',clk,r0out);
    r1: register16 port map(bidir,reg_load(1),'0',clk,r1out);
    r2: register16 port map(bidir,reg_load(2),'0',clk,r2out);
    r3: register16 port map(bidir,reg_load(3),'0',clk,r3out);
    r4: register16 port map(bidir,reg_load(4),'0',clk,r4out);
    r5: register16 port map(bidir,reg_load(5),'0',clk,r5out);
    r6: register16 port map(bidir,reg_load(6),'0',clk,r6out);
    r7: register16 port map(PCin,PCload,'0',clk,r7out);

    PCload <= reg_load(7) or s5(2);

    PCin <= bidir when reg_load(7) = '1'
      else PCincOut when s5(2) = '1';

    PCinc: incrementor port map(r7out, s5(1), PCincOut);

    dest: register16 port map(bidir, dest_in, '0', clk, destout);
    source: register16 port map(bidir, source_in, '0', clk, sourceout);

    ir: register16 port map(bidir,s6(4),'0',clk,irout);

    flag: register16 port map(flagin,'1','0',clk,flagout);

    --change
    --mdr: register16 port map(mdrin,mdr_load,'0',clk,mdrout);
    mar: register16 port map(bidir,s6(2),'0',clk,marout);

    -- ALU temp registers
    y: register16 port map(bidir,s4(4),'0',clk,yout);
    z: register16 port map(Zin,s4(1),'0',clk,zout);

    triy: tri_state_buffer generic map(n=>16) port map(yout, s2(1), AluB);
    triz: tri_state_buffer generic map(n=>16) port map(zout, s1(7), bidir);

    --
    AluAdd <= ADDD or s3(1);
    AluIncA <= IncA or s3(2);
    AluDecA <= DecA or s3(3);

    -- ALU
    aluentity: ALU port map (bidir, AluB, Zin, NopA,AluAdd,ADC,SUB,SBC,ANDD,ORR,XNORR,AluIncA,AluDecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B, flagout(1), flagout(0), AluCFout, AluZFout);

    -- Set Flag
    flagset: setFlag port map (flagout, s6(1), s3(4), s3(5), s3(6), setflagout);
    flagin(0) <= AluZFout;
    flagin(1) <= AluCFout;
    flagin(15 downto 2) <= setflagout(15 downto 2);

    -- operation selector
    opsel: operation port map(irout,s5(3),NopA,ADDD,ADC,SUB,SBC,ANDD,ORR,XNORR,IncA,DecA,Clear,NotA,LSR_B,ROR_B,RRC_B,ASR_B,LSL_B,ROL_B,RLC_B);
  
    -- Rsrc/dst and SOURCE/DEST decoders that uses status flag
    Rsrcdstout: src_dst_dec port map(s5(7), flagout(3 downto 2), Rsrc_out_temp, Rdst_out_temp);
    Rsrcdstin: src_dst_dec port map(s5(6), flagout(3 downto 2), Rsrc_in_temp, Rdst_in_temp);
    SourceDestout: src_dst_dec port map(s5(5), flagout(3 downto 2), source_out_temp, dest_out_temp);
    SourceDestin: src_dst_dec port map(s5(4), flagout(3 downto 2), source_in_temp, dest_in_temp);


    -- final enables of the SOURCE and DEST registers
    source_out <= source_out_temp or s1(3);
    source_in <= source_in_temp or s4(2);
    
    dest_out <= dest_out_temp or s1(4);
    dest_in <= dest_in_temp or s4(3);
    
    -- final enables of the decoders of general purpose registers 
    Rsrc_out <= Rsrc_out_temp or s1(1);
    Rsrc_in <= Rsrc_in_temp or s4(6);
    
    Rdst_out <= Rdst_out_temp or s1(2);
    Rdst_in <= Rdst_in_temp or s4(7);

    -- Registers enables
    Rsrc_out_dec: decoder3x8 port map (irout(8 downto 6), Rsrc_out, Rsrc_out_dec_out);
    Rsrc_in_dec: decoder3x8 port map (irout(8 downto 6), Rsrc_in, Rsrc_in_dec_out);

    Rdst_out_dec: decoder3x8 port map (irout(2 downto 0), Rdst_out, Rdst_out_dec_out);
    Rdst_in_dec: decoder3x8 port map (irout(2 downto 0), Rdst_in, Rdst_in_dec_out);

    -- final enables of each general purpose registers
    PCenable(6 downto 0) <= "0000000";
    PCenable(7) <= s1(5);
    reg_tri_enable <= Rsrc_out_dec_out or Rdst_out_dec_out or PCenable;
    reg_load <= Rsrc_in_dec_out or Rdst_in_dec_out;

    -- tri-states
    tri0: tri_state_buffer generic map(n=>16) port map(r0out, reg_tri_enable(0), bidir);
    tri1: tri_state_buffer generic map(n=>16) port map(r1out, reg_tri_enable(1), bidir);
    tri2: tri_state_buffer generic map(n=>16) port map(r2out, reg_tri_enable(2), bidir);
    tri3: tri_state_buffer generic map(n=>16) port map(r3out, reg_tri_enable(3), bidir);    
    tri4: tri_state_buffer generic map(n=>16) port map(r4out, reg_tri_enable(4), bidir);
    tri5: tri_state_buffer generic map(n=>16) port map(r5out, reg_tri_enable(5), bidir);
    tri6: tri_state_buffer generic map(n=>16) port map(r6out, reg_tri_enable(6), bidir);
    tri7: tri_state_buffer generic map(n=>16) port map(r7out, reg_tri_enable(7), bidir);    
    
    tridest: tri_state_buffer generic map(n=>16) port map(destout, dest_out, bidir);
    trisource: tri_state_buffer generic map(n=>16) port map(sourceout, source_out, bidir);

    trimdrout: tri_state_buffer generic map(n=>16) port map(mdrout, s1(6), bidir);
    
    
    -- offset out in case of branching
    offset <= "000000"&irout(9 downto 0);
    trioffset: tri_state_buffer generic map(n=>16) port map(offset, s6(5), bidir);


    -- ram
    ram1: ram port map(clk, wr, marout(11 downto 0), mdrout, ram_data_out); 
    
    mdr_load <= rd or s6(3);
    
    wr <= s2(3);
    rd <= s2(2);

    --change
    mdrout <= ram_data_out when rd = '1'
          else bidir when s6(3) = '1';
    mdrin <= ram_data_out when rd = '1'
          else bidir when s6(3) = '1';
    
    dec_cir: circ port map (irout, flagout, clk, s1, s3, s4, s5, s6, s7, s2);

end a_cpu; 
