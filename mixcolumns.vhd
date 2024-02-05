library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mixcolumns is
	port(
		state40    : IN  std_logic_vector(7 downto 0);  
		state41    : IN  std_logic_vector(7 downto 0);  
		state42    : IN  std_logic_vector(7 downto 0);  
		state43    : IN  std_logic_vector(7 downto 0); 
		stateout40 : OUT std_logic_vector(7 downto 0);
		stateout41 : OUT std_logic_vector(7 downto 0);
		stateout42 : OUT std_logic_vector(7 downto 0);
		stateout43 : OUT std_logic_vector(7 downto 0)); 
end mixcolumns;

architecture Behavioral of mixcolumns is
	component multcolumn  
		port(   
			state0   : IN  std_logic_vector(7 downto 0);
			state1   : IN  std_logic_vector(7 downto 0);   
			state2   : IN  std_logic_vector(7 downto 0);  
			state3   : IN  std_logic_vector(7 downto 0);   
			stateout : OUT std_logic_vector(7 downto 0));  
		end component multcolumn;

begin
 u1: multcolumn
	PORT MAP (state0 => state40, state1 => state41, state2 => state42, state3 => state43,              
				 stateout => stateout40); 
 u2: multcolumn
	PORT MAP (state0 => state41, state1 => state42, state2 => state43, state3 => state40,           
				 stateout => stateout41); 
 u3: multcolumn
	PORT MAP (state0 => state42, state1 => state43, state2 => state40, state3 => state41,  
				 stateout => stateout42); 
 u4: multcolumn
	PORT MAP (state0 => state43, state1 => state40, state2 => state41, state3 => state42, 
		  		 stateout => stateout43); 
end Behavioral;