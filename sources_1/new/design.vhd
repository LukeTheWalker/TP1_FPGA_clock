----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2024 09:30:35 AM
-- Design Name: 
-- Module Name: design - Behavioral
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

entity main is
Port (  
    clk,rst     : in std_logic; 
    b1,b2       : in std_logic;
    d1,d2,d3,d4 : out std_logic_vector (3 downto 0);
    aa_led      : out std_logic
);
end main;

architecture a of main is
    signal state        : std_logic_vector (2  downto 0);
    signal a1,a2,a3,a4  : std_logic_vector (3  downto 0);
    signal aa           : std_logic;
    signal c1,c2,c3,c4  : std_logic_vector (3  downto 0);
    signal s1, s2, s3   : std_logic_vector (3 downto 0);
    signal damp1, damp2 : std_logic;
    signal snooze       : std_logic;

    procedure increment_hour (signal hd, hu : inout std_logic_vector (3  downto 0)) is
    begin
        if (hu >= x"9" and hd <= x"1") then
            hu <= hu - x"9"; hd <= hd +1;
        end if;
        if (hu >= x"3" and hd = x"2") then
            hu <= hu - x"3"; hd <= x"0";
        end if;
    end increment_hour;

    procedure increment_minute (signal md, mu : inout std_logic_vector (3  downto 0)) is
    begin
        if mu >= x"9" then
            mu <= mu - x"9"; md <= md + 1;
            if md >= x"5" then
                md <= md - x"5";
            end if;
        end if;
    end increment_minute;

    procedure increment_clock (signal hd, hu, md, mu : inout std_logic_vector (3  downto 0)) is 
    begin 
        if mu >= x"9" then
            mu <= mu - x"9"; md <= md + 1;
            if md >= x"5" then
                md <= md - x"5"; hu <= hu +1;
                increment_hour(hd,hu);
            end if;
        end if;
    end increment_clock;

    procedure advance_state (signal st : inout std_logic_vector (2  downto 0)) is
    begin
        if st = "110" then
            st <= "000";
        else
            st <= st + 1;
        end if;
    end advance_state;

    procedure secondary_function (
        signal b1, b2        : in std_logic;
        signal state         : inout std_logic_vector (2  downto 0);
        signal a1,a2,a3,a4   : inout std_logic_vector (3  downto 0);
        signal aa            : inout std_logic;
        signal c1,c2,c3,c4   : inout std_logic_vector (3  downto 0);
        signal s1, s2, s3    : inout std_logic_vector (3 downto 0);
        signal damp1, damp2  : inout std_logic) is
    
    begin
        if b1 = '1' and damp1 = '0' then
            advance_state(state);
            damp1 <= '1';
        elsif b1 = '0' then
            damp1 <= '0';
        end if;
        if b2 = '1' and damp2 = '0' then
            case state is
                when "001" => 
                    c2 <= c2 + 1;
                    increment_hour(c1,c2);
                when "010" =>
                    c4 <= c4 + 1;
                    increment_minute(c3,c4);
                when "011" =>
                    s1 <= x"0"; s2 <= x"0"; s3 <= x"1";
                when "100" => 
                    aa <= not aa;
                when "101" =>
                    a2 <= a2 + 1;
                    increment_hour(a1,a2);
                when "110" =>
                    a4 <= a4 + 1;
                    increment_minute(a3,a4);
                when others =>
                    null;
            end case;
            damp2 <= '1';
        elsif b2 = '0' then
            damp2 <= '0';
        end if;
    end secondary_function;

begin
    time_counter : process(clk,rst)
    begin
        if rst= '1' then
            c1 <= x"0"; c2 <= x"0"; c3 <= x"0"; c4 <=x"0";
            s1 <= x"0"; s2 <= x"0"; s3 <= x"0";
            state <= "000";
            a1 <= x"0"; a2 <= x"0"; a3 <= x"0"; a4 <=x"0";
            aa <= '0'; damp1 <= '0'; damp2 <= '0';
            snooze <= '0';
        elsif clk'event and clk = '1' then
            s3 <= s3+1;
            if s3 >= x"9" then
                s3 <= s3 - x"9"; s2 <= s2 + 1;
                if s2 >= x"9" then
                    s2 <= s2 - x"9"; s1 <= s1 + 1;

                    secondary_function(b1,b2,state,a1,a2,a3,a4,aa,c1,c2,c3,c4,s1,s2,s3,damp1,damp2);

                    if s1 >= x"5" then
                        s1 <= s1 - x"5"; c4 <= c4 + 1;
                        increment_clock(c1,c2,c3,c4);
                    end if;
                end if;
            else 
                secondary_function(b1,b2,state,a1,a2,a3,a4,aa,c1,c2,c3,c4,s1,s2,s3,damp1,damp2);
            end if;

            if c1 = a1 and c2 = a2 and c3 = a3 and c4 = a4 and aa = '1' and s2 = x"1" then
                snooze <= '1';
            elsif b2 = '1' and snooze = '1' then
                snooze <= '0';
            end if;

        end if;
    end process;
    
    mealy_machine : process(s1, s2, s3, c1, c2, c3, c4, a1, a2, a3, a4, state, snooze, b2)
    begin
        if snooze = '1' then
            d1 <= x"a"; d2 <= x"a"; d3 <= x"a"; d4 <= x"a";
        elsif state = "101" or state = "110" or state = "001" or state = "010" or state = "100" then
            if s3 < x"7" then
                if state = "101" or state = "110" or state = "100" then
                    d1 <= a1; d2 <= a2; d3 <= a3; d4 <= a4;
                else 
                    d1 <= c1; d2 <= c2; d3 <= c3; d4 <= c4;
                end if;
            else 
                if state = "001" then
                    d1 <= x"f"; d2 <= x"f"; d3 <= c3; d4 <= c4;
                elsif state = "010" then
                    d1 <= c1; d2 <= c2; d3 <= x"f"; d4 <= x"f";
                elsif state = "101" then
                    d1 <= x"f"; d2 <= x"f"; d3 <= a3; d4 <= a4;
                elsif state = "110" then
                    d1 <= a1; d2 <= a2; d3 <= x"f"; d4 <= x"f";
                else 
                    d1 <= x"f"; d2 <= x"f"; d3 <= x"f"; d4 <= x"f";
                end if;
            end if;
        elsif state = "011" or (state = "000" and b2 = '1') then
            d1 <= x"f"; d2 <= s1; d3 <= s2; d4 <= s3;
        else 
            d1 <= c1; d2 <= c2; d3 <= c3; d4 <= c4;
        end if;
    end process;

    aa_led <= aa;
end a;