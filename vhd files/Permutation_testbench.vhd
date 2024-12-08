library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Permutation_testbench is
end Permutation_testbench;

architecture Behavioral of Permutation_testbench is
    -- Component Declaration
    component Permutation is
        Port (
            input_data  : in  STD_LOGIC_VECTOR(63 downto 0);
            output_data : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    -- Signals for the testbench
    signal input_data  : STD_LOGIC_VECTOR(63 downto 0);
    signal output_data : STD_LOGIC_VECTOR(63 downto 0);

    -- Example Permutation Table (used for expected values)
    constant expected_output : STD_LOGIC_VECTOR(63 downto 0) := X"CC00CCFF0000FF00"; -- Example

begin
    -- Instantiate Permutation
    UUT: Permutation port map(
        input_data => input_data,
        output_data => output_data
    );

    -- Stimulus Process
    stimulus: process
    begin
        -- Apply Input and Wait
        input_data <= X"0123456789ABCDEF";
        wait for 10 ns;

        -- Check Output
        assert (output_data = expected_output)
        report "Permutation failed!" severity error;

        -- Finish Simulation
        wait;
    end process;
end Behavioral;

