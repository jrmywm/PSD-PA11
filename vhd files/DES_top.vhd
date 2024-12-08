library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DES_Top is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        mode        : in  STD_LOGIC; -- '0' for encryption, '1' for decryption
        key         : in  STD_LOGIC_VECTOR(63 downto 0);
        data_in     : in  STD_LOGIC_VECTOR(63 downto 0);
        data_out    : out STD_LOGIC_VECTOR(63 downto 0);
        done        : out STD_LOGIC
    );
end DES_Top;

architecture Behavioral of DES_Top is

    -- Signals for internal connections
    signal permuted_input     : STD_LOGIC_VECTOR(63 downto 0);
    signal permuted_output    : STD_LOGIC_VECTOR(63 downto 0);
    signal left_half, right_half : STD_LOGIC_VECTOR(31 downto 0);
    signal next_left, next_right : STD_LOGIC_VECTOR(31 downto 0);
    signal round_key          : STD_LOGIC_VECTOR(47 downto 0);
    signal current_round      : integer range 0 to 15 := 0;
    signal feistel_result     : STD_LOGIC_VECTOR(31 downto 0);
    signal concatenated_halves : STD_LOGIC_VECTOR(63 downto 0);
    signal process_done       : STD_LOGIC := '0';

    component Permutation is
        Port (
            input_data  : in  STD_LOGIC_VECTOR(63 downto 0);
            output_data : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component KeyScheduler is
        Port (
            key          : in  STD_LOGIC_VECTOR(63 downto 0);
            round_number : in  INTEGER range 0 to 15;
            round_key    : out STD_LOGIC_VECTOR(47 downto 0)
        );
    end component;

    component FeistelFunction is
        Port (
            input_data : in  STD_LOGIC_VECTOR(31 downto 0);
            subkey     : in  STD_LOGIC_VECTOR(47 downto 0);
            output_data: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

begin
    -- Initial permutation
    Initial_Perm: Permutation port map(
        input_data  => data_in,
        output_data => permuted_input
    );

    -- Key scheduling
    Key_Schedule: KeyScheduler port map(
        key          => key,
        round_number => current_round,
        round_key    => round_key
    );

    -- Feistel function
    Feistel_Func: FeistelFunction port map(
        input_data => right_half,
        subkey     => round_key,
        output_data=> feistel_result
    );

    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset all signals
            left_half <= (others => '0');
            right_half <= (others => '0');
            current_round <= 0;
            process_done <= '0';
        elsif rising_edge(clk) then
            if process_done = '0' then
                -- Initialize halves on the first round
                if current_round = 0 then
                    left_half <= permuted_input(63 downto 32);
                    right_half <= permuted_input(31 downto 0);
                end if;

                -- Update halves for the current round
                next_left <= right_half;
                if mode = '0' then -- Encryption
                    next_right <= left_half xor feistel_result;
                else -- Decryption
                    next_right <= left_half xor feistel_result;
                end if;

                left_half <= next_left;
                right_half <= next_right;

                -- Increment round
                if current_round = 15 then
                    process_done <= '1';
                else
                    current_round <= current_round + 1;
                end if;
            end if;
        end if;
    end process;

    -- Concatenate halves for final permutation
    concatenated_halves <= left_half & right_half;

    -- Final permutation
    Final_Perm: Permutation port map(
        input_data  => concatenated_halves,
        output_data => permuted_output
    );

    -- Output assignment
    data_out <= permuted_output;
    done <= process_done;

end Behavioral;

