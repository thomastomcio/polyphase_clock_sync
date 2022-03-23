-------------------------------------------------------------------------------
--
-- Title       : TED_and_MUX
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : Aldec
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\student_1\Desktop\Sokolowski_praca_dyplomowa\My_design\polyphase_clock_sync\src\TED_and_MUX.vhd
-- Generated   : Tue Mar 22 12:30:19 2022
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all; -- not synthesis-able

entity TED_and_MUX is
	generic
		(
		CHANNELS : integer := 32;
		AXIS_DATA_WIDTH : integer := 32;  
		SAMPLES_PER_SYMBOL : integer := 8;
		OVERSAMPLING_RATE : integer := 32 -- ogólnie OVERSAMPLING_RATE jest zawsze równe CHANNELS
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		
		f_index : out std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
		underflow : out std_logic;
		
		s_tvalid : in std_logic;
		filter_din : in signed(AXIS_DATA_WIDTH-1 downto 0);
		dfilter_din : in signed(AXIS_DATA_WIDTH-1 downto 0);	
		
		filter_dout : out signed(AXIS_DATA_WIDTH-1 downto 0);	
		m_tvalid : out std_logic
		
		);
end TED_and_MUX;

architecture TED_and_MUX_arch of TED_and_MUX is			   

-- ##### MUX - start #####
	type state_type is (NEXT_SAMPLE, SEND_ZEROS, WAIT_FOR_UNDERFLOW);
	signal state : state_type := NEXT_SAMPLE;	  
	--signal counter : integer := 0;	   
	
	signal prev_filter_din : signed(AXIS_DATA_WIDTH-1 downto 0)	:= (others => '0');
	signal prev_dfilter_din : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
-- ##### MUX - end #####


-- ##### TED - start ##### 	 
	signal vi_saving : std_logic := '0';
	signal vi_load : std_logic := '0';

	signal TED_dfilter_din	: signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
	signal TED_filter_din : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0'); 
	signal TED_tvalid : std_logic := '0';

	constant scale : integer := 2 ** 20;		

	-- parameters used in first version (for 2 sps)
--	constant K1 : integer := integer(real(scale)*(0.0110017712591052)); --0.162525308786227;	   
--	constant K2 : integer := integer(real(scale)*(9.77243613962953e-05)); --0.014436477216089;  	   

	-- parameters used in second version (for 8 sps)	
	constant K1 : integer := integer(real(scale)*(0.570997325370878));
	constant K2 : integer := integer(real(scale)*(1.48697220148666e-05));

	signal f_index_sig : integer := 0;
	
--	signal error : integer := 0;
--	signal vp : integer := 0;
--	signal vi : integer := 0;
--	signal  v : integer := 0;
--	signal  W : integer := 0;		
-- ##### TED - end #####	  

-- ##### SHIFT_REG - start #####	  
	constant SR_MIDDLE_INDEX : integer := integer(SAMPLES_PER_SYMBOL/2 -1);

	type sps_buff is array (SAMPLES_PER_SYMBOL - 1 downto 0) of signed(AXIS_DATA_WIDTH-1 downto 0);    
	signal sr : sps_buff := (others => (others => '0')); 		  
-- ##### SHIFT_REG - end #####	  

begin			

