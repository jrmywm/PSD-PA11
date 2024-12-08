library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity s_box_1_8 is
port(    input: in std_logic_vector(0 to 47);
        output: out std_logic_vector(0 to 31));
end s_box_1_8;

architecture behavior of s_box_1_8 is

    component s_box_1 
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_2
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_3
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_4
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_5
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_6
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_7
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

    component s_box_8
    port(    input: in std_logic_vector(0 to 5);
            output: out std_logic_vector(0 to 3));
    end component;

begin
    s1: s_box_1  port map(
        input=>input(0 to 5),
        output=>output(0 to 3));

    s2: s_box_2 port map(
        input=>input(6 to 11),
        output=>output(4 to 7));

    s3: s_box_3 port map(
        input=>input(12 to 17),
        output=>output(8 to 11));

    s4: s_box_4 port map(
        input=>input(18 to 23),
        output=>output(12 to 15));

    s5: s_box_5 port map(
        input=>input(24 to 29),
        output=>output(16 to 19));

    s6: s_box_6 port map(
        input=>input(30 to 35),
        output=>output(20 to 23));

    s7: s_box_7 port map(
        input=>input(36 to 41),
        output=>output(24 to 27));

    s8: s_box_8 port map(
        input=>input(42 to 47),
        output=>output(28 to 31));
end;
