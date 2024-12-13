LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_boxes_combined IS
END tb_boxes_combined;
 
ARCHITECTURE behavior OF tb_boxes_combined IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT s_box_1_8
    PORT(
         input : IN  std_logic_vector(0 to 47);
         output : OUT  std_logic_vector(0 to 31)
        );
    END COMPONENT;
    

   signal input : std_logic_vector(0 to 47) := (others => '0');
   signal output : std_logic_vector(0 to 31);
 
BEGIN
    uut: s_box_1_8 PORT MAP (
          input => input,
          output => output
        );
   
 
   stim_proc: process
   begin		 
		input<="111100000000100000001000000111111000001000001000";
      wait;
   end process;

END;
