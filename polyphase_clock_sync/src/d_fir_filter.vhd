library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------do zrobienia 1)signed  2)clken i reset 3)ready i valid
entity d_fir_filter is
      
      
	generic(																		   			
			AXIS_DATA_WIDTH : integer := 32;--te? potem zeby przy tb nie zapomniec 
			--FILTER_SIZE : integer := 2;
			FILTER_INDEX : integer := 0;
			OVERSAMPLING_RATE : integer := 1; 
			number_of_filters : integer := 32;
            num_of_coef : integer := 543;--51;--- number of coefficients
            coef_size       : integer :=12--13--- number of coefficient bits         
            
            );
      port (   
            aclk      : in std_logic;
            aresetn     : in std_logic; 
            aclken      : in std_logic; 
            -- Ports of Axi Slave Bus Interface s_axis   
            s_axis_data_tdata      : in signed(AXIS_DATA_WIDTH -1 downto 0);	-- by這 std_logic_vector
            s_axis_data_tready      : out std_logic;
            s_axis_data_tvalid      : in std_logic;
            
            -- Ports of Axi Master Bus Interface s_axis   
            m_axis_data_tdata      : out signed(AXIS_DATA_WIDTH -1 downto 0);	-- by這 std_logic_vector
            m_axis_data_tvalid      : out std_logic;
            m_axis_data_tready      : in std_logic
            );                                                               
            
attribute syn_useioff : boolean;
attribute syn_useioff of s_axis_data_tdata : signal is true;
attribute syn_useioff of m_axis_data_tdata : signal is true;
end d_fir_filter;

architecture d_fir_arch of d_fir_filter is   

-------------------------signals---------------------------------------------------
--constant num_of_coef : integer := 51;        --- set number of coefficients                                                                                               
--constant coef_size       : integer :=13;             --- set number of coefficient bits -- 13 because range is -4096 to 4095

type coefs_table is array (integer range <>) of integer range -1024 to 1023;           
constant sub_num_of_coeffs : integer := (num_of_coef+number_of_filters-1)/number_of_filters; -- ceil(num_of_coef/number_of_filters)	

function decimate_and_shift(base_coeffs : coefs_table; number_of_filters : integer; shift : integer)
return coefs_table is
	--variable sub_num_of_coeffs : integer := (num_of_coef+number_of_filters-1)/number_of_filters;	
	variable rv : coefs_table(sub_num_of_coeffs-1 downto 0) := (others=>0);			
	variable step : integer := number_of_filters;
