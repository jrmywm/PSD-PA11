library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Toplevel is
    port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        start : in STD_LOGIC;

    );
end entity Toplevel;

architecture rtl of Toplevel is
    type state_type is (IDLE, )
    signal state : state_type := IDLE;
begin
    --port map

    --implementasi FSM
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
            else
                case state is
                    when IDLE =>
                        
                    when others =>
                        
                end case;
            end if;
    end process;
    
end architecture rtl;