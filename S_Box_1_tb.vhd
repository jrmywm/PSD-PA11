LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY s_box_1_tb IS
END s_box_1_tb;
 
ARCHITECTURE behavior OF s_box_1_tb IS 
  
    COMPONENT s_one_box
    PORT(
         input : IN  std_logic_vector(0 to 5);
         output : OUT  std_logic_vector(0 to 3)
        );
    END COMPONENT;
    
   signal input : std_logic_vector(0 to 5) := (others => '0');
   signal output : std_logic_vector(0 to 3);

BEGIN
    uut: s_one_box PORT MAP (
          input => input,
          output => output
        );

   stim_proc: process
   begin		
		input<="000000"; -- output should be 1110

      wait;
   end process;

END;
