library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_ragnar_lucasnilsson954 is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_ragnar_lucasnilsson954;

architecture Behavioral of tt_um_ragnar_lucasnilsson954 is

-- Works with hexadecimal keypad

-- Bits 0-3 represent numbers/operations. Bit 4 represents strobe.
-- Operations:
-- 10: Addition
-- 11: Subtraction
-- 12: Multiplication
-- 13: Division (rounds upwards)
signal input        : std_logic_vector(3 downto 0);
signal strobe       : std_logic;

signal strobe_sync  : std_logic;

signal strobe_ep    : std_logic;

signal number_one   : std_logic_vector(3 downto 0) := (others => '0');
signal number_two   : std_logic_vector(3 downto 0) := (others => '0');
signal operator     : std_logic_vector(3 downto 0) := (others => '0');
signal result       : std_logic_vector(7 downto 0) := (others => '0');
signal temp         : std_logic_vector(3 downto 0) := (others => '0');
signal division_iterations : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- Synchronise inputs.
    process(clk)
        begin
        if rising_edge(clk) then
            input <= ui_in(3 downto 0);
            --input_sync <= input;
            strobe <= ui_in(4);
            strobe_sync <= strobe;
        end if;
    end process;

    strobe_ep <= strobe and (not strobe_sync);

    -- Save inputs to registers when strobe is active.
    process(clk)
    begin
    if rising_edge(clk) then
        

        if strobe_ep = '1' then
            if not 
                (
                    (unsigned(number_one) = to_unsigned(0, 4)) or 
                    (unsigned(number_two) = to_unsigned(0, 4)) or 
                    (unsigned(operator) = to_unsigned(0, 4))

                ) and not (unsigned(result) = to_unsigned(0, 8)) then

                    number_one <= std_logic_vector(to_unsigned(0, 4));
                    number_two <= std_logic_vector(to_unsigned(0, 4));
                    operator <= std_logic_vector(to_unsigned(0, 4));

                if unsigned(input) > to_unsigned(0, 4) then
                    if unsigned(input) < to_unsigned(10, 4) then
                        number_one <= input;
                    else
                        operator <= input;
                    end if;
                end if;
            
            elsif unsigned(input) < to_unsigned(10, 4) then
                if unsigned(input) > to_unsigned(0, 4) then
                    if unsigned(number_one) = to_unsigned(0, 4) then
                        number_one <= input;
                    else
                        number_two <= input;
                    end if;
                end if;
            else
                operator <= input;
            end if;
        end if;
    end if;
    end process;

    
    process(clk)
    begin
    if rising_edge(clk) then
        if strobe_ep = '1' and not (unsigned(result) = to_unsigned(0, 8))  then
            result <= std_logic_vector(to_unsigned(0, 8));
            -- temp_result <= std_logic_vector(to_unsigned(0, 8));
            temp <= std_logic_vector(to_unsigned(0, 4));
            division_iterations <= std_logic_vector(to_unsigned(0, 8));
        elsif not 
            (
                (unsigned(number_one) = to_unsigned(0, 4)) or 
                (unsigned(number_two) = to_unsigned(0, 4)) or 
                (unsigned(operator) = to_unsigned(0, 4)) or
                not (unsigned(result) = to_unsigned(0, 8))

            ) then
            
            if unsigned(operator) = to_unsigned(10, 4) then
                result <= "000" & std_logic_vector(unsigned('0' & number_one) + unsigned('0' & number_two));
            elsif unsigned(operator) = to_unsigned(11, 4) then
                result <= "000" & std_logic_vector(unsigned('0' & number_one) - unsigned('0' & number_two));
            elsif unsigned(operator) = to_unsigned(12, 4) then
                result <= std_logic_vector(unsigned(number_one) * unsigned(number_two));
            elsif unsigned(operator) = to_unsigned(13, 4) and not (unsigned(number_two) = to_unsigned(0, 4)) then
                if unsigned(temp) < unsigned(number_one) then
                    temp <= std_logic_vector(unsigned(temp) + unsigned(number_two));
                    division_iterations <= std_logic_vector(unsigned(division_iterations) + to_unsigned(1, 8));
                else
                    result <= division_iterations;
                end if; 
            end if;

        end if;
    end if;
    end process;



    uo_out <= result;
    uio_out <= "00000000";
    uio_oe <= "00000000";

end Behavioral;