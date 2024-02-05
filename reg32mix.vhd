library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg32mix is
	port(
		byteclk   : IN  std_logic;  
		reg_clk   : IN  std_logic;
		bytein 	 : IN  std_logic_vector(7 downto 0); 
		statemix0 : OUT std_logic_vector(7 downto 0);
		statemix1 : OUT std_logic_vector(7 downto 0);
		statemix2 : OUT std_logic_vector(7 downto 0);
		statemix3 : OUT std_logic_vector(7 downto 0)); 

end reg32mix;

architecture Behavioral of reg32mix is
	component reg32   
		port(   
			byteclk : IN  std_logic; 
			reg_clk : IN  std_logic;
			bytein  : IN  std_logic_vector(7 downto 0);   
			state0  : OUT std_logic_vector(7 downto 0);
			state1  : OUT std_logic_vector(7 downto 0);
			state2  : OUT std_logic_vector(7 downto 0);
			state3  : OUT std_logic_vector(7 downto 0)); 
	end component;
	
	component mixcolumns
		port( 
			state40    : IN  std_logic_vector(7 downto 0);  
			state41    : IN  std_logic_vector(7 downto 0);  
			state42    : IN  std_logic_vector(7 downto 0); 
			state43    : IN  std_logic_vector(7 downto 0);
			stateout40 : OUT std_logic_vector(7 downto 0);
			stateout41 : OUT std_logic_vector(7 downto 0);
			stateout42 : OUT std_logic_vector(7 downto 0);
			stateout43 : OUT std_logic_vector(7 downto 0)); 
	end component;

	signal aux0, aux1, aux2, aux3 : std_logic_vector(7 downto 0);
	
begin
 u1: reg32 
	PORT MAP(
		bytein => bytein,     
		state0 => aux0,     
		state1 => aux1,     
		state2 => aux2,    
		state3 => aux3,    
		byteclk => byteclk,     
		reg_clk => reg_clk); 
 
 u2: mixcolumns
	PORT MAP(
		state40 => aux0,     
		state41 => aux1,    
		state42 => aux2,    
		state43 => aux3,    
		stateout40 => statemix0,    
		stateout41 => statemix1,    
		stateout42 => statemix2,    
		stateout43 => statemix3); 

end Behavioral;