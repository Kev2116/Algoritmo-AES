library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity encrip is
	port(
		clk   			  : IN  std_logic;   
		Strobe           : IN  std_logic; 
		reset  			  : IN  std_logic; 
		datain  			  : IN  std_logic_vector(3 downto 0); 
		data  			  : IN  std_logic_vector(7 downto 0);  
		setcuenta 		  : OUT std_logic; 
		monitorweout 	  : OUT std_logic; 
		ACK   			  : OUT std_logic; 
		monitorb 		  : OUT std_logic;   
		monitorc 		  : OUT std_logic;  
		byteready 	     : OUT std_logic; 
		monitorstartreg  : OUT std_logic; 
		ronda 			  : OUT std_logic_vector(3 downto 0);
		addressram 	     : OUT std_logic_vector(3 downto 0);
		monitoraux1a	  : OUT std_logic_vector(3 downto 0); 
		monitorauxkey	  : OUT std_logic_vector(3 downto 0);
		exorout  		  : OUT std_logic_vector(7 downto 0); 
		monitoraux4 	  : OUT std_logic_vector(7 downto 0); 
		monitoraux8 	  : OUT std_logic_vector(7 downto 0); 
		monitora 		  : OUT std_logic_vector(7 downto 0);   
		monitorauxramout : OUT std_logic_vector(7 downto 0); 
		monitorauxrom 	  : OUT std_logic_vector(7 downto 0);   
		monitordata 	  : OUT std_logic_vector(7 downto 0);   
		q					  : OUT std_logic_vector(7 downto 0)); 
end encrip;

architecture Behavioral of encrip is

	component rxnibble 
		port(      
			clk   	 : IN  std_logic;
			Strobe    : IN  std_logic;  
			reset     : IN  std_logic; 
			enable    : IN  std_logic;
			datain  	 : IN  std_logic_vector(3 downto 0);
			ACK   	 : OUT std_logic;
			byteready : OUT std_logic;
			we   		 : OUT std_logic;  
			habil  	 : OUT std_logic;
			setcuenta : OUT std_logic;
			address   : OUT std_logic_vector(3 downto 0); 
			q   		 : OUT std_logic_vector(7 downto 0));
	end component;
	
	component ram16x8    
		port(    
			we  	  	: IN  std_logic;  
			clk 		: IN  std_logic;
			address 	: IN  std_logic_vector(3 downto 0);
			data    	: IN  std_logic_vector(7 downto 0);
			do 		: OUT std_logic_vector(7 downto 0));
	end component; 
	
	component mux2x4 
		port( 
			clk : IN  std_logic;
			selec  : IN  std_logic;
			bus1 	 : IN  std_logic_vector(3 downto 0);  
			bus2 	 : IN  std_logic_vector(3 downto 0);   
			busout : OUT std_logic_vector(3 downto 0));  
	end component;
	
	component mux3x8    
		port( 
			clk	 : IN  std_logic;
			selec  : IN  std_logic_vector(1 downto 0);
			bus0   : IN  std_logic_vector(7 downto 0);  
			bus1   : IN  std_logic_vector(7 downto 0);  
			bus2 	 : IN  std_logic_vector(7 downto 0);
			busout : OUT std_logic_vector(7 downto 0)); 
	end component;
	
	component ramkey   
		port(   
			we  	  : IN  std_logic;   
			clk 	  : IN  std_logic;
			address : IN  std_logic_vector(7 downto 0);
			data    : IN  std_logic_vector(7 downto 0);
			do      : OUT std_logic_vector(7 downto 0));
	end component;	 
	
	component mux2x8    
		port( 
			clk 	 : IN  std_logic;
			selec  : IN  std_logic;
			bus0   : IN  std_logic_vector(7 downto 0); 
			bus1 	 : IN  std_logic_vector(7 downto 0);  
			busout : OUT std_logic_vector(7 downto 0));
	end component;
	
	component rom256x8   
		port(   
			clk 		: IN  std_logic; 
			address  : IN  std_logic_vector(7 downto 0);  
			data 		: OUT std_logic_vector(7 downto 0));
	end component;	

	component shift   
		port(
			shift_in  : IN  std_logic_vector(3 downto 0);    
			shift_out : OUT std_logic_vector(3 downto 0)); 
	end component;	 
	
	component reg32mix8x8  
		port(   
			byteclk  : IN  std_logic; 
			startreg : IN  std_logic;
			bytein   : IN  std_logic_vector(7 downto 0); 
			byteout  : OUT std_logic_vector(7 downto 0));
	end component;
	
	component round  
		port(   
			clk   		: IN  std_logic;  
			reset  		: IN  std_logic;  
			habil  		: IN  std_logic;  
			selecmux2x8 : OUT std_logic; 
			selecmux2x4 : OUT std_logic;
			weout  		: OUT std_logic; 
			we   			: OUT std_logic;  
			fin   		: OUT std_logic;
			enable  		: OUT std_logic;
			startreg    : OUT std_logic;
			selecmux3x8 : OUT std_logic_vector(1 downto 0);
			ronda 		: OUT std_logic_vector(3 downto 0);
			qbaja  		: OUT std_logic_vector(3 downto 0);
			q   			: OUT std_logic_vector(7 downto 0));
	end component; 
	
	signal aux0, aux7, auxinv, auxi, auxil, auxclk, auxenable, auxweout, 
		 auxstartreg, auxfin : std_logic;
	signal aux1,aux1a, auxcontab, auxresta, auxaddressram, auxmux, auxkey, 
		 auxronda: std_logic_vector(3 downto 0);
	signal aux5: std_logic_vector(1 downto 0);
	signal aux2, aux3, aux4, aux6, aux8, aux9,  aux1e, auxconca, auxdata, 
		 auxrom, auxromout, auxramout, auxsalida: std_logic_vector(7 downto 0);

