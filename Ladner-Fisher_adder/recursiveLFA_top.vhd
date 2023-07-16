--for testing:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use IEEE.std_logic_unsigned.all;
--end of testing modifications

entity recursiveLFA_top is
--for testing:
    Generic(width : integer := 64);
    Port ( --clock : in std_logic;
           x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           s : out STD_LOGIC_VECTOR (width-1 downto 0));
--    Generic(width : integer := 64);
--    Port ( x : in STD_LOGIC_VECTOR (width-1 downto 0) := x"ef123456789adcef";
--           y : in STD_LOGIC_VECTOR (width-1 downto 0) := x"cb9876543210debb";
--           s : inout STD_LOGIC_VECTOR (width-1 downto 0));
--end of testing modifications
end recursiveLFA_top;

architecture Behavioral of recursiveLFA_top is

    component recursiveLFA_stages is
        Generic (width : integer);
        Port ( --clock : std_logic;
               x : in STD_LOGIC_VECTOR (width-1 downto 0);
               y : in STD_LOGIC_VECTOR (width-1 downto 0);
               s : out STD_LOGIC_VECTOR (width-1 downto 0);
               p, g : out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    component carry_operator is
        Port ( propLi : in STD_LOGIC;
               genrLi : in STD_LOGIC;
               propHi : in STD_LOGIC;
               genrHi : in STD_LOGIC;
               prop_o : out STD_LOGIC;
               genr_o : out STD_LOGIC);
    end component;
    
    signal xL, xH, yL, yH, sL, sH : std_logic_vector(width/2-1 downto 0);
    signal gi, pi : std_logic_vector(width-1 downto 0);
    signal po, go : std_logic_vector(width-1 downto width/2);
 
--for testing:   
--    signal test_passed : std_logic;
--end of testing modifications
    
begin

--testing performance
--process (clock) begin
--    if rising_edge(clock) then
        xL <= x(width/2-1 downto 0);
        yL <= y(width/2-1 downto 0);
        xH <= x(width-1 downto width/2);
        yH <= y(width-1 downto width/2);
--    end if;
--end process;
--end of performance test
        
LFA_rceursion_instL : recursiveLFA_stages
    generic map(width/2)
    port map (--clock, 
    xL, yL, sL, pi(width/2-1 downto 0), gi(width/2-1 downto 0));

LFA_rceursion_instH : recursiveLFA_stages
    generic map(width/2)
    port map (--clock, 
    xH, yH, sH, pi(width-1 downto width/2), gi(width-1 downto width/2));

carries_gen : for i in width/2 to width-1 generate
    carry_op_instances : carry_operator port map(
        propLi => pi(7),
        genrLi => gi(7),
        propHi => pi(i),
        genrHi => gi(i),
        prop_o => po(i),
        genr_o => go(i));
end generate;

--testing performance
--process (clock) begin
--    if rising_edge(clock) then
        s <= (sH & sL) xor (go(width-2 downto width/2) & gi(width/2-1 downto 0) & '0');
--    end if;
--end process;
--end of performance test

--for testing:
--test_passed <= '1' when s = x + y else '0';
--end of testing modifications

end Behavioral;
