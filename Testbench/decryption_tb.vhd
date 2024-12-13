library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decryption_tb is
-- Testbench has no ports
end decryption_tb;

architecture behavior of decryption_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component decryption
        port (
            input  : in  std_logic_vector(0 to 63);
            key    : in  std_logic_vector(0 to 63);
            output : out std_logic_vector(0 to 63);
            done   : out std_logic
        );
    end component;

    -- Signals to connect to UUT
    signal input_signal  : std_logic_vector(0 to 63) := (others => '0');
    signal key_signal    : std_logic_vector(0 to 63) := (others => '0');
    signal output_signal : std_logic_vector(0 to 63);
    signal done_signal   : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: decryption
        port map (
            input  => input_signal,
            key    => key_signal,
            output => output_signal,
            done   => done_signal
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        input_signal <= x"85E813540F0AB405"; -- Example ciphertext
        key_signal <= x"133457799BBCDFF1";  -- Example key

        -- Wait for decryption to complete
        wait until done_signal = '1';

        -- Check the output
        wait for 20 ns; -- Allow some time for observation

        -- End simulation
        wait;
    end process;

end behavior;