begin

u0: rxnibble	
	PORT MAP( datain => datain, clk => clk, Strobe => Strobe, reset => auxfin, 
				enable => auxenable, we => aux0, habil => auxclk, setcuenta => setcuenta, 
				address => aux1, ACK => ACK, byteready => byteready, q => aux2); 
 
u1: ram16x8   		
	PORT MAP( address => aux1, we => aux0, clk => clk, data => aux2, do => aux3); 

u2: mux3x8  		
	PORT MAP( bus0 => aux3, bus1 => auxsalida, bus2 => auxramout, clk => clk, 
				busout => aux4, selec => aux5);
				 
u3: ramkey  		
	PORT MAP( address => aux6, we => aux7, clk => clk, data => data, do => aux8);
 
u4: ram16x8  		
	PORT MAP( address => auxkey, we => auxinv, clk => clk, data => aux9, do => auxrom); 
				
u5: mux2x4  		
	PORT MAP( bus1 => aux1, bus2 => auxcontab, clk => clk, busout => aux1a, 
				selec => auxi);
	
u6: mux2x8  		
	PORT MAP( bus0 => aux1e, bus1 => auxconca, clk => clk, busout => aux6, 
				selec => auxil); 
				 
u8: rom256x8  		
	PORT MAP( address => auxrom, clk => clk, data => auxromout); 

u9: shift   		
	PORT MAP( shift_in => auxresta, shift_out => auxaddressram); 
 
u10: ram16x8   	
	PORT MAP( address => auxmux, we => auxweout, clk => clk, data => auxromout, 
				do => auxramout); 

u11: mux2x4  		
	PORT MAP( bus1 => auxresta, bus2 => auxaddressram, clk => clk, busout => auxmux, 
				selec => auxweout); 
						
u12: reg32mix8x8	
	PORT MAP( bytein => auxramout, byteclk => clk, startreg => auxstartreg, 
				byteout => auxsalida);

u13: round  		
	PORT MAP ( clk => clk, reset => reset, habil => auxclk, q => auxconca, 
				qbaja => auxcontab, selecmux3x8 => aux5, selecmux2x8 => auxil, 
				selecmux2x4 => auxi, weout => auxweout, we => auxinv, ronda => auxronda, 
				enable => auxenable, startreg => auxstartreg, fin => auxfin);
	
aux1e <= "0000" & aux1; 
aux9  <= aux8 xor aux4;
aux7  <= '0'; 
 
	q				<= auxsalida; 
	exorout		<= aux9; 
	addressram	<= auxmux; 
	monitora		<= auxconca; 
	monitorb		<= auxinv; 
	monitorc		<= auxclk;
	monitordata	<= auxromout; 
	monitoraux4	<= aux4; 
	ronda 		<= auxronda; 
	
	auxkey <= conv_std_logic_vector((conv_integer(aux1a))+3, 4) 
	when auxstartreg= '1' 
	else aux1a;
	
	process(clk, reset, auxronda, aux1a, auxinv) 
	begin   
		if(auxronda/=9) then  
			auxresta <= conv_std_logic_vector((conv_integer(aux1a))-1, 4);  
		elsif((auxronda=9) and (auxinv='1')) then    
			auxresta <= conv_std_logic_vector((conv_integer(aux1a))+3, 4);  
		else auxresta <= conv_std_logic_vector((conv_integer(aux1a))-1, 4);  
		end if; 
	end process;
	
	monitoraux8<= aux8; 
	monitoraux1a<= aux1a; 
	monitorstartreg <= auxstartreg; 
	monitorweout <= auxweout; 
	monitorauxramout <= auxramout; 
	monitorauxrom <= auxrom; 
	monitorauxkey <= auxkey;

end Behavioral;
