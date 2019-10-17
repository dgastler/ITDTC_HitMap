library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.types.all;

entity HitMapDecoder is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;
    bitstream    : in  std_logic_vector(5 downto 0));
end entity HitMapDecoder;

architecture behavioiral of HitMapDecoder is

  signal bs_map              : slv2_array_t(0 to bitstream'length -1);
  signal bs_is_short_message : std_logic_vector(0 to bitstream'length-1);
  signal bs_enable           : std_logic_vector(0 to bitstream'length-1);
  
begin  -- architecture behavioiral

  decoders: for iBit in 0 to bitstream'length - 2 generate

    bs_enable_proc: process (bs_enable,bitstream) is
    begin  -- process bs_enable_proc
      bs_enable(iBit) <= '0';
      if iBit = 0 then
        bs_enable(iBit) <= not reset;
      elsif iBit = 1 then
        if bs_enable(iBit-1) = '0' then
          bs_enable(iBit) <= '1';
        elsif bs_is_short_message(iBit-1) = '1' then
          bs_enable(iBit) <= '1';
        end if;
      else
        if bs_enable(iBit-2) = '1' then
          
        end if;
        if bs_enable(iBit-1) = '1' then
          
        end if;

      end if;
    end process bs_enable_proc;
    
    sub_layer_1: entity work.sublayer
      port map (
        enable               => layer2_enable(iBit),
        bitstream            => bitstream(iBit+1 downto iBit),
        next_pos_is_last_bit => layer2_next_is_last(iBit),
        hit_count            => layer2_map(iBit));
    sub_layer_ctrl_1: entity work.sub_layer_ctrl
      port map (
        enable    => layer2_enable(iBit),
        layer_in  => layer2_layer_in,
        layer_out => layer2_layer_out);
  end generate decoders;  
  
  
end architecture behavioiral;

