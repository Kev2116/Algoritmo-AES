library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg32parser is
	port(
		byteclk  : IN  std_logic;
		wordclk  : IN  std_logic;
		startreg : IN  std_logic; 
		wordin   : IN  std_logic_vector(31 downto 0);
		byteout  : OUT std_logic_vector(7 downto 0));
end reg32parser;

architecture Behavioral of reg32parser is
	component reg8  
		port(   
			clk : IN  std_logic; 
			d   : IN  std_logic_vector(7 downto 0); 
			q   : OUT std_logic_vector(7 downto 0));
		end component;
 
	signal aux0, aux1, aux2, aux3 : std_logic_vector(7 downto 0); 
	
begin
 u1: reg8 
	PORT MAP (d => wordin(31 downto 24), q => aux0, clk => wordclk); 
 
 u2: reg8 
	PORT MAP (d => wordin(23 downto 16), q => aux1, clk => wordclk); 

 u3: reg8 
	PORT MAP (d => wordin(15 downto 8), q => aux2, clk => wordclk); 
 
 u4: reg8 
	PORT MAP (d => wordin(7 downto 0), q => aux3, clk => wordclk); 

	process(byteclk, wordclk, startreg)  
		variable index: integer range 0 to 3;  
	begin 
		if startreg = '0' then 
			index :=0;     
		else 
		if(byteclk'event and byteclk = '1') then
			case index is     
				when 0 =>         
					byteout <= aux0;     
				when 1 =>        
					byteout <= aux1;    
				when 2 =>        
					byteout <= aux2;   
				when 3 =>        
					byteout <= aux3;    
			end case; 
		index := index + 1;
		end if; 
	end if; 
	end process;
end Behavioral;