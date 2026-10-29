entity cont_v is
    generic (
        N : positive := 10
    );
    port (
        clk  : in  bit;
        rst : in  bit;
        ena  : in  bit;
        q    : out bit_vector(N-1 downto 0)
    );
end;

architecture conth_arq of cont_v is

    component ffd_en is
        port (
            d    : in  bit;
            clk  : in  bit;
            srst : in  bit;
            ena  : in  bit;
            q    : out bit
        );
    end component;

    signal q_aux  : bit_vector(N-1 downto 0); --para poder leer proximo estado
    signal d_next : bit_vector(N-1 downto 0);
    signal toggle : bit_vector(N-1 downto 0);-- la cadena q dice q bit tiene q cambiar
	signal rst_propio: bit;
	signal rst_final : bit;

begin

    q <= q_aux;

    toggle(0) <= '1';--cambia siemore el bit menos sig

    gen_toggle : for i in 1 to N-1 generate
        toggle(i) <= toggle(i-1) and q_aux(i-1);
    end generate;

    gen_ff : for i in 0 to N-1 generate

        d_next(i) <= q_aux(i) xor toggle(i);

        FF_i : ffd_en
            port map (
                d    => d_next(i),
                clk  => clk,
                srst => rst_final,
                ena  => ena,
                q    => q_aux(i)
            );

    end generate;
	
	rst_propio <= q_aux(9) and 
              not q_aux(8) and
              not q_aux(7) and
              not q_aux(6) and 
              not q_aux(5) and 
              not q_aux(4) and 
              q_aux(3) and 
              q_aux(2) and 
              not q_aux(1) and 
              not q_aux(0);
	

	rst_final <= rst or (rst_propio and ena);
	

	
	

end architecture;		