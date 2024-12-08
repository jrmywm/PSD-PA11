library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity s_box_4 is
    port(
        input: in std_logic_vector(0 to 5);  -- 6-bit input to the S-box
        output: out std_logic_vector(0 to 3) -- 4-bit output from the S-box
    );
end s_box_4;

architecture behavior of s_box_4 is

    -- Define the S-box as a 2D array with integer values
    type s_box is array(0 to 3, 0 to 15) of integer range 1 to 16;
    constant box: s_box := 
        (
            (8, 14, 15, 4, 1, 7, 10, 11, 2, 3, 9, 6, 12, 13, 5, 16),
            (14, 9, 12, 6, 7, 16, 1, 4, 5, 8, 3, 13, 2, 11, 15, 10),
            (11, 7, 10, 1, 13, 12, 8, 14, 16, 2, 4, 15, 6, 3, 9, 5),
            (4, 16, 1, 7, 11, 2, 14, 9, 10, 5, 6, 12, 13, 8, 3, 15)
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
