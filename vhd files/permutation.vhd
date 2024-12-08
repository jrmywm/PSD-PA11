library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Permutation is
    Port (
        input_data : in STD_LOGIC_VECTOR(63 downto 0);
        output_data : out STD_LOGIC_VECTOR(63 downto 0)
    );
end Permutation;

architecture Behavioral of Permutation is
    type perm_table_array is array(0 to 63) of integer range 0 to 63;

    constant initial_perm_table : perm_table_array := (
        57, 49, 41, 33, 25, 17,  9,  1,
        59, 51, 43, 35, 27, 19, 11,  3,
        61, 53, 45, 37, 29, 21, 13,  5,
        63, 55, 47, 39, 31, 23, 15,  7,
        56, 48, 40, 32, 24, 16,  8,  0,
        58, 50, 42, 34, 26, 18, 10,  2,
        60, 52, 44, 36, 28, 20, 12,  4,
        62, 54, 46, 38, 30, 22, 14,  6
    );

    constant inverse_perm_table : perm_table_array := (
        39,  7, 47, 15, 55, 23, 63, 31,
        38,  6, 46, 14, 54, 22, 62, 30,
        37,  5, 45, 13, 53, 21, 61, 29,
        36,  4, 44, 12, 52, 20, 60, 28,
        35,  3, 43, 11, 51, 19, 59, 27,
        34,  2, 42, 10, 50, 18, 58, 26,
        33,  1, 41,  9, 49, 17, 57, 25,
        32,  0, 40,  8, 48, 16, 56, 24
    );

    signal l_r_merge : STD_LOGIC_VECTOR(63 downto 0);

begin
    process(input_data)
    begin
        -- Merge halves for unified processing
        l_r_merge <= input_data;

        -- Apply permutation
        for i in 0 to 63 loop
            output_data(i) <= l_r_merge(initial_perm_table(i));
        end loop;
    end process;
end Behavioral;
