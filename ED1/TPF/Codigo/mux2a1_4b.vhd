entity mux2a1_4b is
    port (
        a   : in  bit_vector(3 downto 0);
        b   : in  bit_vector(3 downto 0);
        s   : in  bit;
        sal : out bit_vector(3 downto 0)
    );
end;

architecture mux2a1_4b_arq of mux2a1_4b is

    component mux2a1 is
        port (
            a   : in  bit;
            b   : in  bit;
            s   : in  bit;
            sal : out bit
        );
    end component;

begin

    gen_mux : for i in 0 to 3 generate

        MUX_i : mux2a1
            port map (
                a   => a(i),
                b   => b(i),
                s   => s,
                sal => sal(i)
            );

    end generate;

end;