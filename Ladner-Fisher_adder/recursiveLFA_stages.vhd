library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity recursiveLFA_stages is
    Generic(width : integer);
    Port ( --clock : std_logic;
           x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           s : out STD_LOGIC_VECTOR (width-1 downto 0);
           p, g : out STD_LOGIC_VECTOR (width-1 downto 0));
end recursiveLFA_stages;

architecture Behavioral of recursiveLFA_stages is    

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
    
begin

recursion_condition : if width > 2 generate

    xL <= x(width/2-1 downto 0);
    yL <= y(width/2-1 downto 0);
    xH <= x(width-1 downto width/2);
    yH <= y(width-1 downto width/2);
    
    LFA_recursion_instL : recursiveLFA_stages
        generic map(width/2)
        port map (--clock, 
        xL, yL, sL, pi(width/2-1 downto 0), gi(width/2-1 downto 0));
 
    LFA_recursion_instH : recursiveLFA_stages
        generic map(width/2)
        port map (--clock,
         xH, yH, sH, pi(width-1 downto width/2), gi(width-1 downto width/2));

    --testing performance
    --process (clock) begin
    --    if rising_edge(clock) then
           s <= sH & sL;
    --    end if;
    --end process;
    --end of performance test
    
end generate;

finish_recursion : if width = 2 generate

    gi <= x and y;
    pi <= x xor y;
    
    --testing performance
    --process (clock) begin
    --    if rising_edge(clock) then
            s <= pi;
    --    end if;
    --end process;
    --end of performance test
    
end generate;

carries_gen : for i in width/2 to width-1 generate
    
    carry_op_instances : carry_operator port map(
        propLi => pi(width/2-1),
        genrLi => gi(width/2-1),
        propHi => pi(i),
        genrHi => gi(i),
        prop_o => po(i),
        genr_o => go(i));

end generate;

--testing performance
--process (clock) begin
--    if rising_edge(clock) then
        g <= go & gi(width/2-1 downto 0);
        p <= po & pi(width/2-1 downto 0);
--    end if;
--end process;
--end of performance test

end Behavioral;
