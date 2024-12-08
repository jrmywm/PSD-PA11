library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encryption_prog4 is
port(	
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		enable : in STD_LOGIC;
		input: in std_logic_vector(0 to 63);
		key: in std_logic_vector(0 to 63);
		output: out std_logic_vector(0 to 63));
end encryption_prog4;

architecture behavior of encryption_prog4 is

	component init_permuting
	port(	input: in std_logic_vector(0 to 63);
		right_half_permutation: out std_logic_vector(0 to 31);
		left_half_permutation: out std_logic_vector(0 to 31));
	end component;

	component permutation_key_one
	port(	key: in std_logic_vector(0 to 63);
		left_key_permutation: out std_logic_vector(0 to 27);
		right_key_permutation: out std_logic_vector(0 to 27));
	end component;

	component subkey_generation
	generic(shifting_parameter: std_logic_vector(0 to 1);
		left_or_right: std_logic_vector(0 to 0));
	port(	left_key_in: in std_logic_vector(0 to 27);
		right_key_in: in std_logic_vector(0 to 27);
		subkey: out std_logic_vector(0 to 47);
		left_key_out: out std_logic_vector(0 to 27);
		right_key_out: out std_logic_vector(0 to 27));
	end component;

	component round_prog
	port(	left_half: in std_logic_vector(0 to 31);
		right_half: in std_logic_vector(0 to 31);
		subkey: in std_logic_vector(0 to 47);
		left_output: out std_logic_vector(0 to 31);
		right_output: out std_logic_vector(0 to 31));
	end component;

	component left_right_64bit_swap
	port(	input_left: in std_logic_vector(0 to 31);
		input_right: in std_logic_vector(0 to 31);
		output_left: out std_logic_vector(0 to 31);
		output_right: out std_logic_vector(0 to 31));
	end component;

	component init_permutation_reverse
	port(	left_half_permutation: in std_logic_vector(0 to 31);
		right_half_permutation: in std_logic_vector(0 to 31);
		output: out std_logic_vector(0 to 63));
	end component;


	signal permuted_right_half: std_logic_vector(0 to 31);
	signal permuted_left_half: std_logic_vector(0 to 31);
	signal left_key: std_logic_vector(0 to 27);
	signal right_key: std_logic_vector(0 to 27);
	signal subkey_generated1,subkey_generated2,subkey_generated3,subkey_generated4,subkey_generated5,subkey_generated6,subkey_generated7,subkey_generated8,subkey_generated9,subkey_generated10,subkey_generated11,subkey_generated12,subkey_generated13,subkey_generated14,subkey_generated15,subkey_generated16: std_logic_vector(0 to 47);
	signal left_key_1,left_key_2,left_key_3,left_key_4,left_key_5,left_key_6,left_key_7,left_key_8,left_key_9,left_key_10,left_key_11,left_key_12,left_key_13,left_key_14,left_key_15,left_key_16: std_logic_vector(0 to 27);
	signal right_key_1,right_key_2,right_key_3,right_key_4,right_key_5,right_key_6,right_key_7,right_key_8,right_key_9,right_key_10,right_key_11,right_key_12,right_key_13,right_key_14,right_key_15,right_key_16: std_logic_vector(0 to 27);
	signal left_half_1,left_half_2,left_half_3,left_half_4,left_half_5,left_half_6,left_half_7,left_half_8,left_half_9,left_half_10,left_half_11,left_half_12,left_half_13,left_half_14,left_half_15,left_half_16: std_logic_vector(0 to 31);
	signal right_half_1,right_half_2,right_half_3,right_half_4,right_half_5,right_half_6,right_half_7,right_half_8,right_half_9,right_half_10,right_half_11,right_half_12,right_half_13,right_half_14,right_half_15,right_half_16: std_logic_vector(0 to 31);
	signal swaped_pt_left,swaped_pt_right: std_logic_vector(0 to 31);

	type state_type is (IDLE, INITIAL_PERMUT, KEY_PERMUT1, SUBKEY_GEN1, ROUND_PROG1, SUBKEY_GEN2, ROUND_PROG2, SUBKEY_GEN3, ROUND_PROG3, SUBKEY_GEN4, ROUND_PROG4, SUBKEY_GEN5, ROUND_PROG5, SUBKEY_GEN6, ROUND_PROG6, SUBKEY_GEN7, ROUND_PROG7, SUBKEY_GEN8, ROUND_PROG8, SUBKEY_GEN9, ROUND_PROG9, SUBKEY_GEN10, ROUND_PROG10, SUBKEY_GEN11, ROUND_PROG11, SUBKEY_GEN12, ROUND_PROG12, SUBKEY_GEN13, ROUND_PROG13, SUBKEY_GEN14, ROUND_PROG14, SUBKEY_GEN15, ROUND_PROG15, SWAP, FINAL_PERMUT );
	signal state : state_type := IDLE;
