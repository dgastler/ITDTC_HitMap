library ieee;
use ieee.std_logic_1164.all;

entity sublayer is
  port (
    enable               : in  std_logic;
    bitstream            : in  std_logic_vector(1 downto 0);
    next_pos_is_last_bit : out std_logic;
    hit_count            : out std_logic_vector(1 downto 0));
end entity sublayer;

architecture behavioiral of sublayer is

begin  -- architecture behavioiral

  bit_parser: process (enable,bitstream) is
  begin  -- process bit_parser
    if enable = '1' then
      case bitstream is
        when "00" =>
          hit_count <= "10";
          next_pos_is_last_bit <= '1';
        when "10" =>
          hit_count <= "10";
          next_pos_is_last_bit <= '1';
        when "01" =>
          hit_count <= "01";
          next_pos_is_last_bit <= '0';
        when "11" =>
          hit_count <= "11";
          next_pos_is_last_bit <= '0';
        when others => null;
      end case;
    else
      hit_count <= "00";
      next_pos_is_last_bit <= '0'; --?
    end if;
  end process bit_parser;

  
end architecture behavioiral;
