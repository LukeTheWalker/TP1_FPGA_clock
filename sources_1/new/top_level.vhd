----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2024 09:42:09 AM
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
Port (  
    clk_5mhz,rst_og     : in std_logic; 
    b1,b2               : in std_logic;
    an                  : out std_logic_vector (3 downto 0);
    seg                 : out std_logic_vector (6 downto 0)
);

end top_level;

architecture a of top_level is
    signal clk_1khz : std_logic;
    signal counter_1 : std_logic_vector (22 downto 0);
    signal counter_2 : std_logic_vector (15 downto 0);
    signal seg_tmp : std_logic_vector (3 downto 0);
    signal an_tmp : std_logic_vector (1 downto 0);
    
    signal clk_10hz       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal d1, d2, d3, d4 : std_logic_vector(3 downto 0);

    component main
    Port (
        clk, rst       : in std_logic; 
        b1, b2              : in std_logic;
        d1, d2, d3, d4      : out std_logic_vector(3 downto 0);
        leds                : out std_logic
    );
    end component;

 begin
        -- Instantiate the Unit Under Test (UUT)
    main_block : main port map (
        clk => clk_10hz,
        rst => rst,
        b1 => b1,
        b2 => b2,
        d1 => d1,
        d2 => d2,
        d3 => d3,
        d4 => d4
    );

    first_clock_div  : process(clk_5mhz,rst_og)
    begin
        if rst_og = '1' then
            rst <= '1';
            clk_10hz <= '0';
            counter_1 <= (others => '0');
        elsif rising_edge(clk_5mhz) then
            if counter_1 = x"4C4B40" then
                counter_1 <= (others => '0');
                clk_10hz <= not clk_10hz;
            else
                counter_1 <= counter_1 + 1;
            end if;
        end if;
    end process first_clock_div;

    segment_driver : process(clk_1khz, rst_og)
    begin
        if rst_og = '1' then
            an <= (others => '0');
            an_tmp <= (others => '0');
            clk_1khz <= '0';
            seg <= (others => '0');
            counter_2 <= (others => '0');
        elsif rising_edge(clk_5mhz) then
            if counter_2 = x"0000" then
                clk_1khz <= not clk_1khz;
                an_tmp <= an_tmp + 1;
            end if;
            counter_2 <= counter_2 + 1;
        end if;
    end process segment_driver;
    
    segment_map : process(seg_tmp)
    begin
        case seg_tmp is
        when "0000" => seg <= "0000001"; -- "0"     
        when "0001" => seg <= "1001111"; -- "1" 
        when "0010" => seg <= "0010010"; -- "2" 
        when "0011" => seg <= "0000110"; -- "3" 
        when "0100" => seg <= "1001100"; -- "4" 
        when "0101" => seg <= "0100100"; -- "5" 
        when "0110" => seg <= "0100000"; -- "6" 
        when "0111" => seg <= "0001111"; -- "7" 
        when "1000" => seg <= "0000000"; -- "8"     
        when "1001" => seg <= "0000100"; -- "9" 
        when "1010" => seg <= "0000010"; -- a
        when "1011" => seg <= "1100000"; -- b
        when "1100" => seg <= "0110001"; -- C
        when "1101" => seg <= "1000010"; -- d
        when "1110" => seg <= "0110000"; -- E
        when "1111" => seg <= "0111000"; -- F
        end case;
    end process;

    led_mux : process(an_tmp)
    begin
        case an_tmp is
        when "00" =>
            an <= "0111"; 
            seg_tmp <= d1;
            -- activate LED1 and Deactivate LED2, LED3, LED4
        when "01" =>
            an <= "1011";
            seg_tmp <= d2; 
            -- activate LED2 and Deactivate LED1, LED3, LED4
        when "10" =>
            an <= "1101"; 
            seg_tmp <= d3;
            -- activate LED3 and Deactivate LED2, LED1, LED4
        when "11" =>
            an <= "1110"; 
            seg_tmp <= d4;
            -- activate LED4 and Deactivate LED2, LED3, LED1
        end case;
    end process;

end a;