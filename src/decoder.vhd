library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity HitMapDecoder is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;
    bitstream    : in  std_logic_vector(5 downto 0));
end entity HitMapDecoder;

architecture behavioiral of HitMapDecoder is

  component sublayer is
    port (
      enable               : in  std_logic;
      bitstream            : in  std_logic_vector(1 downto 0);
      next_pos_is_last_bit : out std_logic;
      hit_count            : out std_logic_vector(1 downto 0));
  end component sublayer;

  signal layer1_map : std_logic_vector(1 downto 0);
  signal layer1_next_is_last : std_logic;

  signal layer2_map : std_logic_vector(10 downto 0) := (others => '0');
  signal layer2_enable : std_logic_vector(4 downto 0);
  signal layer2_next_is_last : std_logic_vector(4 downto 1);

  signal enable : std_logic;
begin  -- architecture behavioiral

  enable <= not reset;
  primary: entity work.sublayer
    port map (
      enable               => enable,
      bitstream            => bitstream(1 downto 0),
      next_pos_is_last_bit => layer1_next_is_last,
      hit_count            => layer1_map(1 downto 0));

--    layer2_enable(1) <= not next_pos_is_last_bit;
--    layer2_enable(2) <= not layer2_enable(1);
--    layer2_enable(3) <= layer2_enable(2) and not 

  layer2_enable(0) <= or_reduce(layer1_map); -- is there anything valid? 
  decoders_layer2: for iBit in 1 to 5-1 generate

    --propogate the count left to decode?
    
    sublayer_en: process (layer1_next_is_last,layer1_map,layer2_enable,bitstream) is
    begin  -- process sublayer_en
      if iBit = 1 then
        layer2_enable(iBit) <= layer1_next_is_last;
      elsif iBit = 2 then
        layer2_enable(iBit) <= not layer1_next_is_last; 
      else
        if ( (layer2_enable(iBit-1) = '1' and bitstream(iBit-1) = '0') or --previous decoder enabled, but is length 0
             (layer2_enable(iBit-1) = '0' and layer2_enable(iBit-2) = '1') --previous decoder wasn't enabled
             ) then
          if layer1_map = "11" then
            layer2_enable(iBit) <= '1';
          else
            layer2_enable(iBit) <= '0';
          end if;          
        else
          layer2_enable(iBit) <= '0';
        end if;
      end if;
    end process sublayer_en;

    sublayer_1: entity work.sublayer
      port map (
        enable               => layer2_enable(iBit),
        bitstream            => bitstream(iBit+1 downto iBit),
        next_pos_is_last_bit => layer2_next_is_last(iBit),
        hit_count            => layer2_map((2*iBit) +1 downto (2*iBit)));
  end generate decoders_layer2;  
  
end architecture behavioiral;

