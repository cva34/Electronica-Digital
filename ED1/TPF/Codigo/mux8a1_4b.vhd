entity mux8a1_4b is
    port (
        e0  : in  bit_vector(3 downto 0);-- los digitos que salen del registro son de 4b
        e1  : in  bit_vector(3 downto 0);
        e2  : in  bit_vector(3 downto 0);
        e3  : in  bit_vector(3 downto 0);
        e4  : in  bit_vector(3 downto 0);
        e5  : in  bit_vector(3 downto 0);
        e6  : in  bit_vector(3 downto 0);
        e7  : in  bit_vector(3 downto 0);
        sel : in  bit_vector(2 downto 0); --tengo 6 opciones, para describir el numero 6 necesito 3 bits
        sal : out bit_vector(3 downto 0)
    );
end;

architecture mux8a1_4b_arq of mux8a1_4b is

    component mux2a1_4b is-- uso el mux2a1 ya usado pero con contenido de 4bits
        port (
            a   : in  bit_vector(3 downto 0);
            b   : in  bit_vector(3 downto 0);
            s   : in  bit;
            sal : out bit_vector(3 downto 0)
        );
    end component;-- IMPORTANTE si s=1 pasa A si s=0 pasa B

-- cada m es la salida de un mux, y los numeros son las entradas que relaciona	

    signal m01 : bit_vector(3 downto 0);-- salida del mux con entrada e0 y e1
    signal m23 : bit_vector(3 downto 0);-- salida del mux con entrada e2 y e3
    signal m45 : bit_vector(3 downto 0);
    signal m67 : bit_vector(3 downto 0);-- salida del mux con entrada e6 y e7

    signal m03 : bit_vector(3 downto 0);-- salida del mux que tiene como entras m01 y m23, x eso se llama m03
    signal m47 : bit_vector(3 downto 0);

begin
-- la selectora tiene 3 bits s2s1s0, s0 es el q selecciona agrupando de a 2 entre las e0-e7

    MUX_01 : mux2a1_4b
        port map (
            a   => e1,
            b   => e0,
            s   => sel(0),
            sal => m01
        );

    MUX_23 : mux2a1_4b
        port map (
            a   => e3,
            b   => e2,
            s   => sel(0),
            sal => m23
        );

    MUX_45 : mux2a1_4b
        port map (
            a   => e5,
            b   => e4,
            s   => sel(0),
            sal => m45
        );

    MUX_67 : mux2a1_4b
        port map (
            a   => e7,
            b   => e6,
            s   => sel(0),
            sal => m67
        );

    -- ahora empiezan los mux que seleccionan entre las salidas de los mux anteriores, por lo que pasamos a s1

    MUX_03 : mux2a1_4b
        port map (
            a   => m23,
            b   => m01,
            s   => sel(1),
            sal => m03
        );

    MUX_47 : mux2a1_4b
        port map (
            a   => m67,
            b   => m45,
            s   => sel(1),
            sal => m47
        );

    -- y s3 selecciona entre las salidas de los mux anteiores

    MUX_FINAL : mux2a1_4b
        port map (
            a   => m47,
            b   => m03,
            s   => sel(2),
            sal => sal
        );

end;