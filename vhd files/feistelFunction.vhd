library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FeistelFunction is
    Port (
        input_data  : in  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit input
        subkey      : in  STD_LOGIC_VECTOR(47 downto 0); -- 48-bit subkey
        output_data : out STD_LOGIC_VECTOR(31 downto 0)  -- 32-bit output
    );
end FeistelFunction;

architecture Behavioral of FeistelFunction is

    -- Component declarations
    component SBox is
        Port (
            input_data  : in  STD_LOGIC_VECTOR(5 downto 0); -- 6-bit input to SBox
            sbox_number : in  INTEGER range 1 to 8;         -- SBox selector (1 to 8)
            output_data : out STD_LOGIC_VECTOR(3 downto 0) -- 4-bit output from SBox
        );
    end component;

    component Permutation is
        Port (
            input_data  : in  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit input to permutation
            output_data : out STD_LOGIC_VECTOR(31 downto 0) -- 32-bit output after permutation
        );
    end component;

    -- Signals
    signal expanded_data : STD_LOGIC_VECTOR(47 downto 0) := (others => '0'); -- Expanded input
    signal sbox_inputs   : STD_LOGIC_VECTOR(47 downto 0) := (others => '0'); -- XOR with subkey
    signal sbox_outputs  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- Combined SBox outputs
    signal permuted_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- Permutation output

begin
    -- Expansion process: Expand 32-bit input_data to 48 bits (as per DES expansion table)
    process(input_data)
    begin
        -- Map each expanded_data bit from input_data using the DES expansion table
        expanded_data(0)  <= input_data(31);
        expanded_data(1)  <= input_data(0);
        expanded_data(2)  <= input_data(1);
        expanded_data(3)  <= input_data(2);
        expanded_data(4)  <= input_data(3);
        expanded_data(5)  <= input_data(4);

        expanded_data(6)  <= input_data(3);
        expanded_data(7)  <= input_data(4);
        expanded_data(8)  <= input_data(5);
        expanded_data(9)  <= input_data(6);
        expanded_data(10) <= input_data(7);
        expanded_data(11) <= input_data(8);

        expanded_data(12) <= input_data(7);
        expanded_data(13) <= input_data(8);
        expanded_data(14) <= input_data(9);
        expanded_data(15) <= input_data(10);
        expanded_data(16) <= input_data(11);
        expanded_data(17) <= input_data(12);

        expanded_data(18) <= input_data(11);
        expanded_data(19) <= input_data(12);
        expanded_data(20) <= input_data(13);
        expanded_data(21) <= input_data(14);
        expanded_data(22) <= input_data(15);
        expanded_data(23) <= input_data(16);

        expanded_data(24) <= input_data(15);
        expanded_data(25) <= input_data(16);
        expanded_data(26) <= input_data(17);
        expanded_data(27) <= input_data(18);
        expanded_data(28) <= input_data(19);
        expanded_data(29) <= input_data(20);

        expanded_data(30) <= input_data(19);
        expanded_data(31) <= input_data(20);
        expanded_data(32) <= input_data(21);
        expanded_data(33) <= input_data(22);
        expanded_data(34) <= input_data(23);
        expanded_data(35) <= input_data(24);

        expanded_data(36) <= input_data(23);
        expanded_data(37) <= input_data(24);
        expanded_data(38) <= input_data(25);
        expanded_data(39) <= input_data(26);
        expanded_data(40) <= input_data(27);
        expanded_data(41) <= input_data(28);

        expanded_data(42) <= input_data(27);
        expanded_data(43) <= input_data(28);
        expanded_data(44) <= input_data(29);
        expanded_data(45) <= input_data(30);
        expanded_data(46) <= input_data(31);
        expanded_data(47) <= input_data(0);
    end process;

    -- XOR expanded data with the subkey
    sbox_inputs <= expanded_data xor subkey;

    -- SBox substitutions: Divide sbox_inputs into 6-bit chunks, process through 8 SBoxes
    SBox1: SBox port map(input_data => sbox_inputs(47 downto 42), sbox_number => 1, output_data => sbox_outputs(31 downto 28));
    SBox2: SBox port map(input_data => sbox_inputs(41 downto 36), sbox_number => 2, output_data => sbox_outputs(27 downto 24));
    SBox3: SBox port map(input_data => sbox_inputs(35 downto 30), sbox_number => 3, output_data => sbox_outputs(23 downto 20));
    SBox4: SBox port map(input_data => sbox_inputs(29 downto 24), sbox_number => 4, output_data => sbox_outputs(19 downto 16));
    SBox5: SBox port map(input_data => sbox_inputs(23 downto 18), sbox_number => 5, output_data => sbox_outputs(15 downto 12));
    SBox6: SBox port map(input_data => sbox_inputs(17 downto 12), sbox_number => 6, output_data => sbox_outputs(11 downto 8));
    SBox7: SBox port map(input_data => sbox_inputs(11 downto 6),  sbox_number => 7, output_data => sbox_outputs(7 downto 4));
    SBox8: SBox port map(input_data => sbox_inputs(5 downto 0),   sbox_number => 8, output_data => sbox_outputs(3 downto 0));

    -- Permutation: Apply permutation on the combined SBox outputs
    Permutation_Inst: Permutation port map(
        input_data => sbox_outputs,
        output_data => permuted_data
    );

    -- Final Output Assignment
    output_data <= permuted_data;

end Behavioral;

