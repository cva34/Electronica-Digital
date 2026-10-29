entity ffd_srst is
   
    port (
        d : in bit;
		srst: in bit;
		clk : in bit;
		q : out bit
    );
end;

architecture ffd_arq of ffd_srst is

	
begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			if srst = '1' then
				q<= '0';
			else
				q<= d;
			end if;
		end if;
		
	end process;
	
	
	
end;