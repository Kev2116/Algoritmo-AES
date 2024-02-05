library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg32mix8x8 is
	port(
		byteclk  : IN  std_logic; 
		startreg : IN  std_logic;
		bytein   : IN  std_logic_vector(7 downto 0);
		byteout  : OUT std_logic_vector(7 downto 0));
end reg32mix8x8;

architecture Behavioral of reg32mix8x8 is

	component reg32mix   
		port(   
			byteclk 	 : IN  std_logic;
			reg_clk 	 : IN  std_logic;
			bytein 	 : IN  std_logic_vector(7 downto 0);
			statemix0 : OUT std_logic_vector(7 downto 0);
			statemix1 : OUT std_logic_vector(7 downto 0);
			statemix2 : OUT std_logic_vector(7 downto 0);
			statemix3 : OUT std_logic_vector(7 downto 0));
	end component; 

	component reg32parser   
		port(   
			byteclk  : IN  std_logic; 
			wordclk  : IN  std_logic;
			startreg : IN  std_logic; 
			wordin 	: IN  std_logic_vector(31 downto 0);  
			byteout 	: OUT std_logic_vector(7 downto 0)); 
	end component; 
	
	component wordclk   
		port(  
			byteclk : IN  std_logic;
			start   : IN  std_logic;
			gen_clk : OUT std_logic);
	end component;
	
	signal aux0, aux1, aux2, aux3 : std_logic_vector(7 downto 0);
	signal aux4 : std_logic;
	
begin
 u1: reg32mix 
	PORT MAP( bytein => bytein, statemix0 => aux0, statemix1 => aux1, statemix2 => aux2,     
				 statemix3 => aux3, byteclk => byteclk, reg_clk => aux4); 
				 
 u2: reg32parser 
	PORT MAP( wordin(31 downto 24) => aux0, wordin(23 downto 16) => aux1,    
				 wordin(15 downto  8) => aux2, wordin( 7 downto  0) => aux3,   
				 byteclk => byteclk, wordclk => aux4, byteout => byteout,
				 startreg => startreg); 
				 
u3: wordclk  
	PORT MAP( byteclk => byteclk, start => startreg, gen_clk => aux4); 
end Behavioral;