library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x4 is
	port(
		clk    : IN  std_logic;
		selec  : IN  std_logic;
		bus1 	 : IN  std_logic_vector(3 downto 0);   
		bus2 	 : IN  std_logic_vector(3 downto 0);     
		busout : OUT std_logic_vector(3 downto 0)); 
end mux2x4;

architecture Behavioral of mux2x4 is
begin

	process(clk) 
	begin   
		if(clk'EVENT and clk = '1') then   
			case selec is    
				when '0' 	=> busout <= bus1;    
				when '1' 	=> busout <= bus2;    
				when others => null;   
			end case;      
		end if; 
	end process; 
end Behavioral;