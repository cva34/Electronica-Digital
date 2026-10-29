entity gen_sinc is 
	port(
		en:in bit;
		rst:in bit;
		clk:in bit;
		
		video_on: out bit;
		h_sync: out bit;
		v_sync: out bit;
		
		pixel_x: out bit_vector(9 downto 0);
		pixel_y: out bit_vector (9 downto 0);
		
		sel_canal_s: out bit_vector(1 downto 0)
		);
	end entity;
	
	architecture gen_sinc_arc of gen_sinc is 
		
		
		--CONTADOR HORIZONTAL
		component cont_h is 
			generic ( N:positive := 10);
			port( 
				clk  : in  bit;
				rst : in  bit;
				ena  : in  bit;
				q    : out bit_vector(N-1 downto 0);
				co   : out bit
				);
		end component;
		
		
		--CONTADOR VERTICAL
		component cont_v is 
			generic ( N:positive := 10);
			port(
				clk  : in  bit;
				rst : in  bit;
				ena  : in  bit;
				q    : out bit_vector(N-1 downto 0)
				);
		end component;
		
		
		--LOGICA DE INTERVALOS
		component logic_int is 
			port(
				en_a: in bit;
				en_b: in bit;
				q_in:in bit;
				q_out: out bit
				);
		end component;	


		-- FFD SIN RST ASINCRONICO
		component ffd_srst is 
			port(
				 d : in bit;
				srst: in bit;
				clk : in bit;
				q : out bit
				);
		end component;
		
		--carry
		
		signal carry: bit;
		
		
		--Salidas de los contadores
		
		signal qout_h: bit_vector(9 downto 0);
		signal qout_v: bit_vector(9 downto 0);
		

		
		
		--VIDEO_ON
		--Entrada y Salida de la logica de intervalos
		
		signal en_a_aux_h: bit;
		signal en_b_aux_h: bit;
		signal en_a_aux_v: bit;
		signal en_b_aux_v: bit;
		
		signal q_nxt_aux_h: bit;
		signal q_nxt_aux_v: bit;
		
		
		--Salidas de los ffd para video_on
		
		signal h_vidon: bit;
		signal v_vidon: bit;
		
		
		
		
		
		--SINCRONISMOS
		
			--Los contadores ya estan instanciados, faltan ffd y logica_int
			
			--Entrada y Salida de la logica de intervalos
			
			signal en_a_sync_h: bit;
			signal en_b_sync_h: bit;
			signal en_a_sync_v: bit;
			signal en_b_sync_v: bit;
		
			signal q_nxt_sync_h: bit;
			signal q_nxt_sync_v: bit;
			
			
			--Salida FFD
			signal h_sync_pura: bit;
			signal v_sync_pura:bit;
		
		
			--BANDAS 

			signal banda_1_s : bit;--_vector(6 downto 0);
			signal banda_2_s : bit;--_vector ( 6 downto 0);
			signal banda_3_s : bit;--_vector (6 downto 0);
		
		
		
		
		begin
			
		--CONTADOR HORIZONTAL
			
			--INSTANCIO
			contadorH_inst: cont_h
				port map(
						clk => clk,
						rst => rst,
						ena =>en,
						q => qout_h,
						co => carry
						);
						
					
					
					
			ffd_h_inst:ffd_srst 
				port map(
					d => q_nxt_aux_h,
					q => h_vidon,
					clk => clk,
					srst => rst
					);
					
			logica_h_inst: logic_int
				port map(
						en_a => en_a_aux_h,
						en_b => en_b_aux_h,
						q_in => h_vidon,
						q_out => q_nxt_aux_h
						);
			
			
			--CONEXIONES
			
			-- 799 = 1100011111
			-- Se detecta 799 para activar h_vidon
			-- en el mismo flanco en que pixel_x pasa a 0.
			
			en_a_aux_h <= qout_h(9) and 
						qout_h(8) and
						not qout_h(7) and
						not qout_h(6) and 
						not qout_h(5) and 
						qout_h(4) and 
						qout_h(3) and 
						qout_h(2) and 
						qout_h(1) and 
						qout_h(0);
						
			--1001111111
			en_b_aux_h <=qout_h(9) and 
						not qout_h(8) and
						not qout_h(7) and
						qout_h(6) and 
						qout_h(5) and 
						qout_h(4) and 
						qout_h(3) and 
						qout_h(2) and 
						qout_h(1) and 
						qout_h(0);
						
						
						
						
		--CONTADOR VERTICAL
			
			--INSTANCIO
			contadorV_inst: cont_v
				port map(
						clk => clk,
						rst => rst,
						ena =>carry,
						q => qout_v
						);
						
					
					
					
			ffd_v_inst:ffd_srst 
				port map(
					d => q_nxt_aux_v,
					q => v_vidon,
					clk => clk,
					srst => rst
					);
					
			logica_v_inst: logic_int
				port map(
						en_a => en_a_aux_v,
						en_b => en_b_aux_v,
						q_in => v_vidon,
						q_out => q_nxt_aux_v
						);
			
			
			--CONEXIONES
			
		-- 524 = 1000001100
		-- Al terminar la línea 524 se prepara la activación,
		-- de manera que v_vidon = 1 al entrar en y=0.
			en_a_aux_v <= qout_v(9) and 
						not qout_v(8) and
						not qout_v(7) and
						not qout_v(6) and 
						not qout_v(5) and 
						not qout_v(4) and 
						qout_v(3) and 
						qout_v(2) and 
						not qout_v(1) and 
						not qout_v(0) and
						carry;
						
		-- 479 = 0111011111
		-- Se desactiva al terminar la línea 479,
		-- para que v_vidon = 0 al entrar en y=480.
			
			en_b_aux_v <= not qout_v(9) and 
						 qout_v(8) and
						 qout_v(7) and
						 qout_v(6) and 
					 not qout_v(5) and 
						 qout_v(4) and 
						 qout_v(3) and 
						 qout_v(2) and 
						 qout_v(1) and 
						 qout_v(0) and
						 carry;
						 
		
			video_on <= v_vidon and h_vidon;
			
			
		
		-- SINCRONISMOS
					
		--INSTANCIO 
		
			-- HORIZONTAL
			ffd_h_inst_sync:ffd_srst 
				port map(
					d => q_nxt_sync_h,
					q => h_sync_pura,
					clk => clk,
					srst => rst
					);
					
			logica_h_inst_sync: logic_int
				port map(
						en_a => en_a_sync_h,
						en_b => en_b_sync_h,
						q_in => h_sync_pura,
						q_out => q_nxt_sync_h
						);
			
			--1010001111
			en_a_sync_h <= qout_h(9) and 
						not qout_h(8) and
						qout_h(7) and
						not qout_h(6) and 
						not qout_h(5) and 
						not qout_h(4) and 
						qout_h(3) and 
						qout_h(2) and 
						qout_h(1) and 
						qout_h(0);
			--1011101111		
			en_b_sync_h <= qout_h(9) and 
						not qout_h(8) and
						qout_h(7) and
						qout_h(6) and 
						qout_h(5) and 
						not qout_h(4) and 
						qout_h(3) and 
						qout_h(2) and 
						qout_h(1) and 
						qout_h(0);
						
			
			h_sync <= not h_sync_pura;
			
			
			--VERTICAL
			ffd_v_inst_sync:ffd_srst 
				port map(
					d => q_nxt_sync_v,
					q => v_sync_pura,
					clk => clk,
					srst => rst
					);
					
			logica_v_inst_sync: logic_int
				port map(
						en_a => en_a_sync_v,
						en_b => en_b_sync_v,
						q_in => v_sync_pura,
						q_out => q_nxt_sync_v
						);
						
		-- 489 = 0111101001
		-- Se detecta al terminar la línea 489 para que
		-- v_sync se active exactamente al entrar en y=490.
		
			en_a_sync_v <= not qout_v(9) and 
						qout_v(8) and
						qout_v(7) and
						qout_v(6) and 
						qout_v(5) and 
						not qout_v(4) and 
						qout_v(3) and 
						not qout_v(2) and 
						not qout_v(1) and 
						qout_v(0) and
						carry;
						
			-- 491 = 0111101011
			-- Se detecta al terminar la línea 491 para que
			-- v_sync vuelva a 1 exactamente al entrar en y=492.
			en_b_sync_v <= not qout_v(9) and 
						qout_v(8) and
						qout_v(7) and
						qout_v(6) and 
						qout_v(5) and 
						not qout_v(4) and 
						qout_v(3) and 
						not qout_v(2) and 
						qout_v(1) and 
						qout_v(0) and 
						carry;
			
			v_sync <= not v_sync_pura;
			
			
			
		
		pixel_x <= qout_h;
		pixel_y <= qout_v;
		
		
		
	-- BANDAS VERTICALES PARA SELECCION DE CANAL
-- Filas   0 a 127: banda 1, sel = 00 (canal 1)
-- Filas 128 a 255: banda 2, sel = 01 (canal 2)
-- Filas 256 a 383: banda 3, sel = 10 (canal 3)
		
		
			banda_1_s <= not qout_v(9) and
						 not qout_v(8) and
						 not qout_v(7);
			 
		
			banda_2_s <= not qout_v(9) and
						 not qout_v(8) and
								qout_v(7);
			 
			banda_3_s <= not qout_v(9) and
							 qout_v(8) and
						not qout_v(7);
		
			sel_canal_s(0) <= banda_2_s;
			sel_canal_s (1) <= banda_3_s;
			
			
			 
			 
			 
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	end architecture;
		
			
					