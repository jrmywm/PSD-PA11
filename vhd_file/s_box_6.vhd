library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity s_box_6 is
    port(
        input: in std_logic_vector(0 to 5);  -- 6-bit input to the S-box
        output: out std_logic_vector(0 to 3) -- 4-bit output from the S-box
    );
end s_box_6;

architecture behavior of s_box_6 is

    -- Define the S-box as a 2D array with integer values
    type s_box is array(0 to 3, 0 to 15) of integer range 1 to 16;
    constant box: s_box := 
        (
            (13, 2, 11, 16, 10, 3, 7, 9, 1, 14, 4, 5, 15, 8, 6, 12),
            (11, 16, 5, 3, 8, 13, 10, 6, 7, 2, 14, 15, 1, 12, 4, 9),
            (10, 15, 16, 6, 3, 9, 13, 4, 8, 1, 5, 11, 2, 14, 12, 7),
            (5, 4, 3, 13, 10, 6, 16, 11, 12, 15, 2, 8, 7, 1, 9, 14)
        );

begin

    -- Process block to compute the S-box output
    process(input) is
        variable column: integer range 0 to 15;       -- Column index in the S-box
        variable row: integer range 0 to 3;           -- Row index in the S-box
        variable outer_bits: std_logic_vector(0 to 1); -- Extracted outer bits of the input
        variable output_decimal: integer range 0 to 15; -- Final output in decimal
    begin
        -- Extract column index (middle 4 bits of the input)
        column := to_integer(unsigned(input(1 to 4)));

        -- Extract row index (concatenation of the outer 2 bits of the input)
        outer_bits := input(0) & input(5);
        row := to_integer(unsigned(outer_bits));

        -- Lookup value in the S-box and subtract 1 to adjust for zero-based indexing
        output_decimal := (box(row, column) - 1);

        -- Convert the decimal output to a 4-bit std_logic_vector
        output <= std_logic_vector(to_unsigned(output_decimal, output'length));
    end process;

end behavior;
