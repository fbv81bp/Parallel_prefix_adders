library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity kogge_stone_adder is
    Generic (log2width : integer := 5);
    Port ( Ain : in STD_LOGIC_VECTOR (31 downto 0) := x"abcd1f09";
           Bin : in STD_LOGIC_VECTOR (31 downto 0) := x"cdcdee07";
           So : out STD_LOGIC_VECTOR (31 downto 0);
           Co : out STD_LOGIC);
end kogge_stone_adder;

architecture Behavioral of kogge_stone_adder is

constant width : integer := 2**log2width;

type nT  is array (0 to log2width) of std_logic_vector(width - 1 downto 0);

signal G, P : nT;
signal C : std_logic_vector(width   downto 0);

begin

G(0) <= Ain and Bin;
P(0) <= Ain xor Bin;

gen0 : for d in 0 to log2width - 1 generate
    gen1 : for i in 2**d to width - 1 generate
        G(d+1)(i) <= G(d)(i) or (P(d)(i) and G(d)(i - 2**d));
        P(d+1)(i) <= P(d)(i) and P(d)(i - 2**d);
    end generate;
    gen2 : for i in 0 to 2**d - 1 generate
        G(d+1)(i) <= G(d)(i);
        P(d+1)(i) <= P(d)(i);
    end generate;
end generate;

C(0) <= '0';
C(C'high downto 1) <= G(G'high);

So <= P(0) xor C(width-1 downto 0);
Co <= C(C'high);

end Behavioral;
