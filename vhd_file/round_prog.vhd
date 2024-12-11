library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity round_prog is
    port(
        left_half: in std_logic_vector(0 to 31);
        right_half: in std_logic_vector(0 to 31);
        subkey: in std_logic_vector(0 to 47);
        left_output: out std_logic_vector(0 to 31);
        right_output: out std_logic_vector(0 to 31)
    );
end round_prog;

architecture behavior of round_prog is

    component expansion
        port(
            input: in std_logic_vector(0 to 31);
            output: out std_logic_vector(0 to 47)
        );
    end component;

    component xor_48bit
        port(
            input: in std_logic_vector(0 to 47);
            key: in std_logic_vector(0 to 47);
            output: out std_logic_vector(0 to 47)
        );
    end component;

    component combined_s_boxes
        port(
            input: in std_logic_vector(0 to 47);
            output: out std_logic_vector(0 to 31)
        );
    end component;

    component permutation_step
        port(
            input: in std_logic_vector(0 to 31);
            output: out std_logic_vector(0 to 31)
        );
    end component;

    component xor_32bit
        port(
            input: in std_logic_vector(0 to 31);
            key: in std_logic_vector(0 to 31);
            output: out std_logic_vector(0 to 31)
        );
    end component;

    -- Internal signals
    signal after_expansion: std_logic_vector(0 to 47);
    signal after_xor_48bit: std_logic_vector(0 to 47);
    signal after_sbox: std_logic_vector(0 to 31);
    signal after_permutation: std_logic_vector(0 to 31);

begin

    -- Expansion logic
    exp_inst: expansion port map(
        input => right_half,
        output => after_expansion
    );

    -- XOR with subkey
    xor_48bit_inst: xor_48bit port map(
        input => after_expansion,
        key => subkey,
        output => after_xor_48bit
    );

    -- S-box processing logic
    sbox_inst: combined_s_boxes port map(
        input => after_xor_48bit,
        output => after_sbox
    );

    -- Permutation step
    perm_inst: permutation_step port map(
        input => after_sbox,
        output => after_permutation
    );

    -- XOR with left_half to produce right_output
    xor_32bit_inst: xor_32bit port map(
        input => after_permutation,
        key => left_half,
        output => right_output
    );

    -- Pass the unchanged right_half as left_output for the next round
    left_output <= right_half;

end behavior;
