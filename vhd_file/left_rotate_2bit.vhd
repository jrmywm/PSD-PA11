library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity left_rot_two_bit is
port(	input: in std_logic_vector(0 to 27);
	output: out std_logic_vector(0 to 27));
end left_rot_two_bit;


architecture behavior of left_rot_two_bit is

begin

process (input) is

	begin
	
		for i in 0 to 25 loop
		
		output(i)<=input(i+2);
		
		end loop;
		output(26)<= input(0);
		output(27)<= input(1);
		
		end process;	

end behavior;