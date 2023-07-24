library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decoder is
    Port (
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC; -- Reset signal
        running_state : in STD_LOGIC; -- Running state signal
        Row : in  STD_LOGIC_VECTOR (3 downto 0);
        Col : out  STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0);
        zeropressed: out std_logic;
        KeyPressed : out STD_LOGIC
    );
end Decoder;

architecture Behavioral of Decoder is

    signal sclk : STD_LOGIC_VECTOR(19 downto 0);
    signal AnyKeyPressed : STD_LOGIC := '0'; -- Initialize to '0'
    signal zeropressedkey: std_logic := '0';

begin

    process(clk, reset, running_state) -- Sensitivity to clk, reset, and running_state signals
    begin 
        if reset = '1' then
            -- Reset condition
            sclk <= (others => '0');
            AnyKeyPressed <= '0';
            Col <= (others => '0');
            DecodeOut <= (others => '0');
            zeropressedkey <= '0';
        elsif clk'event and clk = '1' and running_state = '1' then
            -- Normal operation

            -- 1ms
            if sclk = "00011000011010100000" then 
                --C1
                Col <= "0111";
                sclk <= sclk+1;

            -- check row pins
            elsif sclk = "00011000011010101000" then   
                --R1
                if Row = "0111" then
                    DecodeOut <= "0001";   -- 1
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R2
                elsif Row = "1011" then
                    DecodeOut <= "0100"; -- 4
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R3
                elsif Row = "1101" then
                    DecodeOut <= "0111"; -- 7
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R4
                elsif Row = "1110" then
                    DecodeOut <= "0000"; -- 0
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                    zeropressedkey <='1';
                end if;

                sclk <= sclk+1;

            -- 2ms
            elsif sclk = "00110000110101000000" then    
                --C2
                Col <= "1011";
                sclk <= sclk+1;

            -- check row pins
            elsif sclk = "00110000110101001000" then   
                --R1
                if Row = "0111" then        
                    DecodeOut <= "0010"; -- 2
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R2
                elsif Row = "1011" then
                    DecodeOut <= "0101"; -- 5
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R3
                elsif Row = "1101" then
                    DecodeOut <= "1000"; -- 8
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R4
                elsif Row = "1110" then
                    DecodeOut <= "1111"; -- F
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                end if;

                sclk <= sclk+1;

            -- 3ms
            elsif sclk = "01001001001111100000" then 
                --C3
                Col <= "1101";
                sclk <= sclk+1;

            -- check row pins
            elsif sclk = "01001001001111101000" then 
                --R1
                if Row = "0111" then
                    DecodeOut <= "0011"; -- 3   
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R2
                elsif Row = "1011" then
                    DecodeOut <= "0110"; -- 6
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R3
                elsif Row = "1101" then
                    DecodeOut <= "1001"; -- 9
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R4
                elsif Row = "1110" then
                    DecodeOut <= "1110"; -- E
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                end if;

                sclk <= sclk+1;

            -- 4ms
            elsif sclk = "01100001101010000000" then              
                --C4
                Col <= "1110";
                sclk <= sclk+1;

            -- check row pins
            elsif sclk = "01100001101010001000" then 
                --R1
                if Row = "0111" then
                    DecodeOut <= "1010"; -- A
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R2
                elsif Row = "1011" then
                    DecodeOut <= "1011"; -- B
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R3
                elsif Row = "1101" then
                    DecodeOut <= "1100"; -- C
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                --R4
                elsif Row = "1110" then
                    DecodeOut <= "1101"; -- D
                    AnyKeyPressed <= '1'; -- Key pressed, set AnyKeyPressed to '1'
                end if;

                sclk <= "00000000000000000000";   

            else
                sclk <= sclk+1;  
            end if;
        end if;
    end process;

    KeyPressed <= AnyKeyPressed; -- Assign AnyKeyPressed to KeyPressed output
    zeropressed <= zeropressedkey;

end Behavioral;
