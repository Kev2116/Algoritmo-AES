library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wordclk is
	port(
		byteclk 	: IN  std_logic;   
		start   : IN  std_logic;  
		gen_clk : OUT std_logic); 
end wordclk;

architecture Behavioral of wordclk is
	signal aux : std_logic;
	
begin
	process(byteclk, start)  
	variable cnt : integer range 0 to 3;  
	begin	
		if start = '0' then
			cnt :=0;    
			aux <= '0';  
		else     
			if (byteclk'event and byteclk = '1') then     
				if start = '1' then    
					cnt := cnt + 1;  
				else 
					cnt :=0;     
				end if;   
			end if;
		if (cnt=0 ) then   
			aux <= '1';    
		else    
			aux <= '0';   
		end if; 
		end if; 
	end process;
 gen_clk<=aux and (not byteclk); 
end Behavioral;