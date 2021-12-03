library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;                         


-----------do zrobienia 1)signed  2)clken i reset 3)ready i valid
entity fir is
      
      
      generic(
            AXIS_IQ_TDATA_WIDTH : integer := 32;--te? potem zeby przy tb nie zapomniec   
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
end fir;

architecture fir_arch of fir is   

-------------------------signals---------------------------------------------------
--constant num_of_coef : integer := 51;        --- set number of coefficients                                                                                               
--constant coef_size       : integer :=13;             --- set number of coefficient bits -- 13 because range is -4096 to 4095
--
type coefs_table is array (num_of_coef - 1 downto 0)       of integer range -1024 to 1023;                  --            

--constant coefs : coefs_table := ("1111111110001","1111111110001","1111111110110","1111111111110", "0000000001001", "0000000010011","0000000011011", "0000000011100", "0000000010111", "0000000001001","1111111110101","1111111011110","1111111001000","1111110111011","1111110111101","1111111010101","0000000000110","0000001010010", "0000010110111","0000100101111","0000110110010","0001000110101","0001010101011","0001100001010","0001101000110","0001101011011","0001101000110","0001100001010","0001010101011","0001010101011","0000110110010","0000100101111","0000010110111","0000001010010","0000000000110","1111111010101","1111110111101","1111110111011","1111111001000","1111111011110","1111111110101","0000000001001","0000000010111","0000000011100","0000000011011","0000000010011","0000000001001","1111111111110","1111111110110","1111111110001","1111111110001");

constant coefs : coefs_table := (-1,-1,-1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,0,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,7,7,7,7,7,7,6,6,6,5,5,4,4,3,2,2,1,1,0,-1,-2,-3,-3,-4,-5,-6,-7,-8,-9,-9,-10,-11,-12,-13,-14,-15,-16,-16,-17,-18,-19,-19,-20,-21,-21,-22,-22,-22,-23,-23,-23,-23,-23,-23,-23,-23,-22,-22,-21,-21,-20,-19,-18,-17,-16,-15,-13,-12,-10,-9,-7,-5,-3,-1,1,3,6,8,11,13,16,19,21,24,27,30,34,37,40,43,46,50,53,56,60,63,67,70,73,77,80,83,87,90,93,96,99,102,105,108,111,114,116,119,121,123,126,128,129,131,133,135,136,137,138,139,140,141,141,142,142,142,142,142,141,141,140,139,138,137,136,135,133,131,129,128,126,123,121,119,116,114,111,108,105,102,99,96,93,90,87,83,80,77,73,70,67,63,60,56,53,50,46,43,40,37,34,30,27,24,21,19,16,13,11,8,6,3,1,-1,-3,-5,-7,-9,-10,-12,-13,-15,-16,-17,-18,-19,-20,-21,-21,-22,-22,-23,-23,-23,-23,-23,-23,-23,-23,-22,-22,-22,-21,-21,-20,-19,-19,-18,-17,-16,-16,-15,-14,-13,-12,-11,-10,-9,-9,-8,-7,-6,-5,-4,-3,-3,-2,-1,0,1,1,2,2,3,4,4,5,5,6,6,6,7,7,7,7,7,7,8,8,8,8,8,7,7,7,7,7,7,6,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1,0,0,0,0,-1,-1,-1,-1,-2,-2,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); 
-- (-15,-15,-10,-2,9,19,27,28,23,9,-11,-34,-56,-69,-67,-43,6,82,183,303,434,565,683,778,838,859,838,778,683,565,434,303,183,82,6,-43,-67,-69,-56,-34,-11,9,23,28,27,19,9,-2,-10,-15,-15);        -- table of coefficients

--constant coefs : coefs_table := (1,0,1);      

--constant coefs : coefs_table := ( 20  ,  44  ,  72 );--,  103,   135  , 163  , 185  , 200 ,  205 ,  200  , 185 ,  163,   135 ,  103 ,   72  ,  44  ,  20);

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
                              mult(i) <=       to_signed((coefs(num_of_coef - 1 -i)),coef_size) * signed(data);
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