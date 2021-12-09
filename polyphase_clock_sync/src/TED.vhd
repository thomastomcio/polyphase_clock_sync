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

library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all; -- not synthesis-able

entity TED is
	generic
		(
		CHANNELS : integer := 32;
		AXIS_DATA_WIDTH : integer := 32;  
		SAMPLES_PER_SYMBOL : integer := 2;
		OVERSAMPLING_RATE : integer := 32 -- ogólnie OVERSAMPLING_RATE jest zawsze równe CHANNELS
		
-- TODO: sprawdziæ potrzeb¹ szerokoœæ danych i zbadaæ potrzebne typy	  
--		PHASE_DETECOR_GAIN : real := 1.0; 
--		LOOP_BW : real := 0.0628;
--		DAMPING_FACTOR : real := 0.707 
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		
		f_index : out std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);	  -- sprawdziæ czy nie da siê sam 'integer'
		underflow : out std_logic;
		
		in_valid : in std_logic := '0';
		filter_din : in signed(AXIS_DATA_WIDTH-1 downto 0); -- TODO: zdefiniowaæ rozmiar danych w tablicy
		dfilter_din : in signed(AXIS_DATA_WIDTH-1 downto 0)												
		
		);
end TED;

architecture TED_arch of TED is
	
--  constant DENOM : real := PHASE_DETECOR_GAIN*(1 + 2*DAMPING_FACTOR*LOOP_BW + LOOP_BW*LOOP_BW); -- TODO: ustawiæ odpowiednie typy
--	constant K1 : real := (4*DAMPING_FACTOR*LOOP_BW)/DENOM; -- alpha
--	constant K2 : real := (4*LOOP_BW*LOOP_BW)/DENOM;		-- beta	
	constant K1 : real := 0.0110017712591052; --0.162525308786227;	   
	constant K2 : real := 9.77243613962953e-05; --0.014436477216089;
	
	--signal error : real := 0.0; -- signed(dfilter_din'range) := (others => '0');
	--signal f_index_sig : std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0) := (others => '0');	-- TODO: ustaliæ typy
	signal f_index_sig : integer := 0;	-- TODO: ustaliæ typy
	--signal underflow_sig : std_logic := '0';
	
--	signal vp : real := 0.0;
--	signal vi : real := 0.0;
--	signal v : real := 0.0;
--	signal W : real := 0.0;	 
--	signal CNT : real := 1.0; 	--modulo 1 counter 
	
--	signal f_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
--	signal df_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');

begin
process(arestn, clk)					  
	----variable sign : real range -1.0 to 1.0 := 1.0;	-- sprawdziæ czy nie da siê na dwóch wartoœciach (-1, 1) 
	variable temp : real := 0.0;
--	variable actual_f : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');  
--	variable actual_df : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');		
	variable error : real := 0.0;
--	variable prev_error : real := 0.0;
	variable vp : real := 0.0;
	variable  vi : real := 0.0;
	variable  v : real := 0.0;
	variable  W : real := 0.0;	
	variable  CNT : real := 1.0; 	--modulo 1 counter 
begin
	if (arestn = '0') then	
		f_index_sig <= 0; -- (others => '0');
		underflow <= '0';
		vp := 0.0;
		vi := 0.0;
		v := 0.0;
		W := 0.0;
		CNT := 1.0;
	elsif (rising_edge(clk)) then
		if (in_valid = '1') then
		
			if filter_din(filter_din'left) = '1' then 	-- determine sign of matched filter output																 
				error := (-1.0)*real(to_integer(dfilter_din))/(1024.0*1024.0);  -- integer(unsigned(f_index)))  
			else
				error := real(to_integer(dfilter_din))/(1024.0*1024.0);  -- integer(unsigned(f_index)))  
			end if;
			
			-- error 
			--error := real(to_integer(dfilter_din))/(1024.0*1024.0);  -- integer(unsigned(f_index)))  
--			prev_error := error;
			
			-- loop filter;
			vp := K1*error;
			vi := vi + K2*error;
			v := vp + vi;
			W := 1.0/real(SAMPLES_PER_SYMBOL) + v; -- update every SAMPLES_PER_SYMBOL in closed loop
		
			-- counter														   
			CNT := CNT - W;
			temp := real(SAMPLES_PER_SYMBOL*OVERSAMPLING_RATE)*abs(CNT) mod real(OVERSAMPLING_RATE);
			
			if (CNT < 0.0) then
				f_index_sig <= integer(floor(temp));
				CNT := 1.0 + CNT;
				underflow <= '1';
			else
				underflow <= '0';
			end	if;
		else -- in_valid = '0'
			underflow <= '0';
		end if;		
	end if;		
end process;  	 
	
f_index <= std_logic_vector(to_unsigned(f_index_sig, f_index'length));
	
end TED_arch;
