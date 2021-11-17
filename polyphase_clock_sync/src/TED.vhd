-------------------------------------------------------------------------------
--
-- Title       : TED
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : Aldec
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\student_1\Desktop\Soko³owski_praca_dyplomowa\My_design\polyphase_clock_sync\src\TED.vhd
-- Generated   : Wed Nov 17 14:14:37 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--
-- Title       : dual_MUX
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : AGH
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\polyphase_clock_sync\src\dual_mux.vhd
-- Generated   : Sat Nov  6 14:11:09 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library work;
use work.array_type_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity TED is
	generic
		(
		CHANNELS : integer := 32;
		AXIS_DATA_WIDTH : integer := 32;  
		SAMPLES_PER_SYMBOL : integer := 2;
		OVERSAMPLING_RATE : integer := 32; -- ogólnie OVERSAMPLING_RATE = CHANNELS
		
		-- TODO: sprawdziæ potrzeb¹ szerokoœæ danych	  
		PHASE_DETECOR_GAIN : real := 1; 
		LOOP_BW : real := 0.0628;
		DAMPING_FACTOR : real := 0.707 
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		
		f_index : out std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);	  -- sprawdziæ czy nie da siê sam 'integer'
		underflow : out std_logic;
		
		filter_din : in signed(AXIS_DATA_WIDTH-1 downto 0); -- TODO: zdefiniowaæ rozmiar danych w tablicy
		dfilter_din : in signed(AXIS_DATA_WIDTH-1 downto 0)												
		
		);
end TED;

architecture TED_arch of TED is
	
	constant DENOM : real := PHASE_DETECOR_GAIN*(1 + 2*DAMPING_FACTOR*LOOP_BW + LOOP_BW*LOOP_BW); -- TODO: ustawiæ odpowiednie typy
	constant K1 : real := (4*DAMPING_FACTOR*LOOP_BW)/DENOM; -- alpha
	constant K2 : real := (4*LOOP_BW*LOOP_BW)/DENOM;		-- beta
	
	signal error : signed(dfilter_din'range) := (others => '0');
	signal f_index_sig : std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0) := 0;	-- TODO: ustaliæ typy
	signal underflow_sig : std_logic := '0';
	
	signal vp : real := 0;
	signal vi : real := 0;
	signal v : real := 0;
	signal W : real := 0;	
	signal CNT : real := 1; --modulo 1 counter
	
begin
	process(arestn, clk)					  
		variable sign : signed range -1 to 1 := 1;	-- sprawdziæ czy nie da siê na dwóch wartoœciach (-1, 1)
	begin
		if (arestn = '0') then	
			f_index <= (others => '0');
			underflow <= '0';
		elsif (rising_edge(clk)) then		
			
			if filter_din(filter_din'left) = '1' then 	-- determine sign of matched filter output
				sign := -1;
			else
				sign := 1;
			end if;
			
			-- error 
			if (underflow_sig = '1') then
				error <= sign * signed(dfilter_din(to_integer(unsigned(f_index))));
			else 
				error <= (others => '0');
			end if;
			
			-- loop filter;
			vp = K1*error;
			vi = vi + K2*error;
			v = vp + vi;
			W = 1/SAMPLES_PER_SYMBOL + v; -- update every SAMPLES_PER_SYMBOL in closed loop
			
			-- counter
			CNT = CNT - W;
			
			if (CNT_next < 0)	 then
				f_index <= std_logic_vector(integer(floor(rem(SAMPLES_PER_SYMBOL*OVERSAMPLING_RATE*abs(CNT), OVERSAMPLING_RATE)) + 1);
				CNT <= '1' + CNT;
				underflow <= '1';
			else
				underflow <= '0';
			end	if;
			
		end if;		
	end process;  	 
	
	underflow <= underflow_sig;
	f_index <= f_index_sig;
	
	
end TED_arch;
