library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rxnibble is
	port(
		clk       : IN  std_logic; 
		Strobe    : IN  std_logic;  
		reset     : IN  std_logic; 
		enable    : IN  std_logic;
		datain    : IN  std_logic_vector(3 downto 0);  
		ACK   	 : OUT std_logic;
		byteready : OUT std_logic;
		we   		 : OUT std_logic;   
		habil  	 : OUT std_logic;
		setcuenta : OUT std_logic; 
		address   : OUT std_logic_vector(3 downto 0);
		q 		    : OUT std_logic_vector(7 downto 0));
end rxnibble;

architecture Behavioral of rxnibble is
	type estado is (a, b, c, d, e, f, g, h, i, j);  
	signal cnt			: estado := a;  
	signal contador	: integer range 0 to 15;
	signal habilaux 	: std_logic;

begin
 habil <= habilaux;

	process(clk,reset)
	begin 
		if reset = '1' then  
			cnt 		 <= a;     
			--contador  <= 0;     
			--habilaux  <= '0';     
			--setcuenta <= '0'; 
		elsif(clk'event and clk = '1') then    
			case cnt is      
				when a =>       
					cnt <= b; 
				when b =>       
					if Strobe = '1' and enable = '1' then        
						cnt <= c;       
					end if;
				when c =>             
					cnt <= d;      
				when d =>        
					cnt <= e;      
				when e =>       
					if Strobe = '1' and enable = '1' then        
						cnt <= f;       
					end if; 
				when f =>              
					cnt <= g;      
				when g =>        
					cnt <= h; 
				when h =>        
					if habilaux = '0' then        
						cnt <= i;        
					else
						cnt<= j;
					end if;
				when i =>        
					cnt <= a;      
				when j =>        
					cnt <= a; 
			end case;   
		end if;  
	end process;

	process(clk,enable)
	begin 
		if(clk'event and clk = '1') then 
			case cnt is      
				when a =>        
					ACK 			<= '0';       
					byteready 	<= '0';       
					q 				<= "00000000";       
					address 		<= conv_std_logic_vector(contador,4); 
					--setcuenta <= '0';      
				when b =>       
					if Strobe = '1' and enable = '1' then        
						q(7 downto 4) 	<= datain;        
						ACK 				<= '1';  
					end if;
				when c =>                   
				when d =>        
					ACK <= '0'; 
				when e =>       
					if Strobe = '1' and enable = '1' then     
						q(3 downto 0) 	<= datain;        
						ACK 				<= '1';         
					end if;      
				when f =>              
					we <= '1';              
				when g =>        
					ACK 			<= '0';       
					byteready 	<= '1';              
				when h =>
				when i =>        
					we 		<= '0';        
					contador <= contador +1;                
					if contador = 15 then        
						habilaux  <= '1';        
						setcuenta <= '1';        
					end if;         
				when j =>        
					we 		<= '0';        
					contador <= contador +1;              
			end case; 
		end if; 
	end process; 
end Behavioral;