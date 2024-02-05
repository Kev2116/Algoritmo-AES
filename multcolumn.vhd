library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multcolumn is
	port(
		state0   : IN  std_logic_vector(7 downto 0);    
		state1   : IN  std_logic_vector(7 downto 0);    
		state2   : IN  std_logic_vector(7 downto 0);   
		state3   : IN  std_logic_vector(7 downto 0);   
		stateout : OUT std_logic_vector(7 downto 0)); 
end multcolumn;

architecture Behavioral of multcolumn is
	component xtime  
		port(    
			inxtime  : IN  std_logic_vector(7 downto 0);  
			outxtime : OUT std_logic_vector(7 downto 0)); 
	end component xtime; 
 
	component x3  
		port(    
			inx3  : IN  std_logic_vector(7 downto 0);    
			outx3 : OUT std_logic_vector(7 downto 0)); 
	end component x3; 

	signal aux0: std_logic_vector(7 downto 0);  
	signal aux1: std_logic_vector(7 downto 0); 
	signal aux2: std_logic_vector(7 downto 0); 
	signal aux3: std_logic_vector(7 downto 0); 

begin
 u1: xtime         
	PORT MAP (inxtime => state0, outxtime => aux0);   
			
 u2: x3        
	PORT MAP (inx3 => state1, outx3 => aux1); 
 
	aux2 		<= aux0 xor aux1;  
	aux3 		<= state2 xor state3;  
	stateout <= aux2 xor aux3; 
end Behavioral;