library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux3x8 is
	port(
		clk 	 : IN  std_logic; 
		selec  : IN  std_logic_vector(1 downto 0);
		bus0 	 : IN  std_logic_vector(7 downto 0);  
		bus1 	 : IN  std_logic_vector(7 downto 0);    
		bus2 	 : IN  std_logic_vector(7 downto 0);       
		busout : OUT std_logic_vector(7 downto 0));
end mux3x8;

architecture Behavioral of mux3x8 is
begin

	process(clk) 
	begin    
		if(clk'EVENT and clk = '1') then   
			case selec is    
				when "00" 	=> busout <= bus0;    
				when "01" 	=> busout <= bus1;    
				when "10" 	=> busout <= bus2;    
				when others => null;   
			end case;       
		end if; 
	end process; 
end Behavioral;