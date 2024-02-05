library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram16x8 is
	port(
      clk 	: in std_logic;
      we   	: in std_logic;
      address  	: in std_logic_vector(3 downto 0);
      data    	: in std_logic_vector(7 downto 0);
      do 	: out std_logic_vector(7 downto 0));
end ram16x8;

architecture Behavioral of ram16x8 is
	type ram_type is array(15 downto 0) of std_logic_vector(7 downto 0);
	signal RAM: ram_type;

begin
	process (clk)
   begin
		if clk'event and clk = '1' then
			if we = '1' then
				RAM(conv_integer(address)) <= data;
         end if;
         do <= RAM(conv_integer(address));
         end if;
	end process;
end Behavioral;