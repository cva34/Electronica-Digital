entity reg_Nbits is 
	generic (N: natural := 4);
	port (
		q : out bit_vector(N-1 downto 0);
		d: in bit_vector (N-1 downto 0);
		clk: in bit;
		rst: in bit;
		en: in bit
		);
	end entity; 
	
	architecture reg of reg_Nbits is 
		 
		signal q_int: bit_vector(N-1 downto 0);
		
		
		component ffd_en is
			port(
				d: in bit;
				srst : in bit;
				clk : in bit;
				q: out bit;
				ena: in bit
			);
		end component;
		
		begin 
			-- creo el registro con generate, osea ya tengo los N ffd que quiero
			registro: for i in 0 to N-1 generate				
				inst_ffd: ffd_en  
					port map(
							clk => clk,
							srst => rst,
							d => d(i),
							q => q_int(i),
							ena => en
						);

			end generate;
			q <= q_int; --como cree "q_int" que serian las señales inteernas, debo conectar esas señales que quedaron a la salida real
			
	end architecture;
		
		
		
			