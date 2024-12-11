library ieee;
use ieee.std_logic_1164.all;

entity expansion is -- mengubah 32 bit menjadi 48 bit
    port(
        input  : in std_logic_vector(0 to 31); -- Input 32-bit data
        output : out std_logic_vector(0 to 47) -- Expanded 48-bit output
    );
end expansion;

architecture behavior of expansion is

    -- Define the expansion table as a constant array
    type exp_array is array(0 to 47) of integer range 1 to 32;

    constant ip_exp : exp_array :=
        (
            32, 1, 2, 3, 4, 5,  
            4, 5, 6, 7, 8, 9,
            8, 9, 10, 11, 12, 13,
            12, 13, 14, 15, 16, 17,
            16, 17, 18, 19, 20, 21,
            20, 21, 22, 23, 24, 25,
            24, 25, 26, 27, 28, 29,
            28, 29, 30, 31, 32, 1
        );

begin

    process(input) is
    begin
        for i in 0 to 47 loop
            output(i) <= input(ip_exp(i) - 1);
        end loop;
    end process;

end behavior;