SHIFT_REG: process(arestn, clk)			
begin				  
	if (arestn = '0') then
		sr <= (others => (others => '0'));	 		
		filter_dout <= (others => '0');	   
	elsif rising_edge(clk) then
		if( underflow = '1') then
			filter_dout <= sr(SR_MIDDLE_INDEX); 
			m_tvalid <= '1';
		else
			filter_dout <= (others => '0'); 
			m_tvalid <= '0';
		end if;		
		
		if (s_tvalid = '1') then
			for i in sr'high downto sr'low + 1 loop
				sr(i) <= sr(i - 1);
			end loop;
			
			sr(sr'low) <= filter_din;	
		end if;
			
	end if;
end process SHIFT_REG;


MUX: process(arestn, clk)
begin
	if(arestn = '0') then		
		state <= NEXT_SAMPLE;
	elsif(rising_edge(clk)) then  		
		if ( s_tvalid = '1' ) then
			prev_filter_din <= filter_din;
			prev_dfilter_din <= dfilter_din;
		else
			prev_filter_din <= prev_filter_din;
			prev_dfilter_din <= prev_dfilter_din;
		end if;
		
		case state is
			when NEXT_SAMPLE =>
--				if (s_tvalid = '1') then									
					state <= SEND_ZEROS;	
--				else	 
--					state <= NEXT_SAMPLE;
--				end if;
				  
			when SEND_ZEROS =>			 
				if (s_tvalid = '1') then
					state <= WAIT_FOR_UNDERFLOW;
				else 
					state <= SEND_ZEROS;
				end if;

			when WAIT_FOR_UNDERFLOW => 
				if (underflow = '1') then
					state <= NEXT_SAMPLE;						
				else		
					state <= SEND_ZEROS;   
				end if;		
		end case;				
	end if;	
end process MUX;

TED_filter_din <= prev_filter_din when state = NEXT_SAMPLE else (others => '0');
TED_dfilter_din <= prev_dfilter_din when state = NEXT_SAMPLE else (others => '0');
TED_tvalid <= '1' when (s_tvalid = '1' or state = NEXT_SAMPLE) else '0';

--vi_saving <= '1' when state = SEND_ZEROS and underflow /= '1' else '0';
--vi_load <= '1' when state = WAIT_3_CYCLES and counter >= 3 else '0'; 

TED: process(arestn, clk)					  
    variable aux1 : integer := 0;
	variable aux2 : integer := 0;
	variable aux3 : integer := 0;
	variable aux4 : integer := 0;
	variable aux5 : integer := 0;		  	  
	
	variable error : integer := 0;		  
	variable vp : integer := 0;		  
	variable vi : integer := 0;		  
	variable W : integer := 0;	
	variable CNT  : integer := scale; 	--modulo scale counter 
--	variable vi_saved : integer := 0;
begin
	if (arestn = '0') then	
		f_index_sig <= 0;
		underflow <= '0';
		vp := 0;
		vi := 0;
		vp := 0;
		W := 0;
		error := 0;
		CNT := scale;
--		vi_saved := 0;
	elsif (rising_edge(clk)) then
		if (TED_tvalid = '1') then
			
			-- error
			if TED_filter_din(TED_filter_din'left) = '1' then 	-- determine sign of matched filter output																 
				error := ((-1)*to_integer(TED_dfilter_din));
			else
				error := (to_integer(TED_dfilter_din));
			end if;
			
			-- loop filter;				
			vp := K1*error;
			
			--if( vi_saving = '1' ) then
--				vi_saved := vi;				
--			end if;
--			
--			if ( vi_load = '1') then
--				vi <= vi_saved;
--			end if;
			
			aux4 := K2*error;
			vi := vi + aux4;
			aux5 := vi + vp;
			W := scale/SAMPLES_PER_SYMBOL + aux5; -- update every SAMPLES_PER_SYMBOL in closed loop
		
			-- counter														   
			CNT := CNT - W; 
			
			if (CNT < 0) then
				aux1 := CNT*OVERSAMPLING_RATE;
				aux2 := aux1/W;
				aux3 := abs(aux2);
				f_index_sig <= aux3 mod (OVERSAMPLING_RATE);
				CNT := scale + CNT;
				
				underflow <= '1';
			else
				underflow <= '0';
			end	if;
		else 	-- s_tvalid = '0'
			underflow <= '0';
		end if;		
	end if;		
end process TED;  	 
	
f_index <= std_logic_vector(to_unsigned(f_index_sig, f_index'length));


end TED_and_MUX_arch;
