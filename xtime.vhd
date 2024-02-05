library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xtime is
	port(
		inxtime  : IN  std_logic_vector(7 downto 0);   
		outxtime : OUT std_logic_vector(7 downto 0)); 
end xtime;

architecture Behavioral of xtime is
begin

	process (inxtime)   
	begin  
		if inxtime(7)= '0' then             
			outxtime <= inxtime(6 downto 0) & '0';    
		else            
			outxtime <= inxtime(6 downto 0) & '0' xor "00011011";       
		end if;
	end process;
end Behavioral;
