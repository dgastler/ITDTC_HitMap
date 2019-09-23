library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_hitmap is
  port (
    clk : in std_logic
    );
end entity tb_hitmap;

architecture behavioiral of tb_hitmap is

  signal counter : integer := 0;
  type slv6_array_t is array (integer range <>) of std_logic_vector(5 downto 0);
  constant bitstream : slv6_array_t(0 to 14) := ("00"&"0101",   -- 000X
                                                 "000"&"001",   -- 00X0
                                                 "00"&"1101",   -- 00XX
                                                 "000"&"010",   -- 0X00
                                                 "010111",      -- 0X0X
                                                 "0"&"01011",   -- 0XX0
                                                 "011111",      -- 0XXX
                                                 "0000"&"00",   -- X000
                                                 "0"&"00111",   -- X00X
                                                 "00"&"0011",   -- X0X0
                                                 "0"&"01111",   -- X0XX
                                                 "000"&"110",   -- XX00
                                                 "110111",      -- XX0X
                                                 "0"&"11011",   -- XXX0
                                                 "111111"       -- XXXX
                                                 );
  type int_array_t is array (integer range <>) of integer;
  constant hit_count : int_array_t(0 to 14) := (1,
                                                1,
                                                2,
                                                1,
                                                2,
                                                2,
                                                3,
                                                1,
                                                2,
                                                2,
                                                3,
                                                2,
                                                3,
                                                3,
                                                4                                                 
                                                );
  signal hc : integer;
  
  
  signal bs : std_logic_vector(5 downto 0);
  signal reset : std_logic;
  begin  -- architecture behavioiral

    HitMapDecoder_1: entity work.HitMapDecoder
      port map (
        clk          => clk,
        reset        => reset,
        bitstream    => bs);
    tb: process (clk) is
    begin  -- process tb
      if clk'event and clk = '1' then  -- rising clock edge
        bs <= "000000";
        hc <= 0;
        case counter is
          when 0 => reset <= '1';
          when 1 => reset <= '0';
          when 2 to 17 =>
            bs <= bitstream(counter-2);
            hc <= hit_count(counter-2);
          when others => null;
        end case;
        counter <= counter + 1;
      end if;
    end process tb;
  end architecture behavioiral;
