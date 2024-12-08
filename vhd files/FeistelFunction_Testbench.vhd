library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FeistelFunction_testbench is
end FeistelFunction_testbench;

architecture Behavioral of FeistelFunction_testbench is
    -- Component Declaration
    component FeistelFunction is
        Port (
            input_data  : in  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit input
            subkey      : in  STD_LOGIC_VECTOR(47 downto 0); -- 48-bit subkey
            output_data : out STD_LOGIC_VECTOR(31 downto 0)  -- 32-bit output
        );
    end component;

    -- Signals for the testbench
    signal input_data  : STD_LOGIC_VECTOR(31 downto 0);
    signal subkey      : STD_LOGIC_VECTOR(47 downto 0);
    signal output_data : STD_LOGIC_VECTOR(31 downto 0);

    -- Expected Feistel Output
    constant expected_output : STD_LOGIC_VECTOR(31 downto 0) := X"3A1B2C4D"; -- Replace with the actual expected value

begin
    -- Instantiate FeistelFunction
    UUT: FeistelFunction port map(
        input_data => input_data,
        subkey => subkey,
        output_data => output_data
    );

    -- Stimulus Process
    stimulus: process
    begin
        -- Apply Inputs and Wait
        input_data <= X"89ABCDEF";            -- Example 32-bit input
        subkey <= X"133457799BBC";           -- Example 48-bit subkey
        wait for 10 ns;

        -- Check Output
        assert (output_data = expected_output)
        report "Feistel function failed!" severity error;

        -- Finish Simulation
        wait;
    end process;
end Behavioral;

