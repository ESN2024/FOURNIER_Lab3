library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
	port (
		clk_clk                             : in    std_logic                    := '0'; --                       clk.clk
		opencores_i2c_0_export_0_scl_pad_io : inout std_logic                    := '0'; --  opencores_i2c_0_export_0.scl_pad_io
		opencores_i2c_0_export_0_sda_pad_io : inout std_logic                    := '0'; --                          .sda_pad_io
		seg_bcd_0 : out std_logic_vector(7 downto 0);        -- pio_0_external_connection.export
		seg_bcd_1 : out std_logic_vector(7 downto 0);
		seg_bcd_2 : out std_logic_vector(7 downto 0);
		seg_bcd_3 : out std_logic_vector(7 downto 0);        -- pio_0_external_connection.export
		seg_bcd_4 : out std_logic_vector(7 downto 0);
		reset_reset_n                       : in    std_logic                    := '0'  --                     reset.reset_n
	);
end entity top_level;

architecture rtl of top_level is
	
	component xyz is
		port (
			clk_clk                             : in    std_logic                    := 'X'; -- clk
			pio_0_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_1_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_2_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_3_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_4_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			reset_reset_n                       : in    std_logic                    := 'X'; -- reset_n
			opencores_i2c_0_export_0_scl_pad_io : inout std_logic                    := 'X'; -- scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io : inout std_logic                    := 'X'  -- sda_pad_io
		);
	end component xyz;
	
	component seg_bcd is
		port (
			cnt        : in  STD_LOGIC_VECTOR (3 downto 0);
			seg_bcd_output : out STD_LOGIC_VECTOR (7 downto 0));
	end component seg_bcd;
	
	
	signal s0 : std_logic_vector(3 downto 0);
	signal s1 : std_logic_vector(3 downto 0);
	signal s2 : std_logic_vector(3 downto 0);
	signal s3 : std_logic_vector(3 downto 0);
	signal s4 : std_logic_vector(3 downto 0);


	begin
	b0 : component seg_bcd
		port map (
			seg_bcd_output => seg_bcd_0,
			cnt => s0
			); 		
	
	
	b1 : component seg_bcd 
		port map (
			seg_bcd_output => seg_bcd_1,
			cnt => s1
			); 		
	
	
	b2 : component seg_bcd 
		port map (
			seg_bcd_output => seg_bcd_2,
			cnt => s2
			); 		
			
	b3 : component seg_bcd
		port map (
			seg_bcd_output => seg_bcd_3,
			cnt => s3
			); 		
	
	
	b4 : component seg_bcd 
		port map (
			seg_bcd_output => seg_bcd_4,
			cnt => s4
			); 		
	
	
			
	
	u0 : component xyz
		port map (
			clk_clk                             => clk_clk,                             --                       clk.clk
			pio_0_external_connection_export    => s0,    -- pio_0_external_connection.export
			pio_1_external_connection_export    => s1,    -- pio_1_external_connection.export
			pio_2_external_connection_export    => s2,    -- pio_2_external_connection.export
			pio_3_external_connection_export    => s3,    -- pio43_external_connection.export
			pio_4_external_connection_export    => s4,    -- pio_2_external_connection.export
			reset_reset_n                       => reset_reset_n,                       --                     reset.reset_n
			opencores_i2c_0_export_0_scl_pad_io => opencores_i2c_0_export_0_scl_pad_io, --  opencores_i2c_0_export_0.scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io => opencores_i2c_0_export_0_sda_pad_io  --                          .sda_pad_io
		);
		
end architecture rtl; -- of xyz

