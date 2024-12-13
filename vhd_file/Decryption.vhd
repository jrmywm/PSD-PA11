library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decryption is
    port (
        input  : in std_logic_vector(0 to 63);
        key    : in std_logic_vector(0 to 63);
        output : out std_logic_vector(0 to 63);
		done   : out std_logic
    );
end decryption;

architecture behavior of decryption is

    -- Component declarations
    component initial_permutation
        port (
            input                  : in std_logic_vector(0 to 63);
            right_half_permutation : out std_logic_vector(0 to 31);
            left_half_permutation  : out std_logic_vector(0 to 31)
        );
    end component;

    component permutation_key_one
        port (
            key                   : in std_logic_vector(0 to 63);
            left_key_permutation  : out std_logic_vector(0 to 27);
            right_key_permutation : out std_logic_vector(0 to 27)
        );
    end component;

    component subkey_generation
        port (
            shifting_parameter : std_logic_vector(0 to 1);
            left_or_right      : std_logic_vector(0 to 0);
            left_key_in  : in std_logic_vector(0 to 27);
            right_key_in : in std_logic_vector(0 to 27);
            subkey       : out std_logic_vector(0 to 47);
            left_key_out : out std_logic_vector(0 to 27);
            right_key_out: out std_logic_vector(0 to 27)
        );
    end component;

    component round_prog
        port (
            left_half   : in std_logic_vector(0 to 31);
            right_half  : in std_logic_vector(0 to 31);
            subkey      : in std_logic_vector(0 to 47);
            left_output : out std_logic_vector(0 to 31);
            right_output: out std_logic_vector(0 to 31)
        );
    end component;

    component left_right_64bit_swap
        port (
            input_left  : in std_logic_vector(0 to 31);
            input_right : in std_logic_vector(0 to 31);
            output_left : out std_logic_vector(0 to 31);
            output_right: out std_logic_vector(0 to 31)
        );
    end component;

    component init_permutation_reverse
        port (
            left_half_permutation : in std_logic_vector(0 to 31);
            right_half_permutation: in std_logic_vector(0 to 31);
            output                : out std_logic_vector(0 to 63)
        );
    end component;

    -- Type and signal declarations
    type std_logic_array_48 is array (0 to 15) of std_logic_vector(0 to 47);
    type std_logic_array_28 is array (0 to 16) of std_logic_vector(0 to 27);
    type std_logic_array_32 is array (0 to 16) of std_logic_vector(0 to 31);

    signal permuted_right_half, permuted_left_half : std_logic_vector(0 to 31);
    signal left_key, right_key, left_key_0, right_key_0 : std_logic_vector(0 to 27);
    signal subkeys                                 : std_logic_array_48 := (others => (others => '0'));
    signal left_keys, right_keys                   : std_logic_array_28 := (others => (others => '0'));
    signal left_halves, right_halves               : std_logic_array_32 := (others => (others => '0'));
    signal swapped_left, swapped_right             : std_logic_vector(0 to 31);
	signal internal_done : std_logic := '1';


    -- DES shifting schedule in reverse order for decryption
    type shifting_array is array (0 to 15) of std_logic_vector(0 to 1);
    constant des_shifts: shifting_array := (
        "01", -- Round 1: 1-bit shift
        "01", -- Round 2: 1-bit shift
        "10", -- Round 3: 2-bit shift
        "10", -- Round 4: 2-bit shift
        "10", -- Round 5: 2-bit shift
        "10", -- Round 6: 2-bit shift
        "10", -- Round 7: 2-bit shift
        "10", -- Round 8: 2-bit shift
        "01", -- Round 9: 1-bit shift
        "10", -- Round 10: 2-bit shift
        "10", -- Round 11: 2-bit shift
        "10", -- Round 12: 2-bit shift
        "10", -- Round 13: 2-bit shift
        "10", -- Round 14: 2-bit shift
        "10", -- Round 15: 2-bit shift
        "01"  -- Round 16: 1-bit shift
    );

begin
    -- Initial Permutation
    init_permutation: initial_permutation port map (
        input                  => input,
        right_half_permutation => permuted_right_half,
        left_half_permutation  => permuted_left_half
    );

    -- Key Permutation
    key_permutation: permutation_key_one port map (
        key                   => key,
        left_key_permutation  => left_key,
        right_key_permutation => right_key
    );

    -- Reverse the keys
    left_key_0 <= left_key(1 to 27) & left_key(0);
    right_key_0 <= right_key(1 to 27) & right_key(0);

    -- Initialize
    left_keys(0) <= left_key_0;
    right_keys(0) <= right_key_0;
    left_halves(0) <= permuted_left_half;
    right_halves(0) <= permuted_right_half;

    -- Generate subkeys and rounds
    gen_rounds: for i in 0 to 15 generate
        subkey_gen: subkey_generation port map (
			shifting_parameter => des_shifts(i),
            left_or_right      => "1",
            left_key_in  => left_keys(i),
            right_key_in => right_keys(i),
            subkey       => subkeys(i),
            left_key_out => left_keys(i + 1),
            right_key_out=> right_keys(i + 1)
        );

        round_proc: round_prog port map (
            left_half   => left_halves(i),
            right_half  => right_halves(i),
            subkey      => subkeys(i),
            left_output => left_halves(i + 1),
            right_output=> right_halves(i + 1)
        );
    end generate;

    -- Final Swap
    swap: left_right_64bit_swap port map (
        input_left  => left_halves(16),
        input_right => right_halves(16),
        output_left => swapped_left,
        output_right=> swapped_right
    );

    -- Inverse Initial Permutation
    inverse_init_permutation: init_permutation_reverse port map (
        left_half_permutation => swapped_left,
        right_half_permutation=> swapped_right,
        output                => output
    );

	done <= internal_done;
end behavior;
