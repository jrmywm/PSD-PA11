LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY encryption_tb IS
END encryption_tb;
 
ARCHITECTURE behavior OF encryption_tb IS 

    COMPONENT encryption
    PORT(
         input : IN  std_logic_vector(0 to 63);
         key : IN  std_logic_vector(0 to 63);
         output : OUT  std_logic_vector(0 to 63)
        );
    END COMPONENT;
    
   signal input : std_logic_vector(0 to 63) := (others => '0');
   signal key : std_logic_vector(0 to 63) := (others => '0');
   signal output : std_logic_vector(0 to 63);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: encryption_prog4 PORT MAP (
          input => input,
          key => key,
          output => output
        );

   -- Clock process definitions
   
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
		input<="0000000000000000000000000000000000000000000000000000000000000000";
		key<="0000000100100011010001010110011110001001101010111100110111101111";
		wait for 300 ns;
		input<="0000011100100001000110000010000100000111001000010001100000100001";
		key<="0101101000010001110111100101010001011010000100011101111001010100";
		wait for 300 ns;
		input<="0101101000010001110111100101010001011010000100011101111001010100";
		key<="0000011100100001000110000010000100000111001000010001100000100001";
		wait for 300 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
