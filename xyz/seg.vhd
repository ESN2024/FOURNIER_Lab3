library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seg_bcd is
    Port (
        cnt        : in  STD_LOGIC_VECTOR (3 downto 0);
        seg_bcd_output : out STD_LOGIC_VECTOR (7 downto 0)
    );
end seg_bcd;

architecture Behavioral of seg_bcd is
begin
    process(cnt)
    begin
        case cnt is
            when "0000" => seg_bcd_output 
					<= "11000000"; -- 0 -- le 7 segment est sensible au niveau logique bas
            when "0001" => seg_bcd_output 
					<= "11111001"; -- 1
            when "0010" => seg_bcd_output 
					<= "10100100"; -- 2
            when "0011" => seg_bcd_output 
					<= "10110000"; -- 3
            when "0100" => seg_bcd_output 
					<= "10011001"; -- 4
            when "0101" => seg_bcd_output 
					<= "10010010"; -- 5
            when "0110" => seg_bcd_output 
					<= "10000010"; -- 6
            when "0111" => seg_bcd_output 
					<= "11111000"; -- 7
            when "1000" => seg_bcd_output 
					<= "10000000"; -- 8
            when "1001" => seg_bcd_output 
					<= "10010000"; -- 9
				when "1011" => seg_bcd_output 
					<= "10111111"; -- 11 pour -
            when others => seg_bcd_output 
					<= "11111111"; -- eteintend case;
		 end case;
	 end process;
end Behavioral;
