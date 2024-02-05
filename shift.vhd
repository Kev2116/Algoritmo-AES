library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift is
	port(
		shift_in  : IN  std_logic_vector(3 downto 0);
		shift_out : OUT std_logic_vector(3 downto 0));
end shift;

architecture Behavioral of shift is
begin

	process(shift_in)
	begin
		case shift_in is
			when "0000" => shift_out <= "0000";
			when "0001" => shift_out <= "1101";
			when "0010" => shift_out <= "1010";
			when "0011" => shift_out <= "0111";
			when "0100" => shift_out <= "0100";
			when "0101" => shift_out <= "0001";
			when "0110" => shift_out <= "1110";
			when "0111" => shift_out <= "1011";
			when "1000" => shift_out <= "1000";
			when "1001" => shift_out <= "0101";
			when "1010" => shift_out <= "0010";
			when "1011" => shift_out <= "1111";
			when "1100" => shift_out <= "1100";
			when "1101" => shift_out <= "1001";
			when "1110" => shift_out <= "0110";
			when others => shift_out <= "0011";
		end case;
	end process;
end Behavioral;
