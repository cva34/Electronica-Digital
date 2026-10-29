entity bcd_5 is 
	port(
			en: in bit;
			q_adc: in bit;
			rst: in bit;
			clk: in bit;
			q2: out bit_vector(3 downto 0);
			q3 : out bit_vector(3 downto 0);
			q4: out bit_vector(3 downto 0)
		);
	end entity;
	
	architecture bcd of bcd_5 is 
	
		signal en_aux: bit_vector(4 downto 0);
		signal q1,q0 : bit_vector(3 downto 0);
		signal carry : bit_vector(4 downto 0);
		
		component cont_9 is
			generic(N: natural:=4);
			port (
					en: in bit;
					rst:in bit;
					q: out bit_vector(N-1 downto 0);
					clk:in bit;
					cout:out bit
				);
		end component;
		
		begin
			en_aux(0) <= q_adc and en;
			en_aux(1) <= en_aux(0) and carry(0);
			en_aux(2) <= en_aux(1) and carry(1);
			en_aux(3) <= en_aux(2) and carry(2);
			en_aux(4) <= en_aux(3) and carry(3);
			
			
			gen_cont_0: cont_9 
				port map(
						clk => clk,
						en => en_aux(0),
						rst => rst,
						q => q0,
						cout => carry(0)
						);
			
			gen_cont_1: cont_9 
				port map(
						clk => clk,
						en => en_aux(1),
						rst => rst,
						q => q1,
						cout => carry(1)
						);
			gen_cont_2: cont_9 
				port map(
						clk => clk,
						en => en_aux(2),
						rst => rst,
						q => q2,
						cout => carry(2)
						);
			gen_cont_3: cont_9 
				port map(
						clk => clk,
						en => en_aux(3),
						rst => rst,
						q => q3,
						cout => carry(3)
						);
			gen_cont_4: cont_9 
				port map(
						clk => clk,
						en => en_aux(4),
						rst => rst,
						q => q4,
						cout => carry(4)
						);
	end architecture;
				
			
			
		
				
			
								
								
	