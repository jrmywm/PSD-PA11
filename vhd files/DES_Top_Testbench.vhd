library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DES_Top_testbench is
-- No ports for a testbench
end DES_Top_testbench;

architecture Behavioral of DES_Top_testbench is

    -- Component declaration for the Unit Under Test (UUT)
    component DES_Top
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            mode        : in  STD_LOGIC; -- '0' for encryption, '1' for decryption
            key         : in  STD_LOGIC_VECTOR(63 downto 0);
            data_in     : in  STD_LOGIC_VECTOR(63 downto 0);
            data_out    : out STD_LOGIC_VECTOR(63 downto 0);
            done        : out STD_LOGIC
        );
    end component;

    -- Signals to connect to the UUT
    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal mode        : STD_LOGIC := '0'; -- Start with encryption mode
    signal key         : STD_LOGIC_VECTOR(63 downto 0) := X"133457799BBCDFF1"; -- Example key
    signal data_in     : STD_LOGIC_VECTOR(63 downto 0) := X"0123456789ABCDEF"; -- Example plaintext
    signal data_out    : STD_LOGIC_VECTOR(63 downto 0);
    signal done        : STD_LOGIC;

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: DES_Top
        Port map (
            clk => clk,
            rst => rst,
            mode => mode,
            key => key,
            data_in => data_in,
            data_out => data_out,
            done => done
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the UUT
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- Encryption Test
        mode <= '0'; -- Encryption mode
        data_in <= X"0123456789ABCDEF"; -- Example plaintext
        wait until done = '1'; -- Wait for encryption to complete

        assert (data_out /= X"0123456789ABCDEF")
        report "Encryption failed!" severity error;

        -- Decryption Test
        mode <= '1'; -- Decryption mode
        data_in <= data_out; -- Use encrypted output as input
        wait until done = '1'; -- Wait for decryption to complete

        assert (data_out = X"0123456789ABCDEF")
        report "Decryption failed!" severity error;

        -- Test finished
        report "Testbench completed successfully!" severity note;
        wait;
    end process;

end Behavioral;

