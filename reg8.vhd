library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8 is
	port(
		d 	 : IN  std_logic_vector(7 downto 0);
		clk : IN  std_logic;
		q 	 : OUT std_logic_vector(7 downto 0));
end reg8;

architecture Behavioral of reg8 is
begin

	process
		begin 
		wait until clk = '1';
		q <= d;
	end process;
end Behavioral;
