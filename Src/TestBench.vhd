library IEEE;
library std;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity TestBench is
end entity TestBench;

architecture rtl of TestBench is
    type array_type is array (1 to 8) of STD_LOGIC_VECTOR(7 downto 0);
    signal string_arr : array_type := (others => (others => '0'));
    signal plainIn : STD_LOGIC_VECTOR(63 downto 0);
begin

    process
        file plainTextIn : TEXT open READ_MODE is "plainTextIn.txt";
        file cipherTextIn : TEXT open READ_MODE is "cipherTextIn.txt";
        file cipherTextOut : TEXT open WRITE_MODE is "cipherTextOut.txt";
        file plainTextOut : TEXT open WRITE_MODE is "plainTextOut.txt";
        variable line_var : LINE;
        variable input_str : string(1 to 8); --input berupa 8 karakter (8 bit tiap karakter)

    begin   
        --baca input dari plaintext
        if not endfile (plainTextIn) then
            readline(plainTextIn, line_var); --baca satu line dari plainTextIn.txt, simpen di line_var
            read(line_var, input_str); --baca line_var, simpan ke input_str (jadi string 1 bit 1 bit)
            for i in 0 to 7 loop
                string_arr(i) <= std_logic_vector(to_unsigned(character'pos(input_str(i+1)), 8)); --konversi input_str ke std_logic_vector
            end loop;
            plainIn <= string_arr(1) & string_arr(2) & string_arr(3) & string_arr(4) & string_arr(5) & string_arr(6) & string_arr(7) & string_arr(8); --gabungkan string_arr jadi satu
        end if;

        --write hasil enkripsi ke ciphertextout


        --baca input dari ciphertext

        --write hasil dekcrypt ke plaintextout

        wait;
    end process;
    
    
end architecture rtl;