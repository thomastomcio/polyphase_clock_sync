library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;	
use ieee.numeric_std.all;

	-- Add your library and packages declaration here ...

entity fir_filter_4_tb is
end fir_filter_4_tb;

architecture TB_ARCHITECTURE of fir_filter_4_tb is
	-- Component declaration of the tested unit
	component fir_filter_4
	port(
		i_clk : in STD_LOGIC;
		i_rstb : in STD_LOGIC;
		i_coeff_0 : in STD_LOGIC_VECTOR(7 downto 0);
		i_coeff_1 : in STD_LOGIC_VECTOR(7 downto 0);
		i_coeff_2 : in STD_LOGIC_VECTOR(7 downto 0);
		i_coeff_3 : in STD_LOGIC_VECTOR(7 downto 0);
		i_data : in STD_LOGIC_VECTOR(7 downto 0);
		o_data : out STD_LOGIC_VECTOR(9 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal i_clk : STD_LOGIC;
	signal i_rstb : STD_LOGIC;
	signal i_coeff_0 : STD_LOGIC_VECTOR(7 downto 0);
	signal i_coeff_1 : STD_LOGIC_VECTOR(7 downto 0);
	signal i_coeff_2 : STD_LOGIC_VECTOR(7 downto 0);
	signal i_coeff_3 : STD_LOGIC_VECTOR(7 downto 0);
	signal i_data : STD_LOGIC_VECTOR(7 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal o_data : STD_LOGIC_VECTOR(9 downto 0);

	-- Add your code here ...		 
	constant T: time:= 20ns;

begin

	-- Unit Under Test port map
	UUT : fir_filter_4
		port map (
			i_clk => i_clk,
			i_rstb => i_rstb,
			i_coeff_0 => i_coeff_0,
			i_coeff_1 => i_coeff_1,
			i_coeff_2 => i_coeff_2,
			i_coeff_3 => i_coeff_3,
			i_data => i_data,
			o_data => o_data
		);

	-- Add your stimulus here ...	 
-- coeff
i_coeff_0 <= std_logic_vector(to_unsigned(0, i_coeff_0'length));
i_coeff_1 <= std_logic_vector(to_unsigned(10, i_coeff_1'length));
i_coeff_2 <= std_logic_vector(to_unsigned(10, i_coeff_2'length));
i_coeff_3 <= std_logic_vector(to_unsigned(0, i_coeff_3'length));

-- clk
clk : process
begin
  i_clk <= '0';
  wait for T/2;
  i_clk <= '1';
  wait for T/2;
end process	;

-- data
data : process
begin	 
  wait for T/4;	
  i_data <= std_logic_vector(to_unsigned(0, i_data'length));
  wait for T/2;	
  i_data <= std_logic_vector(to_unsigned(10, i_data'length));
  wait for T/2;	
  i_data <= std_logic_vector(to_unsigned(10, i_data'length));   
  wait for T/2;	
  i_data <= std_logic_vector(to_unsigned(0, i_data'length));
  wait for T/2	;	
end process;

-- reset
i_rstb <= '0', '1' after T/2;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fir_filter_4 of fir_filter_4_tb is
	for TB_ARCHITECTURE
		for UUT : fir_filter_4
			use entity work.fir_filter_4(rtl);
		end for;
	end for;
end TESTBENCH_FOR_fir_filter_4;

