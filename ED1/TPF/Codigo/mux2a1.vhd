entity mux2a1 is
   
    port (
        a : in bit;
		b : in bit;
		s : in bit;
		sal : out bit
    );
end;

architecture mux2a1_arq of mux2a1 is
	-- Parte declarativa
	
begin
	-- Parte descriptiva

	sal <= (s and a)or ((not s)and b);

end;