begin
	for i in rv'length-1 downto 0 loop
		if (step*i >= shift and step*i-shift < base_coeffs'length) then
			rv(i) := base_coeffs(step*i-shift);
		elsif (step*i-shift >= base_coeffs'length) then
			report( "base_coeffs tabel overflowed !!!");
		else
			exit;
		end if;
	end loop;													 
	return rv;
end function decimate_and_shift;	

-- table of base coefficients		
	-- multipled licz_diff output by 512
constant coefs_const : coefs_table(num_of_coef - 1 downto 0) := (0,8,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,7,7,6,6,5,5,4,4,3,2,2,1,0,-1,-1,-2,-3,-4,-4,-5,-6,-7,-7,-8,-9,-9,-10,-10,-11,-11,-12,-12,-12,-12,-13,-13,-13,-13,-13,-13,-12,-12,-12,-11,-11,-10,-10,-9,-8,-7,-6,-6,-5,-4,-2,-1,0,1,2,4,5,6,7,9,10,11,13,14,15,16,17,19,20,21,22,22,23,24,25,25,26,26,26,26,26,26,26,25,25,24,24,23,22,21,19,18,16,15,13,11,9,7,5,3,0,-2,-5,-8,-10,-13,-16,-19,-22,-24,-27,-30,-33,-36,-39,-41,-44,-47,-49,-52,-54,-56,-58,-60,-62,-64,-65,-66,-67,-68,-69,-69,-69,-69,-69,-68,-67,-66,-65,-63,-61,-58,-56,-53,-50,-46,-43,-39,-34,-30,-25,-20,-14,-9,-3,4,10,16,23,30,37,45,52,60,67,75,83,91,99,107,115,123,130,138,146,154,161,169,176,183,190,197,203,209,215,221,226,231,236,240,244,247,250,253,255,257,259,259,260,260,259,258,257,255,253,250,246,243,238,234,228,223,216,210,203,196,188,180,171,162,153,143,133,123,113,102,92,81,69,58,47,35,23,12,0,-12,-23,-35,-47,-58,-69,-81,-92,-102,-113,-123,-133,-143,-153,-162,-171,-180,-188,-196,-203,-210,-216,-223,-228,-234,-238,-243,-246,-250,-253,-255,-257,-258,-259,-260,-260,-259,-259,-257,-255,-253,-250,-247,-244,-240,-236,-231,-226,-221,-215,-209,-203,-197,-190,-183,-176,-169,-161,-154,-146,-138,-130,-123,-115,-107,-99,-91,-83,-75,-67,-60,-52,-45,-37,-30,-23,-16,-10,-4,3,9,14,20,25,30,34,39,43,46,50,53,56,58,61,63,65,66,67,68,69,69,69,69,69,68,67,66,65,64,62,60,58,56,54,52,49,47,44,41,39,36,33,30,27,24,22,19,16,13,10,8,5,2,0,-3,-5,-7,-9,-11,-13,-15,-16,-18,-19,-21,-22,-23,-24,-24,-25,-25,-26,-26,-26,-26,-26,-26,-26,-25,-25,-24,-23,-22,-22,-21,-20,-19,-17,-16,-15,-14,-13,-11,-10,-9,-7,-6,-5,-4,-2,-1,0,1,2,4,5,6,6,7,8,9,10,10,11,11,12,12,12,13,13,13,13,13,13,12,12,12,12,11,11,10,10,9,9,8,7,7,6,5,4,4,3,2,1,1,0,-1,-2,-2,-3,-4,-4,-5,-5,-6,-6,-7,-7,-8,-8,-8,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-8,-8,25,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); 
--(0,51,74,82,70,35,-16,-74,-132,-167,-175,-136,-43,101,284,486,688,859,976,1019,968,828,603,315,0,-315,-603,-828,-968,-1019,-976,-859,-688,-486,-284,-101,43,136,175,167,132,74,16,-35,-70,-82,-74,-51,-19,0);

-- table of sub coefficients		
constant coefs : coefs_table(sub_num_of_coeffs - 1 downto 0) := decimate_and_shift(coefs_const, number_of_filters, FILTER_INDEX);


type mult_table is array (num_of_coef - 1 downto 0) of signed (((coef_size)+(s_axis_data_tdata'length))-1 downto 0); 

type add_table is array (num_of_coef - 1 downto 0) of signed (((coef_size)+(s_axis_data_tdata'length)) +6 -1 downto 0);        -- +6 becouse we have 51 coefs to write it binary we need 6 bits

constant zero : std_logic_vector (((coef_size)+(s_axis_data_tdata'length))+6 -1 downto 0) := (others => '0');      --zeros vector with the same length as add_table vectors


signal mult : mult_table := (others => (others => '0'));       
signal add : add_table := (others => (others => '0')); 
signal data : signed(s_axis_data_tdata'range):= (others => '0'); -- by這 std_logic_vector
--type DINS_TYPE is array(N-1 downto 0) of std_logic_vector(s_axis_data_tdata'range);
--signal DINS : DINS_TYPE;
--attribute syn_multstyle : string;
--attribute syn_multstyle of fir_arch : architecture is "logic";                          


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

begin
process(aclk,aresetn,aclken)         

      --variable full_out : STd_logic_vector(32 downto 0);
begin        
      if aresetn = '0' then  --reset low level active
            mult <= (others => (others => '0'));
            add <= (others => (others => '0'));
            data <=(others => '0');
            m_axis_data_tdata <= (others => '0');
      elsif rising_edge(aclk)  then 
            if aclken = '1' then         -- clock enable             
                  if (s_axis_data_tvalid = '1') then
                        data<= s_axis_data_tdata;            -- assign input data to variable         
                        --DINS <= DINS(N-2 downto 0) & data;
                        for i in  sub_num_of_coeffs - 1 downto 0  loop-- loop that make convolution
                              --mult(i) <=  to_signed((coefs(num_of_coef - 1 -i)),coef_size)*signed(data);  -- multiplicate data with coeficients
                              mult(i) <= to_signed((coefs(sub_num_of_coeffs - 1 -i)),coef_size) * signed(data);
                              if i = 0 then
                                    add(i) <= signed(zero) + mult(0);                                                                                      -- add vector is shift register
                              else
                                    add(i) <= mult(i) + add(i-1);
                              end if;
                        end loop;
						m_axis_data_tdata <= add(sub_num_of_coeffs-1)(31 downto 0);--LSB not MSB(((coef_size)+(s_axis_data_tdata'length))+6 -1 downto ((coef_size)+(s_axis_data_tdata'length)) +6 - m_axis_data_tdata'length));           
                        -- by這 to: m_axis_data_tdata <= std_logic_vector(add(num_of_coef-1)(31 downto 0));--LSB not MSB(((coef_size)+(s_axis_data_tdata'length))+6 -1 downto ((coef_size)+(s_axis_data_tdata'length)) +6 - m_axis_data_tdata'length));           
                        --full_out :=  std_logic_vector(add(num_of_coef-1));
                  end if;       
            end if;
      end if;         
end process;  

s_axis_data_tready <= m_axis_data_tready;
m_axis_data_tvalid <= s_axis_data_tvalid;

end d_fir_arch;