library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity testbench;

architecture rtl of testbench is
    component top_module_fsm is
        port (
            clk : in  std_logic;
            reset : in  std_logic;
            start : in  std_logic;
            data_in : in  std_logic_vector(0 to 63);
            key : in  std_logic_vector(0 to 63);
            data_out : out std_logic_vector(0 to 63);
            done : out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal start : std_logic := '0';
    signal data_in : std_logic_vector(0 to 63) := (others => '0');
    signal key : std_logic_vector(0 to 63) := (others => '0');
    signal data_out : std_logic_vector(0 to 63);
    signal done : std_logic;
begin
    UUT : top_module_fsm port map (
        clk => clk,
        reset => reset,
        start => start,
        data_in => data_in,
        key => key,
        data_out => data_out,
        done => done
    );

    tb:process
    begin
        reset <= '0';

        data_in <= "0011010101100001001010000011100100111010001100110011001100111000";

        key <= "1010101001110100010110101111101001100110001001111010101111001011";

        start <= '1';

    end process;
    
    
end architecture rtl;