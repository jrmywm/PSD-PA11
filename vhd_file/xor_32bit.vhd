library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_32bit is
port(	input: in std_logic_vector(0 to 31);
	key: in std_logic_vector(0 to 31);
	output: out std_logic_vector(0 to 31));
end xor_32bit;


architecture behavior of xor_32bit is

begin 	
	output<= key xor input;
end behavior;

