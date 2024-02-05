library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ramkey is
	port(
	clk   : IN  std_logic;
      we      : IN  std_logic;
      address : IN  std_logic_vector(7 downto 0);
      data    : IN  std_logic_vector(7 downto 0);
      do      : OUT std_logic_vector(7 downto 0));
end ramkey;

architecture Behavioral of ramkey is
	 type ram_type is array(255 downto 0) of std_logic_vector(7 downto 0);
    signal RAM: ram_type;

begin

	process(clk)
	begin
		if clk'event and clk = '1' then
			if WE = '1' then
				RAM(conv_integer(address)) <= data;
         end if;
			do <= RAM(conv_integer(address)) ;
			end if;
    end process;
end Behavioral;