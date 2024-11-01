LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_top_level IS
END tb_top_level;

ARCHITECTURE behavior OF tb_top_level IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT top_level
    PORT(
         clk_100Mhz : IN  std_logic;
         rst : IN  std_logic;
         b1 : IN  std_logic;
         b2 : IN  std_logic;
         an : OUT std_logic_vector(3 downto 0);
         seg : OUT std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    
   -- Testbench signals
   SIGNAL clk_100Mhz : std_logic := '0';
   SIGNAL rst : std_logic := '0';
   SIGNAL b1 : std_logic := '0';
   SIGNAL b2 : std_logic := '0';
   SIGNAL an : std_logic_vector(3 downto 0);
   SIGNAL seg : std_logic_vector(6 downto 0);

   -- Clock period definition
   CONSTANT clk_period : time := 10 ns; -- For 100 MHz clock

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: top_level PORT MAP (
          clk_100Mhz => clk_100Mhz,
          rst => rst,
          b1 => b1,
          b2 => b2,
          an => an,
          seg => seg
        );

    -- Clock generation process
    clk_process :process
    begin
        clk_100Mhz <= '0';
        wait for clk_period/2;
        clk_100Mhz <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Reset the system
        rst <= '1';
        wait for 2 * clk_period;
        rst <= '0';

        -- wait for 10khz clock
        wait for 1000 * clk_period;
        wait;
    end process;

END;
