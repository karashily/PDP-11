library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_store is 
  port (
    address: in std_logic_vector (4 downto 0);
    output: out std_logic_vector (24 downto 0)
  );
end control_store;

architecture rom of control_store is

 
constant address_0: std_logic_vector (24 downto 0) := "0000000011000001010000001";
constant address_1: std_logic_vector (24 downto 0) := "0000100011100000000000000";
constant address_2: std_logic_vector (24 downto 0) := "0001100000011100100101000";
constant address_3: std_logic_vector (24 downto 0) := "0001100101000000000010111";
constant address_4: std_logic_vector (24 downto 0) := "0010001000000000000000000";
constant address_5: std_logic_vector (24 downto 0) := "1010000001010100101010000";
constant address_6: std_logic_vector (24 downto 0) := "1010100000010100101100000";
constant address_7: std_logic_vector (24 downto 0) := "0011101101000100000010101";
constant address_10: std_logic_vector (24 downto 0) := "0101100001010100000010000";
constant address_11: std_logic_vector (24 downto 0) := "0100110000000001110100010";
constant address_12: std_logic_vector (24 downto 0) := "0100000000010000000000110";
constant address_13: std_logic_vector (24 downto 0) := "0101110100010000000000110";
constant address_14: std_logic_vector (24 downto 0) := "0110100000000010000000101";
constant address_15: std_logic_vector (24 downto 0) := "0111000010100000100101000";
constant address_16: std_logic_vector (24 downto 0) := "0111100000000010100000111";
constant address_17: std_logic_vector (24 downto 0) := "0011100000100000011100000";
constant address_20: std_logic_vector (24 downto 0) := "1000011000001100100001011";
constant address_21: std_logic_vector (24 downto 0) := "1000000000000010000000100";
constant address_22: std_logic_vector (24 downto 0) := "0111100000000011111000111";
constant address_23: std_logic_vector (24 downto 0) := "0111100001100000011011111";
constant address_24: std_logic_vector (24 downto 0) := "1010000100011000000000111";
constant address_25: std_logic_vector (24 downto 0) := "1010100101011000000010111";
constant address_26: std_logic_vector (24 downto 0) := "0001000000001010000000110";
constant address_27: std_logic_vector (24 downto 0) := "1011111110001000000000110";

type rom_array is array (natural range <>) of std_logic_vector (24 downto 0);
constant rom: rom_array := (
address_0, address_1, address_2, address_3, address_4, address_5, 
address_6, address_7, address_10, address_11, address_12, address_13, 
address_14, address_15, address_16, address_17, address_20, address_21, 
address_22, address_23, address_24, address_25, address_26, address_27
);

begin
  process(address)
    variable index : integer;
    variable b0_2 : integer;
    variable b3_4 : integer;
    begin
      b0_2 :=conv_integer(address(2 downto 0));
      b3_4 :=conv_integer(address(4 downto 3));
      index := b3_4 * 7 + b3_4 + b0_2;
      output <= rom(index);
    end process;
  end rom; 
