library ieee;
use ieee.std_logic_1164.all;

entity sub_layer_ctrl is
  port (
    enable               : in  std_logic;
    path_in              : in  std_logic;
    layer_in             : in  std_logic_vector(1 downto 0);
    layer_out            : out std_logic_vector(1 downto 0);
    path_out             : out std_logic);
end entity sub_layer_ctrl;

architecture behavioiral of sub_layer_ctrl is

begin  -- architecture behavioiral

  ctrl: process (enable,layer_in,layer_hits_left) is
  begin  -- process ctrl
    layer_hits_left <= '0';
    if enable = '1' then
      case layer_in is
        when "00" => layer_out <= "01";
        when "01" => layer_out <= "10";
        when "10" => layer_out <= "11";
        when "11" => layer_out <= "00";
        when others => null;
      end case;
    else
      layer_out <= "00";
    end if;
  end process ctrl;
  
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
