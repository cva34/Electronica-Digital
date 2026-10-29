entity ffd_en is
    port (
        d    : in  bit;
        clk  : in  bit;
        srst : in  bit;
        ena  : in  bit;
        q    : out bit
    );
end;

architecture ffd_en_arq of ffd_en is

    component ffd is
        port (
            d    : in bit;
            arst : in bit;
            srst : in bit;
            clk  : in bit;
            q    : out bit
        );
    end component;

    component mux2a1 is
        port (
            a   : in bit;
            b   : in bit;
            s   : in bit;
            sal : out bit
        );
    end component;

    signal d_ff  : bit;
    signal q_aux : bit;

begin

    MUX : mux2a1
        port map (
            a   => d,
            b   => q_aux,
            s   => ena,
            sal => d_ff
        );

    FF : ffd
        port map (
            d    => d_ff,
            arst => '0',
            srst => srst,
            clk  => clk,
            q    => q_aux
        );

    q <= q_aux;

end;