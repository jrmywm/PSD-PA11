library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity combined_s_boxes is
    Port (
        input : in std_logic_vector(0 to 47); -- 48-bit input
        output : out std_logic_vector(0 to 31) -- 32-bit output
    );
end combined_s_boxes;

architecture behavior of combined_s_boxes is

    -- Define types for S-boxes
    type s_box_array is array(0 to 3, 0 to 15) of integer range 0 to 15;

    -- Define the S-box matrices
    constant s_box_1: s_box_array := (
        (14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7),
        (0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8),
        (4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0),
        (15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13)
    );

    constant s_box_2: s_box_array := (
        (15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10),
        (3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5),
        (0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15),
        (13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9)
    );

    constant s_box_3: s_box_array := (
        (10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8),
        (13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1),
        (13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7),
        (1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12)
    );

    constant s_box_4: s_box_array := (
        (7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15),
        (13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9),
        (10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4),
        (3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14)
    );

    -- Repeat for s_box_5, s_box_6, s_box_7, s_box_8
    constant s_box_5: s_box_array := (
        (2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9),
        (14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6),
        (4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14),
        (11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3)
    );

    constant s_box_6: s_box_array := (
        (12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11),
        (10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8),
        (9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6),
        (4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13)
    );

    constant s_box_7: s_box_array := (
        (4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1),
        (13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6),
        (1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2),
        (6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12)
    );

    constant s_box_8: s_box_array := (
        (13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7),
        (1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2),
        (7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8),
        (2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11)
    );

    -- Procedure to process input through an S-box
    procedure process_s_box(
        segment: in std_logic_vector(0 to 5);
        s_box: in s_box_array;
        result: out std_logic_vector(0 to 3)
    ) is
        variable row, column: integer;
        variable temp: integer;
        variable row_bits: std_logic_vector(0 to 1); -- Adjust the width as needed

        begin
            -- Concatenate segment(0) and segment(5) manually for row
            row_bits := segment(0) & segment(5);
            row := to_integer(unsigned(row_bits)); -- Convert to integer
        
            -- Convert segment(1 to 4) directly to integer
            column := to_integer(unsigned(segment(1 to 4)));
        
            -- Lookup S-box and assign result
            temp := s_box(row, column);
            result := std_logic_vector(to_unsigned(temp, 4)); -- Convert integer result back to std_logic_vector
        end procedure;

begin

    process(input)
        variable temp_output: std_logic_vector(0 to 31);
    begin
        process_s_box(input(0 to 5), s_box_1, temp_output(0 to 3));
        process_s_box(input(6 to 11), s_box_2, temp_output(4 to 7));
        process_s_box(input(12 to 17), s_box_3, temp_output(8 to 11));
        process_s_box(input(18 to 23), s_box_4, temp_output(12 to 15));
        process_s_box(input(24 to 29), s_box_5, temp_output(16 to 19));
        process_s_box(input(30 to 35), s_box_6, temp_output(20 to 23));
        process_s_box(input(36 to 41), s_box_7, temp_output(24 to 27));
        process_s_box(input(42 to 47), s_box_8, temp_output(28 to 31));

        output <= temp_output; -- Assign final output
    end process;

end behavior;
