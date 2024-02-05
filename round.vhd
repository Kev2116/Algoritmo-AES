library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity round is
	port(
		clk   		: IN  std_logic; 
		reset  		: IN  std_logic;  
		habil  		: IN  std_logic;
		enable  		: OUT std_logic;  
		startreg  	: OUT std_logic;
		weout  		: OUT std_logic;   
		we   			: OUT std_logic;   
		fin   		: OUT std_logic;
		selecmux2x8 : OUT std_logic;  
		selecmux2x4 : OUT std_logic; 
		selecmux3x8 : OUT std_logic_vector(1 downto 0);  
		ronda 		: OUT std_logic_vector(3 downto 0);
		qbaja  		: OUT std_logic_vector(3 downto 0);
		q   			: OUT std_logic_vector(7 downto 0)); 
end round;

architecture Behavioral of round is
	type estado is (roundini,round1, round10,roundfin);  
	signal cnt								: estado := roundini;  
	signal auxselecmux2x4 				: std_logic; 
	signal auxwe, auxenable, auxfin 	: std_logic; 
	signal auxfinronda1 					: std_logic; 
	signal auxqbaja, auxronda 			: std_logic_vector(3 downto 0); 
	signal auxq 							: std_logic_vector(7 downto 0); 
	signal intronda 						: integer range 0 to 15;

begin
 selecmux2x4 <= auxselecmux2x4; 
 q 			 <= auxq; 
 qbaja		 <= auxqbaja; 
 we 			 <= auxwe; 
 enable 		 <= auxenable;
 fin 			 <= auxfin; 
 ronda 		 <= auxronda;
 
	process(clk, reset)  
	begin   
		if reset = '1' then    
			cnt <= roundini; 
		elsif(clk'event and clk = '1') then     
			case cnt is      
				when roundini =>       
					if habil ='1' then      
						cnt <= round1;        
					end if;
				when round1 =>       
					if(auxfinronda1 = '1' and intronda < 9) then       
						cnt <= round1;              
					elsif(auxfinronda1 = '1' and intronda = 9) then      
						cnt <= round10;       
					end if;
				when round10 => 
					if auxfinronda1 = '1' then 
						cnt <= roundfin;       
					end if;            
				when roundfin => 
					if auxenable = '1' then 
						cnt <= roundini;       
					end if; 
			end case;   
		end if;  
	end process; 			

	process(clk, reset) 
	variable cuenta		: integer range 0 to 255;
	variable address 		: integer range 0 to 255;
	variable addressbaja : integer range 0 to 15;
	begin
		if reset = '1' then		
			auxenable 		<= '1';  
			auxq 				<= "00000000";  
			auxqbaja 		<= "0000";  
			selecmux2x8 	<= '0';  
			selecmux3x8 	<= "00";  
			auxselecmux2x4 <= '0';
			weout 			<= '0';  
			auxwe 			<= '0';  
			startreg 		<= '0';  
			auxfinronda1 	<= '0';  
			cuenta			:= 0;  
			address			:= 0;  
			addressbaja		:= 0; 
		elsif(clk'event and clk = '1') then   
			case cnt is      
				when roundini =>        
					auxenable 		<= '1';       
					selecmux2x8 	<= '0';       
					selecmux3x8 	<= "00";       
					auxselecmux2x4 <= '0';        
					weout 			<= '0';       
					auxwe 			<= '1';       
					startreg 		<= '0';
					auxfinronda1 	<= '0';       
					cuenta			:= 0;       
					address			:= 0;       
					addressbaja		:= 0;       
					auxq 				<= "00000000";       
					auxqbaja 		<= "0000";
				when round1 =>              
					auxenable 		<= '0';       
					selecmux2x8 	<= '1';       
					selecmux3x8 	<= "01";       
					auxselecmux2x4 <= '1';  
					address 			:= address +1;       
					addressbaja 	:= addressbaja +1;       
					auxq				<= conv_std_logic_vector(address,8);       
					auxqbaja			<= conv_std_logic_vector(addressbaja,4); 
					cuenta 			:= cuenta+1; 
					if cuenta<16 then       
						auxwe <= '0';       
					elsif ((cuenta > 29) and (cuenta < 46)) then       
						auxwe <= '1';       
					else 
						auxwe <= '0';       
					end if;
					if((cuenta >2) and (cuenta < 19)) then       
						weout <= '1';       
					else 
						weout <='0';       
					end if; 
					if((cuenta>23) and (cuenta <46)) then       
						startreg <= '1';       
					else
						startreg <= '0';       
					end if;       
					if cuenta = 47 then      
						auxfinronda1  <= '1';        
						cuenta		  := 255;        
						address		  :=0;        
						--addressbaja := 0;       
					else 
						auxfinronda1  <= '0';       
					end if;
					if cuenta = 27 then
						case intronda is 
							when 0 => address := 15;         
							when 1 => address := 31;         
							when 2 => address := 47;         
							when 3 => address := 63;         
							when 4 => address := 79; 
							when 5 => address := 95;         
							when 6 => address := 111;          
							when 7 => address := 127;         
							when 8 => address := 143;         
							when others =>              
						end case;      
					end if; 
					when round10 =>       
						auxenable 		<= '0';       
						selecmux2x8 	<= '1';       
						auxselecmux2x4 <= '1';        
						address 			:= address+1;       
						addressbaja 	:= addressbaja+1;       
						auxq				<= conv_std_logic_vector(address,8);       
						auxqbaja			<= conv_std_logic_vector(addressbaja,4); 
						cuenta 			:= cuenta+1; 
						if cuenta < 16 then     
							auxwe <= '0';       
						elsif((cuenta > 20) and (cuenta < 37)) then      
							auxwe <= '1';       
						else 
							auxwe <= '0';       
						end if; 
						if cuenta = 19 then      
							addressbaja:=15;       
						end if;
						if((cuenta >2) and (cuenta < 19)) then     
							weout <= '1';       
						else
							weout <='0';       
						end if;  
						if(cuenta > 19) then       
							selecmux3x8 <= "10";       
						else
							selecmux3x8 <= "01";       
						end if; 
						if cuenta = 37 then       
							auxfinronda1 <= '1';       
							cuenta		 := 255;       
						else
							auxfinronda1 <= '0';       
						end if; 
						if cuenta = 18 then       
							address := 159;        
						end if; 
					when roundfin => 
						if cuenta = 16 then        
							--auxenable <= '1';       
							auxfin		<= '1';       
						end if; 
							--address 		:= address+1;       
							--addressbaja 	:= addressbaja+1;       
							--auxq			<= conv_std_logic_vector(address,8);       
							--auxqbaja		<= conv_std_logic_vector(addressbaja,4);                    
							--cuenta 		:= cuenta+1; 
			end case;       
		end if; 
	end process; 
						
	process(clk) 
	variable sum: integer range 0 to 15;
	begin 
		if(clk'event and clk = '1') then   
			if(auxfinronda1='1') then   
				sum:=sum+1;   
				intronda <= sum;        
				auxronda <= conv_std_logic_vector(conv_integer(sum), 4);   
			end if;  
		end if; 
	end process; 				
end Behavioral;
