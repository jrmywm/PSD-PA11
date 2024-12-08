library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SBox_Testbench is
end SBox_Testbench;

architecture Behavioral of SBox_Testbench is

    -- Component Declaration
    component SBox is
        Port (
            sbox_number : in INTEGER range 1 to 8; -- Specifies which S-Box to use
            input_data  : in STD_LOGIC_VECTOR(5 downto 0); -- 6-bit input
            output_data : out STD_LOGIC_VECTOR(3 downto 0) -- 4-bit output
        );
    end component;

    -- Signals for the testbench
    signal tb_sbox_number : INTEGER range 1 to 8 := 1;
    signal tb_input_data  : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal tb_output_data : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the SBox
    UUT: SBox
        Port map (
            sbox_number => tb_sbox_number,
            input_data  => tb_input_data,
            output_data => tb_output_data
        );

    -- Stimulus Process
    stimulus_process: process
    begin
        -- SBox 1
        tb_sbox_number <= 1;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "1110"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1101"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1001"
        wait for 10 ns;

        -- SBox 2
        tb_sbox_number <= 2;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "1111"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1001"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1100"
        wait for 10 ns;

        -- SBox 3
        tb_sbox_number <= 3;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "1010"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1100"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1001"
        wait for 10 ns;

        -- SBox 4
        tb_sbox_number <= 4;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "0111"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1110"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1000"
        wait for 10 ns;

        -- SBox 5
        tb_sbox_number <= 5;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "0010"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "0011"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1100"
        wait for 10 ns;

        -- SBox 6
        tb_sbox_number <= 6;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "1100"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1101"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "0111"
        wait for 10 ns;

        -- SBox 7
        tb_sbox_number <= 7;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "0100"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1100"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "0111"
        wait for 10 ns;

        -- SBox 8
        tb_sbox_number <= 8;
        tb_input_data <= "000000"; -- Row = 0, Column = 0, Expected Output = "1101"
        wait for 10 ns;
        tb_input_data <= "111111"; -- Row = 3, Column = 15, Expected Output = "1011"
        wait for 10 ns;
        tb_input_data <= "010101"; -- Row = 2, Column = 10, Expected Output = "1000"
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
