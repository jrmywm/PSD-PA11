library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std;

entity right_rot_two_bit is
port(	input: in std_logic_vector(0 to 27);
	output: out std_logic_vector(0 to 27));
end right_rot_two_bit;


architecture behavior of right_rot_two_bit is

begin
process (input) is

	begin
	
		for i in 2 to 27 loop
		
		output(i)<=input(i-2);
		
		end loop;
		output(0)<=input(26);
		output(1)<=input(27);
		
		end process;	

end behavior;

