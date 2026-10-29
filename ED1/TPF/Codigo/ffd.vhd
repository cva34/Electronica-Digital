entity ffd is
   
    port (
        d : in bit;
		arst : in bit;
		srst: in bit;
		clk : in bit;
		q : out bit
    );
end;

architecture ffd_arq of ffd is

	
begin
	process(clk,arst)
	begin
		if arst = '1' then
			q<= '0';
		elsif clk'event and clk = '1' then
			if srst = '1' then
				q<= '0';
			else
				q<= d;
			end if;
		end if;
		
	end process;
	
	
	
end;