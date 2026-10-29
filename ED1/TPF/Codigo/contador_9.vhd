entity cont_9 is 
	generic (N: natural:= 4);
	port(
			en: in bit;
			rst:in bit;
			q: out bit_vector(N-1 downto 0);
			clk:in bit;
			cout:out bit
		);
end entity;

architecture cont of cont_9 is 

	signal q_int : bit_vector( N-1 downto 0);
	signal d_int : bit_vector( N-1 downto 0);
	-- signal : bit_vector( N-1 downto 0);
	
	component ffd_en is 
		port(
				d: in bit;
				clk: in bit;
				srst: in bit;
				ena: in bit;
				q: out bit
			);
	end component;
	
	begin 
		genn_ffd: for i in 0 to N-1 generate
		begin
			inst_ffd: ffd_en 
				port map(
						clk => clk,
						d => d_int(i),
						q => q_int(i),
						srst => rst,
						ena => en
						);
			end generate;
		
		--ffd0
		d_int(0) <= not q_int(0);
    
		d_int(1) <= (q_int(1) and not q_int(0)) or (not q_int(3) and not q_int(1) and q_int(0));
    
		d_int(2) <= (q_int(2) and not q_int(1)) or (q_int(2) and not q_int(0)) or (not q_int(2) and q_int(1) and q_int(0));
    
		d_int(3) <= (q_int(3) and not q_int(0)) or (q_int(2) and q_int(1) and q_int(0));
		
		cout <= q_int(3) and q_int(0);
		q <= q_int;
		
		
		
end architecture;
			