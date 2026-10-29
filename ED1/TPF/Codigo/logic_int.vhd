entity logic_int is 
	port(
		en_a: in bit;
		en_b: in bit;
		q_in:in bit;
		q_out: out bit
		);
	end entity;
	

architecture logica of logic_int is

		
	signal or_aux: bit;
	signal and_aux: bit;
	
	begin	
		and_aux <= q_in and (not en_b);
		or_aux <= and_aux or en_a;
		q_out <= or_aux;
	

end architecture;
		
		