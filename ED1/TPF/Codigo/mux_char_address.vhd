entity mux_char_address is
    port (
        dig_ent_i      : in  bit_vector(3 downto 0);-- los digitos que llegan del registro
        dig_dec1_i     : in  bit_vector(3 downto 0);
        dig_dec2_i     : in  bit_vector(3 downto 0);
        sel_i          : in  bit_vector(2 downto 0);-- selectora
        char_address_o : out bit_vector(3 downto 0)-- lo q entra a la ROM
    );
end;

architecture mux_char_address_arq of mux_char_address is

    component mux8a1_4b is
        port (
            e0  : in  bit_vector(3 downto 0);
            e1  : in  bit_vector(3 downto 0);
            e2  : in  bit_vector(3 downto 0);
            e3  : in  bit_vector(3 downto 0);
            e4  : in  bit_vector(3 downto 0);
            e5  : in  bit_vector(3 downto 0);
            e6  : in  bit_vector(3 downto 0);
            e7  : in  bit_vector(3 downto 0);
            sel : in  bit_vector(2 downto 0);
            sal : out bit_vector(3 downto 0)
        );
    end component; -- IMPORTANTE , si sel es 000 elige e0, 001 elige e1, etc (se ve dentro de mux8a1_4b)

begin

    MUX_CHAR : mux8a1_4b
        port map (
            e0  => dig_ent_i,       -- dígito entero
            e1  => "1011",          -- punto '.', dado por el codigo de rom
            e2  => dig_dec1_i,      -- primer decimal
            e3  => dig_dec2_i,      -- segundo decimal
            e4  => "1010",          -- V, dado por el codigo de rom 
            e5  => "1100",          -- espacio, dado por el codigo de rom
            e6  => "1100",          -- espacio, dado por el codigo de rom
            e7  => "1100",          -- espacio, dado por el codigo de rom
            sel => sel_i,
            sal => char_address_o
        );

end;