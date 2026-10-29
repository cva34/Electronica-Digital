entity mux3a1_4b is 
	port (
		canal_1  : in  bit_vector(3 downto 0); 
        canal_2	: in  bit_vector(3 downto 0);
		canal_3 : in bit_vector (3 downto 0);
        sel  : in  bit_vector(1 downto 0);
        sal : out bit_vector(3 downto 0)
	
	);
end entity;
	
	architecture mux3a1_4b_arq of mux3a1_4b is
	
		component mux2a1_4b is
			port 
			(
				a   : in  bit_vector(3 downto 0);
				b   : in  bit_vector(3 downto 0);
				s  	: in  bit;
				sal : out bit_vector(3 downto 0)
			);
		end component; --IMPORTANTE si s=1 pasa A si s=0 pasa B
		
		signal m01 : bit_vector(3 downto 0);-- salida del mux con entrada del canal 0 y 1
		
	begin 
	
	
	
	MUX_01 : mux2a1_4b
		port map (
			a => canal_2,  
			b => canal_1,
			s => sel(0),  
			sal => m01
			);
	
	MUX_Final : mux2a1_4b
		port map (
			a => canal_3,
			b => m01,
			s => sel(1), 
			sal => sal
		);
		
	end architecture;