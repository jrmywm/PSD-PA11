library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity subkey_generation is

    port(
        shifting_parameter: in std_logic_vector(0 to 1); -- Determines the number of shifts (01 for 1-bit, 10 for 2-bit)
        left_or_right: in std_logic_vector(0 to 0);       -- Direction of shift (0 for left, 1 for right)
        left_key_in: in std_logic_vector(0 to 27);       -- Input left key half (28 bits)
        right_key_in: in std_logic_vector(0 to 27);      -- Input right key half (28 bits)
        subkey: out std_logic_vector(0 to 47);           -- Output subkey (48 bits)
        left_key_out: out std_logic_vector(0 to 27);     -- Output shifted left key half
        right_key_out: out std_logic_vector(0 to 27)     -- Output shifted right key half
    );
end subkey_generation;

architecture behavior of subkey_generation is

    -- Internal signals for shifted halves
    signal left_half_shifted: std_logic_vector(0 to 27);
    signal right_half_shifted: std_logic_vector(0 to 27);

    type key2 is array(0 to 47) of integer range 0 to 56;

    constant PC2: key2 :=
        (13,16,10,23,0,4,
         2,27,14,5,20,9,
         22,18,11,3,25,7,
         15,6,26,19,12,1,
         40,51,30,36,46,54,
         29,39,50,44,32,47,
         43,48,38,55,33,52,
         45,41,49,35,28,31);

begin

    -- Unified rotation process
    process(left_key_in, right_key_in)
        variable left_temp: std_logic_vector(0 to 27);
        variable right_temp: std_logic_vector(0 to 27);
    begin
        -- Default assignments
        left_temp := left_key_in;
        right_temp := right_key_in;

        if shifting_parameter = "01" then -- 1-bit shift
            if left_or_right = "0" then -- Left shift
                left_temp(0 to 26) := left_key_in(1 to 27);
                left_temp(27) := left_key_in(0);
                right_temp(0 to 26) := right_key_in(1 to 27);
                right_temp(27) := right_key_in(0);
            else -- Right shift
                left_temp(1 to 27) := left_key_in(0 to 26);
                left_temp(0) := left_key_in(27);
                right_temp(1 to 27) := right_key_in(0 to 26);
                right_temp(0) := right_key_in(27);
            end if;
        elsif shifting_parameter = "10" then -- 2-bit shift
            if left_or_right = "0" then -- Left shift
                left_temp(0 to 25) := left_key_in(2 to 27);
                left_temp(26) := left_key_in(0);
                left_temp(27) := left_key_in(1);
                right_temp(0 to 25) := right_key_in(2 to 27);
                right_temp(26) := right_key_in(0);
                right_temp(27) := right_key_in(1);
            else -- Right shift
                left_temp(2 to 27) := left_key_in(0 to 25);
                left_temp(0) := left_key_in(26);
                left_temp(1) := left_key_in(27);
                right_temp(2 to 27) := right_key_in(0 to 25);
                right_temp(0) := right_key_in(26);
                right_temp(1) := right_key_in(27);
            end if;
        end if;

        -- Assign shifted values to signals
        left_half_shifted <= left_temp;
        right_half_shifted <= right_temp;
    end process;

    -- Permutation
    process(left_half_shifted, right_half_shifted)
        variable combined_key: std_logic_vector(0 to 55);
    begin
        combined_key := left_half_shifted & right_half_shifted;
        for i in 0 to 47 loop
            subkey(i) <= combined_key(PC2(i));
        end loop;
    end process;

    -- Output assignments
    left_key_out <= left_half_shifted;
    right_key_out <= right_half_shifted;

end behavior;
