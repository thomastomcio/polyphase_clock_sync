library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                       

package array_type_pkg is  
	type dout_array_t is array(natural range <>) of signed(31 downto 0);
end;	