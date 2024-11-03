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

entity tb_main is
-- No ports in the testbench
end tb_main;

architecture sim of tb_main is

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

        -- Test Case 1: Let the clock run for some time
        -- wait for 86300 sec;  -- Run the clock

        -- Test Case 2: Set the hour using b1 (state change) and b2 (adjust time)
        b1 <= '1';  -- Change state to "set hour"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "001") report "Error: State is not '001' (set hour)" severity error;

        b2 <= '1';  -- Increment hour
        wait for 1 sec;
        b2 <= '0';  -- Release button

        -- assert (c2 = "0001") report "Error: Hour is not '0001'" severity error;

        wait for 1 sec;

        -- Test Case 3: Set the minute using b1 (state change) and b2 (adjust time)
        b1 <= '1';  -- Change state to "set minute"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "010") report "Error: State is not '010' (set minute)" severity error;

        wait for 1 sec;

        b2 <= '1';  -- Increment minute
        wait for 1 sec;
        b2 <= '0';  -- Release button

        -- assert (c4 = "0001") report "Error: Minute is not '0001'" severity error;

        wait for 1 sec;

        -- Test Case 4: Set the alarm using b1 (state change) and b2 (reset seconds)
        b1 <= '1';  -- Change state to (reset seconds)
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "100") report "Error: State is not '100' (reset seconds)" severity error;

        wait for 1 sec;

        b2 <= '1';  -- Reset seconds
        wait for 1 sec;
        b2 <= '0';  -- Release button

        -- assert (secs = "0000") report "Error: Seconds are not reset" severity error; 

        wait for 1 sec;

        -- Test Case 5: Toggle alarm on and off using b1 and b2
        b1 <= '1';  -- Change state to "toggle alarm"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "011") report "Error: State is not '011' (toggle alarm)" severity error;

        wait for 1 sec;

        b2 <= '1';  -- Toggle alarm
        wait for 1 sec;
        b2 <= '0';  -- Release button

        -- assert (aa = '1') report "Error: Alarm is not enabled" severity error;

        wait for 1 sec;

        -- Test Case 6: Set the Alarm Hour using b1 (state change) and b2 (adjust time)
        b1 <= '1';  -- Change state to "set alarm hour"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "101") report "Error: State is not '101' (set alarm hour)" severity error;

        wait for 1 sec;

        b2 <= '1';  -- Increment alarm hour
        wait for 1 sec;
        b2 <= '0';  -- Release button
        
        -- assert (a2 = "0001") report "Error: Alarm Hour is not '0001'" severity error;

        wait for 1 sec;

        -- Test Case 7: Set the Alarm Minute using b1 (state change) and b2 (adjust time)
        b1 <= '1';  -- Change state to "set alarm minute"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "110") report "Error: State is not '110' (set alarm minute)" severity error;

        wait for 1 sec;

        b2 <= '1';  -- Increment alarm minute
        wait for 1 sec;
        b2 <= '0';  -- Release button

        -- assert (a4 = "0001") report "Error: Alarm Minute is not '0001'" severity error;

        wait for 1 sec;

        -- Test Case 8: Go back to the initial state
        b1 <= '1';  -- Change state to "normal"
        wait for 1 sec;
        b1 <= '0';  -- Release button

        -- assert (state = "000") report "Error: State is not '000' (normal)" severity error;

        -- Finish the simulation
        wait for 1 sec;
        wait;
    end process;

end sim;