begin

	process (clk, reset)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				state <= IDLE;
				permuted_right_half, permuted_left_half, left_key, right_key <= (others => '0');
				subkey_generated1, subkey_generated2, subkey_generated3, subkey_generated4, subkey_generated5,subkey_generated6,subkey_generated7,subkey_generated8,subkey_generated9,subkey_generated10,subkey_generated11,subkey_generated12,subkey_generated13,subkey_generated14,subkey_generated15,subkey_generated16 <= (others => '0');
				left_key_1,left_key_2,left_key_3,left_key_4,left_key_5,left_key_6,left_key_7,left_key_8,left_key_9,left_key_10,left_key_11,left_key_12,left_key_13,left_key_14,left_key_15,left_key_16 <= (others => '0');
				right_key_1,right_key_2,right_key_3,right_key_4,right_key_5,right_key_6,right_key_7,right_key_8,right_key_9,right_key_10,right_key_11,right_key_12,right_key_13,right_key_14,right_key_15,right_key_16 <= (others => '0');
				left_half_1,left_half_2,left_half_3,left_half_4,left_half_5,left_half_6,left_half_7,left_half_8,left_half_9,left_half_10,left_half_11,left_half_12,left_half_13,left_half_14,left_half_15,left_half_16 <= (others => '0');
				right_half_1,right_half_2,right_half_3,right_half_4,right_half_5,right_half_6,right_half_7,right_half_8,right_half_9,right_half_10,right_half_11,right_half_12,right_half_13,right_half_14,right_half_15,right_half_16 <= (others => '0');
				swaped_pt_left,swaped_pt_right <= (others => '0');
			else then
				case state is
					when IDLE =>
						if enable = '1' then
							state <= INITIAL_PERMUT;
						end if;
					when INITIAL_PERMUT =>
						s1: init_permuting port map(
							input=>input,
							right_half_permutation=>permuted_right_half,
							left_half_permutation=>permuted_left_half
						);
						state <= KEY_PERMUT1;
					when KEY_PERMUT1 =>
						s2: permutation_key_one port map(
							key=>key,
							left_key_permutation=>left_key,
							right_key_permutation=>right_key
						);
						state <= SUBKEY_GEN1
					when SUBKEY_GEN1 =>
						s3: subkey_generation generic map(
							shifting_parameter=>"01",
							left_or_right=>"0")
							port map(	left_key_in=>left_key,
									right_key_in=>right_key,
									subkey=>subkey_generated1,
									left_key_out=>left_key_1,
									right_key_out=>right_key_1
							);
						state <= ROUND_PROG1;
					when ROUND_PROG1 =>
						ss4: round_prog port map(
							left_half=>permuted_left_half,
							right_half=>permuted_right_half,
							subkey=>subkey_generated1,
							left_output=>left_half_1,
							right_output=>right_half_1
						);
						state <= SUBKEY_GEN2;
					when SUBKEY_GEN2 =>
						s5: subkey_generation generic map(
							shifting_parameter=>"01",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_1,
									right_key_in=>right_key_1,
									subkey=>subkey_generated2,
									left_key_out=>left_key_2,
									right_key_out=>right_key_2
							);
						state <= ROUND_PROG2;
					when ROUND_PROG2 =>
						s6: round_prog port map(
							left_half=>left_half_1,
							right_half=>right_half_1,
							subkey=>subkey_generated2,
							left_output=>left_half_2,
							right_output=>right_half_2
						);
						state <= SUBKEY_GEN3;
					when SUBKEY_GEN3 =>
						s7: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_2,
									right_key_in=>right_key_2,
									subkey=>subkey_generated3,
									left_key_out=>left_key_3,
									right_key_out=>right_key_3
							);
						state <= ROUND_PROG3;
					when ROUND_PROG3 =>
						s8: round_prog port map(
							left_half=>left_half_2,
							right_half=>right_half_2,
							subkey=>subkey_generated3,
							left_output=>left_half_3,
							right_output=>right_half_3);
						state <= SUBKEY_GEN4;
					when SUBKEY_GEN4 =>
						s9: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_3,
									right_key_in=>right_key_3,
									subkey=>subkey_generated4,
									left_key_out=>left_key_4,
									right_key_out=>right_key_4);
						state <= ROUND_PROG4
					when ROUND_PROG4 => 
						s10: round_prog port map(
							left_half=>left_half_3,
							right_half=>right_half_3,
							subkey=>subkey_generated4,
							left_output=>left_half_4,
							right_output=>right_half_4);
						state <= SUBKEY_GEN5;
					when SUBKEY_GEN 5 =>
						s11: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_4,
									right_key_in=>right_key_4,
									subkey=>subkey_generated5,
									left_key_out=>left_key_5,
									right_key_out=>right_key_5);
						state <= ROUND_PROG5;
					when ROUND_PROG5 =>
						s12: round_prog port map(
							left_half=>left_half_4,
							right_half=>right_half_4,
							subkey=>subkey_generated5,
							left_output=>left_half_5,
							right_output=>right_half_5);
						state <= SUBKEY_GEN6;
					when SUBKEY_GEN6 =>
						s13: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_5,
									right_key_in=>right_key_5,
									subkey=>subkey_generated6,
									left_key_out=>left_key_6,
									right_key_out=>right_key_6);
						state <= ROUND_PROG6;
					when ROUND_PROG6 => 
						s14: round_prog port map(
							left_half=>left_half_5,
							right_half=>right_half_5,
							subkey=>subkey_generated6,
							left_output=>left_half_6,
							right_output=>right_half_6);
						state <= SUBKEY_GEN 7;
					when SUBKEY_GEN 6 =>
						s15: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_6,
									right_key_in=>right_key_6,
									subkey=>subkey_generated7,
									left_key_out=>left_key_7,
									right_key_out=>right_key_7);
						state <= ROUND_PROG6;
					when ROUND_PROG6 =>
						s16: round_prog port map(
							left_half=>left_half_6,
							right_half=>right_half_6,
							subkey=>subkey_generated7,
							left_output=>left_half_7,
							right_output=>right_half_7);
						state <= SUBKEY_GEN7;
					when SUBKEY_GEN7 =>
						s17: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_7,
									right_key_in=>right_key_7,
									subkey=>subkey_generated8,
									left_key_out=>left_key_8,
									right_key_out=>right_key_8);
						state <= ROUND_PROG7;
					when ROUND_PROG7 => 
						s18: round_prog port map(
							left_half=>left_half_7,
							right_half=>right_half_7,
							subkey=>subkey_generated8,
							left_output=>left_half_8,
							right_output=>right_half_8);
						state <= SUBKEY_GEN 8;
					when SUBKEY_GEN8 =>
						s19: subkey_generation generic map(
							shifting_parameter=>"01",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_8,
									right_key_in=>right_key_8,
									subkey=>subkey_generated9,
									left_key_out=>left_key_9,
									right_key_out=>right_key_9);
						state <= ROUND_PROG8;
					when ROUND_PROG8 =>
						s20: round_prog port map(
							left_half=>left_half_8,
							right_half=>right_half_8,
							subkey=>subkey_generated9,
							left_output=>left_half_9,
							right_output=>right_half_9);
						state <= SUBKEY_GEN9;
					when SUBKEY_GEN9 =>
						s21: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_9,
									right_key_in=>right_key_9,
									subkey=>subkey_generated10,
									left_key_out=>left_key_10,
									right_key_out=>right_key_10);
						state <= ROUND_PROG9;
					when ROUND_PROG9 => 
						s22: round_prog port map(
							left_half=>left_half_9,
							right_half=>right_half_9,
							subkey=>subkey_generated10,
							left_output=>left_half_10,
							right_output=>right_half_10);
						state <= SUBKEY_GEN 10;
					when SUBKEY_GEN10 =>
						s23: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_10,
									right_key_in=>right_key_10,
									subkey=>subkey_generated11,
									left_key_out=>left_key_11,
									right_key_out=>right_key_11);
						state <= ROUND_PROG10;
					when ROUND_PROG10 =>
						s24: round_prog port map(
							left_half=>left_half_10,
							right_half=>right_half_10,
							subkey=>subkey_generated11,
							left_output=>left_half_11,
							right_output=>right_half_11);
						state <= SUBKEY_GEN11;
					when SUBKEY_GEN11 =>
						s25: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_11,
									right_key_in=>right_key_11,
									subkey=>subkey_generated12,
									left_key_out=>left_key_12,
									right_key_out=>right_key_12);
						state <= ROUND_PROG11;
					when ROUND_PROG11 => 
						s26: round_prog port map(
							left_half=>left_half_11,
							right_half=>right_half_11,
							subkey=>subkey_generated12,
							left_output=>left_half_12,
							right_output=>right_half_12);
						state <= SUBKEY_GEN 12;
					when SUBKEY_GEN12 =>
						s27: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_12,
									right_key_in=>right_key_12,
									subkey=>subkey_generated13,
									left_key_out=>left_key_13,
									right_key_out=>right_key_13);
						state <= ROUND_PROG12;
					when ROUND_PROG12 =>
						s28: round_prog port map(
							left_half=>left_half_12,
							right_half=>right_half_12,
							subkey=>subkey_generated13,
							left_output=>left_half_13,
							right_output=>right_half_13);
						state <= SUBKEY_GEN13;
					when SUBKEY_GEN13 =>
						s29: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_13,
									right_key_in=>right_key_13,
									subkey=>subkey_generated14,
									left_key_out=>left_key_14,
									right_key_out=>right_key_14);
						state <= ROUND_PROG13;
					when ROUND_PROG13 => 
						s30: round_prog port map(
							left_half=>left_half_13,
							right_half=>right_half_13,
							subkey=>subkey_generated14,
							left_output=>left_half_14,
							right_output=>right_half_14);
						state <= SUBKEY_GEN 14;
					when SUBKEY_GEN14 =>
						s31: subkey_generation generic map(
							shifting_parameter=>"10",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_14,
									right_key_in=>right_key_14,
									subkey=>subkey_generated15,
									left_key_out=>left_key_15,
									right_key_out=>right_key_15);
						state <= ROUND_PROG14;
					when ROUND_PROG14 =>
						s32: round_prog port map(
							left_half=>left_half_14,
							right_half=>right_half_14,
							subkey=>subkey_generated15,
							left_output=>left_half_15,
							right_output=>right_half_15);
							state <= SUBKEY_GEN15;
					when SUBKEY_GEN15 =>
						s33: subkey_generation generic map(
							shifting_parameter=>"01",
							left_or_right=>"0")
							port map(	left_key_in=>left_key_15,
									right_key_in=>right_key_15,
									subkey=>subkey_generated16,
									left_key_out=>left_key_16,
									right_key_out=>right_key_16);
						state <= ROUND_PROG15;
					when ROUND_PROG15 => 
						s34: round_prog port map(
							left_half=>left_half_15,
							right_half=>right_half_15,
							subkey=>subkey_generated16,
							left_output=>left_half_16,
							right_output=>right_half_16);
						state <= SWAP;
					when SWAP =>
						s35: left_right_64bit_swap port map(
							input_left=>left_half_16,
							input_right=>right_half_16,
							output_left=>swaped_pt_left,
							output_right=>swaped_pt_right);
						state <= FINAL_PERMUT;
					when FINAL_PERMUT =>
						s36: init_permutation_reverse port map(
							left_half_permutation=>swaped_pt_left,
							right_half_permutation=>swaped_pt_right,
							output=>output);
						enable <= 0;
				end case;
			end if;
		end if;
	end process;

end;


