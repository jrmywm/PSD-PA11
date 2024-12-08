library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyScheduler_testbench is
end KeyScheduler_testbench;

architecture Behavioral of KeyScheduler_testbench is
    -- Component Declaration
    component KeyScheduler is
        Port (
            key          : in  STD_LOGIC_VECTOR(63 downto 0);
            round_number : in  INTEGER range 0 to 15;
            round_key    : out STD_LOGIC_VECTOR(47 downto 0)
        );
    end component;

    -- Signals for the testbench
    signal key          : STD_LOGIC_VECTOR(63 downto 0);
    signal round_number : INTEGER range 0 to 15;
    signal round_key    : STD_LOGIC_VECTOR(47 downto 0);

    -- Expected Round Key for Round 1
    constant expected_key_round_1 : STD_LOGIC_VECTOR(47 downto 0) := X"1B02EFFC7072"; -- Example

begin
    -- Instantiate KeyScheduler
    UUT: KeyScheduler port map(
        key => key,
        round_number => round_number,
        round_key => round_key
    );

    -- Stimulus Process
    stimulus: process
    begin
        -- Apply Inputs for Round 1
        key <= X"133457799BBCDFF1";
        round_number <= 1;
        wait for 10 ns;

        -- Check Output
        assert (round_key = expected_key_round_1)
        report "KeyScheduler failed for round 1!" severity error;

        -- Apply Inputs for Round 2
        round_number <= 2;
        wait for 10 ns;

        -- Expected Round Key for Round 2 (Update as per design logic)
        -- assert (round_key = expected_key_round_2)
        -- report "KeyScheduler failed for round 2!" severity error;

        -- Finish Simulation
        wait;
    end process;
end Behavioral;

