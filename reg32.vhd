library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg32 is
	port(
		byteclk : IN  std_logic;  
		reg_clk : IN  std_logic; 
		bytein  : IN  std_logic_vector(7 downto 0);    
		state0  : OUT std_logic_vector(7 downto 0);
		state1  : OUT std_logic_vector(7 downto 0);
		state2  : OUT std_logic_vector(7 downto 0);
		state3  : OUT std_logic_vector(7 downto 0)); 
end reg32;

architecture Behavioral of reg32 is
	component reg8   
		port(   
			d   : IN  std_logic_vector(7 downto 0);  
			clk : IN  std_logic;   
			q   : OUT std_logic_vector(7 downto 0));
	end component; 
	
	signal aux0 : std_logic_vector(7 downto 0);
	signal aux1 : std_logic_vector(7 downto 0);
	signal aux2 : std_logic_vector(7 downto 0);
	signal aux3 : std_logic_vector(7 downto 0);
	signal aux4 : std_logic;
	
begin

 u1: reg8 
	PORT MAP (d => bytein, q => aux0, clk => byteclk); 
 u2: reg8 
	PORT MAP (d => aux0, q => aux1, clk => byteclk); 
 u3: reg8 
	PORT MAP (d => aux1, q => aux2, clk => byteclk);
 u4: reg8 
	PORT MAP (d => aux2, q => aux3, clk => byteclk); 
 
	process(reg_clk)
	begin    
		if (reg_clk'event and reg_clk = '1') then
			state0 <= aux3;  
			state1 <= aux2;  
			state2 <= aux1;   
			state3 <= aux0; 
		end if;
	end process; 
end Behavioral;