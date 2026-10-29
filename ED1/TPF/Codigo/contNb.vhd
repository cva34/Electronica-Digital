
entity contNb is
    generic (
        N : positive := 4
    );
    port (
        clk  : in  bit;
        srst : in  bit;
        ena  : in  bit;
        q    : out bit_vector(N-1 downto 0);
        co   : out bit
    );
end;

architecture contNb_arq of contNb is

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
                srst => srst,
                ena  => ena,
                q    => q_aux(i)
            );

    end generate;

    co <= ena and toggle(N-1) and q_aux(N-1);

end;
