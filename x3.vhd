use IEEE.STD_LOGIC_1164.ALL;

entity x3 is
	port(
		inx3  : IN  std_logic_vector(7 downto 0); 
		outx3 : OUT std_logic_vector(7 downto 0)); 
end x3;

architecture Behavioral of x3 is
	signal aux: std_logic_vector(7 downto 0);
	
begin

	process (inx3) 
	begin
		if inx3(7) = '0' then            
			aux <= inx3 (6 downto 0) & '0';    
		else            
			aux <= inx3(6 downto 0) & '0' xor "00011011" ;       
		end if; 
	end process;  
	
outx3 <= aux xor inx3;

end Behavioral;
