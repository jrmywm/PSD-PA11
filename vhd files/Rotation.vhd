library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rotation is
    Generic (
        ROTATE_DIRECTION : string := "LEFT"; -- "LEFT" or "RIGHT"
        ROTATE_BITS : integer := 1           -- Number of bits to rotate
    );
    Port (
        input  : in  STD_LOGIC_VECTOR(27 downto 0);
        output : out STD_LOGIC_VECTOR(27 downto 0)
    );
end Rotation;

architecture Behavioral of Rotation is
begin
    process(input)
    begin
        if ROTATE_DIRECTION = "LEFT" then
            output <= input(27 - ROTATE_BITS downto 0) & input(27 downto 28 - ROTATE_BITS + 1);
        elsif ROTATE_DIRECTION = "RIGHT" then
            output <= input(ROTATE_BITS - 1 downto 0) & input(27 downto ROTATE_BITS);
        else
            output <= input; -- Default case, no rotation
        end if;
    end process;
end Behavioral;
