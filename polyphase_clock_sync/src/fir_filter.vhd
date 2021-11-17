library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------do zrobienia 1)signed  2)clken i reset 3)ready i valid
entity fir_filter is
      
      
	generic(																		   			
			AXIS_IQ_TDATA_WIDTH : integer := 32;--te? potem zeby przy tb nie zapomniec 
			--FILTER_SIZE : integer := 2;
			FILTER_INDEX : integer := 0;
			OVERSAMPLING_RATE : integer := 1; 
			number_of_filters : integer := 32;
            num_of_coef : integer :=51;--51;--- number of coefficients
            coef_size       : integer :=12--13--- number of coefficient bits         
            
            );
      port (   
            aclk      : in std_logic;
            aresetn      : in std_logic; 
            aclken      : in std_logic; 
            -- Ports of Axi Slave Bus Interface s_axis   
            s_axis_data_tdata      : in std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
            s_axis_data_tready      : out std_logic;
            s_axis_data_tvalid      : in std_logic;
            
            -- Ports of Axi Master Bus Interface s_axis   
            m_axis_data_tdata      : out std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
            m_axis_data_tvalid      : out std_logic;
            m_axis_data_tready      : in std_logic
            );                                                               
            
attribute syn_useioff : boolean;
attribute syn_useioff of s_axis_data_tdata : signal is true;
attribute syn_useioff of m_axis_data_tdata : signal is true;
end fir_filter;

architecture fir_arch of fir_filter is   

-------------------------signals---------------------------------------------------
--constant num_of_coef : integer := 51;        --- set number of coefficients                                                                                               
--constant coef_size       : integer :=13;             --- set number of coefficient bits -- 13 because range is -4096 to 4095

type coefs_table is array (integer range <>) of integer range -1024 to 1023;           


function decimate_and_shift(base_coeffs : coefs_table; number_of_filters : integer; shift : integer)
return coefs_table is
	variable sub_num_of_coeffs : integer := (num_of_coef+number_of_filters-1)/number_of_filters;	
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
constant coefs_const : coefs_table(num_of_coef - 1 downto 0) := (-15,-15,-10,-2,9,19,27,28,23,9,-11,-34,-56,-69,-67,-43,6,82,183,303,434,565,683,778,838,859,838,778,683,565,434,303,183,82,6,-43,-67,-69,-56,-34,-11,9,23,28,27,19,9,-2,-10,-15,-15);
-- table of sub coefficients		
constant coefs : coefs_table := decimate_and_shift(coefs_const, number_of_filters, FILTER_INDEX);


type mult_table is array (num_of_coef - 1 downto 0) of signed (((coef_size)+(s_axis_data_tdata'length))-1 downto 0); 

type add_table is array (num_of_coef - 1 downto 0) of signed (((coef_size)+(s_axis_data_tdata'length)) +6 -1 downto 0);        -- +6 becouse we have 51 coefs to write it binary we need 6 bits

constant zero  :std_logic_vector (((coef_size)+(s_axis_data_tdata'length))+6 -1 downto 0) := (others => '0');      --zeros vector with the same length as add_table vectors


signal mult : mult_table := (others => (others => '0'));       
signal add : add_table := (others => (others => '0')); 
signal data : std_logic_vector(s_axis_data_tdata'range):= (others => '0');
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
                        data<=s_axis_data_tdata;            -- assign input data to variable         
                        --DINS <= DINS(N-2 downto 0) & data;
                        for i in  num_of_coef - 1 downto 0  loop-- loop that make convolution
                              --mult(i) <=  to_signed((coefs(num_of_coef - 1 -i)),coef_size)*signed(data);  -- multiplicate data with coeficients
                              mult(i) <= to_signed((coefs(num_of_coef - 1 -i)),coef_size) * signed(data);
                              if i = 0 then
                                    add(i) <= signed(zero) + mult(0);                                                                                      -- add vector is shift register
                              else
                                    add(i) <= mult(i) + add(i-1);
                              end if;
                        end loop;
                        m_axis_data_tdata <= std_logic_vector(add(num_of_coef-1)(31 downto 0));--LSB not MSB(((coef_size)+(s_axis_data_tdata'length))+6 -1 downto ((coef_size)+(s_axis_data_tdata'length)) +6 - m_axis_data_tdata'length));           
                        --full_out :=  std_logic_vector(add(num_of_coef-1));
                  end if;       
            end if;
      end if;         
end process;  

s_axis_data_tready <= m_axis_data_tready;
m_axis_data_tvalid <= s_axis_data_tvalid;

end fir_arch;