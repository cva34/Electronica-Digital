entity reg_medicion is
    port (
        clk_i       : in  bit;
        rst_i       : in  bit;
        ena_reg_i   : in  bit;-- el q sale del contador de 16b

        bcd4_i      : in  bit_vector(3 downto 0);-- los mas significativos, los ultimos dos los descarto
        bcd3_i      : in  bit_vector(3 downto 0);
        bcd2_i      : in  bit_vector(3 downto 0);

        dig_ent_o   : out bit_vector(3 downto 0);-- un entero y dos decimales lo q muestra la VGA
        dig_dec1_o  : out bit_vector(3 downto 0);
        dig_dec2_o  : out bit_vector(3 downto 0)
    );
end;

architecture reg_medicion_arq of reg_medicion is

    component reg_Nbits is
        generic (
            N : natural := 4
        );
        port (
            q   : out bit_vector(N-1 downto 0);
            d   : in  bit_vector(N-1 downto 0);
            clk : in  bit;
            rst : in  bit;
            en  : in  bit
        );
    end component;

begin

    REG_ENTERO : reg_Nbits
        generic map (
            N => 4
        )
        port map (
            q   => dig_ent_o,
            d   => bcd4_i,
            clk => clk_i,
            rst => rst_i,
            en  => ena_reg_i
        );

    REG_DEC1 : reg_Nbits
        generic map (
            N => 4
        )
        port map (
            q   => dig_dec1_o,
            d   => bcd3_i,
            clk => clk_i,
            rst => rst_i,
            en  => ena_reg_i
        );

    REG_DEC2 : reg_Nbits
        generic map (
            N => 4
        )
        port map (
            q   => dig_dec2_o,
            d   => bcd2_i,
            clk => clk_i,
            rst => rst_i,
            en  => ena_reg_i
        );

end;