library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module_fsm is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        start     : in  std_logic;
        data_in   : in  std_logic_vector(0 to 63);
        key       : in  std_logic_vector(0 to 63);
        data_out  : out std_logic_vector(0 to 63);
        done      : out std_logic
    );
end top_module_fsm;

architecture behavior of top_module_fsm is

    -- States
    type state_type is (IDLE, ENCRYPT, DECRYPT, FINAL);
    signal current_state, next_state : state_type;

    -- Internal signals
    signal encryption_output : std_logic_vector(0 to 63);
    signal decryption_output : std_logic_vector(0 to 63);
    signal encryption_done   : std_logic := '0';
    signal decryption_done   : std_logic := '0';

    -- Components
    component encryption is
        port (
            input  : in  std_logic_vector(0 to 63);
            key    : in  std_logic_vector(0 to 63);
            output : out std_logic_vector(0 to 63);
            done   : out std_logic
        );
    end component;

    component decryption is
        port (
            input  : in  std_logic_vector(0 to 63);
            key    : in  std_logic_vector(0 to 63);
            output : out std_logic_vector(0 to 63);
            done   : out std_logic
        );
    end component;

begin
    -- Encryption Instance
    encryptor: encryption
        port map (
            input  => data_in,
            key    => key,
            output => encryption_output,
            done   => encryption_done
        );

    -- Decryption Instance
    decryptor: decryption
        port map (
            input  => encryption_output,
            key    => key,
            output => decryption_output,
            done   => decryption_done
        );

    -- FSM Process
    fsm_process: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic
    process(current_state, start, encryption_done, decryption_done)
    begin
        case current_state is
            when IDLE =>
                if start = '1' then
                    next_state <= ENCRYPT;
                else
                    next_state <= IDLE;
                end if;

            when ENCRYPT =>
                if encryption_done = '1' then
                    next_state <= DECRYPT;
                else
                    next_state <= ENCRYPT;
                end if;

            when DECRYPT =>
                if decryption_done = '1' then
                    next_state <= FINAL;
                else
                    next_state <= DECRYPT;
                end if;

            when FINAL =>
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Output Logic
    process(current_state)
    begin
        case current_state is
            when IDLE =>
                done <= '0';
                data_out <= (others => '0');

            when ENCRYPT =>
                done <= '0';
                data_out <= (others => '0');

            when DECRYPT =>
                done <= '0';
                data_out <= encryption_output;

            when FINAL =>
                done <= '1';
                data_out <= decryption_output;

            when others =>
                done <= '0';
                data_out <= (others => '0');
        end case;
    end process;

end behavior;
