library ieee;
use ieee.std_logic_1164.all;

entity permutation_step is
port(
    input: in std_logic_vector(0 to 31);
    output: out std_logic_vector(0 to 31)
);
end permutation_step;

architecture behavior of permutation_step is

    -- Define the permutation array as a constant array
    type ip_array is array(0 to 31) of integer range 1 to 32;
    constant ip: ip_array := (
        16, 7, 20, 21,
        29, 12, 28, 17,
        1, 15, 23, 26,
        5, 18, 31, 10,
        2, 8, 24, 14,
        32, 27, 3, 9,
        19, 13, 30, 6,
        22, 11, 4, 25
    );

begin

    process(input) is
    begin
        -- Apply permutation
        for i in 0 to 31 loop
            output(i) <= input(ip(i) - 1); -- Adjust for 0-based indexing
        end loop;
    end process;

end behavior;
