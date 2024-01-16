library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
	port (
		clk_clk                             : in    std_logic                    := '0'; --                       clk.clk
		opencores_i2c_0_export_0_scl_pad_io : inout std_logic                    := '0'; --  opencores_i2c_0_export_0.scl_pad_io
		opencores_i2c_0_export_0_sda_pad_io : inout std_logic                    := '0'; --                          .sda_pad_io
		pio_0_external_connection_export    : out   std_logic_vector(3 downto 0);        -- pio_0_external_connection.export
		pio_2_external_connection_export    : out   std_logic_vector(3 downto 0);        -- pio_2_external_connection.export
		pio_3_external_connection_export    : out   std_logic_vector(3 downto 0);        -- pio_3_external_connection.export
		reset_reset_n                       : in    std_logic                    := '0'  --                     reset.reset_n
	);
end entity top_level;

architecture rtl of top_level is
	
	component xyz is
		port (
			clk_clk                             : in    std_logic                    := 'X'; -- clk
			pio_0_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_2_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			pio_3_external_connection_export    : out   std_logic_vector(3 downto 0);        -- export
			reset_reset_n                       : in    std_logic                    := 'X'; -- reset_n
			opencores_i2c_0_export_0_scl_pad_io : inout std_logic                    := 'X'; -- scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io : inout std_logic                    := 'X'  -- sda_pad_io
		);
	end component xyz;

	begin
	
	u0 : component xyz
		port map (
			clk_clk                             => clk_clk,                             --                       clk.clk
			pio_0_external_connection_export    => pio_0_external_connection_export,    -- pio_0_external_connection.export
			pio_2_external_connection_export    => pio_2_external_connection_export,    -- pio_2_external_connection.export
			pio_3_external_connection_export    => pio_3_external_connection_export,    -- pio_3_external_connection.export
			reset_reset_n                       => reset_reset_n,                       --                     reset.reset_n
			opencores_i2c_0_export_0_scl_pad_io => opencores_i2c_0_export_0_scl_pad_io, --  opencores_i2c_0_export_0.scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io => opencores_i2c_0_export_0_sda_pad_io  --                          .sda_pad_io
		);
end architecture rtl; -- of xyz

