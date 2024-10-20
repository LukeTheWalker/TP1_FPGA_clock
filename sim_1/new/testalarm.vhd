----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2024 10:30:35 AM
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for clock and alarm functionalities
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

entity tb_alarm is
-- No ports in the testbench
end tb_alarm;

architecture sim of tb_alarm is

    -- Component declaration of the Unit Under Test (UUT)
    component main
    Port (
        clk, rst      : in std_logic; 
        b1, b2        : in std_logic;
        d1, d2, d3, d4 : out std_logic_vector(3 downto 0);
        leds          : out std_logic
    );
    end component;

    -- Signals for the testbench
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal b1, b2    : std_logic := '0';
    signal d1, d2, d3, d4 : std_logic_vector(3 downto 0);
    signal leds      : std_logic;

    -- Clock period definition (for simulation)
    constant clk_period : time := 0.1 sec;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: main port map (
        clk => clk,
        rst => rst,
        b1 => b1,
        b2 => b2,
        d1 => d1,
        d2 => d2,
        d3 => d3,
        d4 => d4,
        leds => leds
    );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 1 sec;
        rst <= '0';
        wait for 1 sec;

        wait for 60 sec;

        b1 <= '1';  -- HH
        wait for 1 sec;
        b1 <= '0';  -- Release button
        wait for 1 sec;

        b1 <= '1';  -- MM
        wait for 1 sec;
        b1 <= '0';  -- Release button
        wait for 1 sec;

        b1 <= '1';  -- secs
        wait for 1 sec;
        b1 <= '0';  -- Release button
        wait for 1 sec;

        b1 <= '1';  -- toggle
        wait for 1 sec;
        b1 <= '0';  -- Release button
        wait for 1 sec;

        b2 <= '1';  -- toggle alarm
        wait for 1 sec;
        b2 <= '0';  -- Release button
        wait for 1 sec;

        ---- Chosse alarm hour
        b1 <= '1';  -- AHH
        wait for 1 sec;
        b1 <= '0';  -- Release button

        b2 <= '1';  -- increment alarm hour
        wait for 1 sec;
        b2 <= '0';  -- Release button

        ---- Chosse alarm minute

        b1 <= '1';  -- AMM
        wait for 1 sec;
        b1 <= '0';  -- Release button
        
        b2 <= '1';  -- increment alarm minute 1
        wait for 1 sec;
        b2 <= '0';  -- Release button
        wait for 1 sec;

        b2 <= '1';  -- increment alarm minute 2
        wait for 1 sec;
        b2 <= '0';  -- Release button
        wait for 1 sec;

        b2 <= '1';  -- increment alarm minute 3
        wait for 1 sec;
        b2 <= '0';  -- Release button
        wait for 1 sec;

        -- Advance clock to trigger alarm

        -- 19 + 60 secs have passsed

        wait for 3600 sec;
        wait for 101 sec;

        -- 3781 sec have passed

        assert (leds = '1') report "Alarm did not trigger" severity error;

        b1 <= '1';  -- AHH
        wait for 1 sec;
        b1 <= '0';  -- Release button

        wait for 1000 sec;

        assert (leds = '1') report "Alarm is not ringing" severity error;

        b2 <= '1';  -- toggle alarm
        wait for 1 sec;
        b2 <= '0';  -- Release button

        wait for 1 sec;

        assert (leds = '0') report "Alarm did not stop ringing" severity error;

        -- Finish the simulation
        wait for 1 sec;
        wait;
    end process;

end sim;