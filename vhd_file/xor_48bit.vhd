library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_48bit is
port(	input: in std_logic_vector(0 to 47);
	key: in std_logic_vector(0 to 47);
	output: out std_logic_vector(0 to 47));
end xor_48bit;


architecture behavior of xor_48bit is

begin 	
	output<= key xor input;
end behavior;
