entity medicion_voltaje is
    port (
        clk_i      : in  bit;
        rst_i      : in  bit;
        q_adc_i    : in  bit;

        dig_ent_o  : out bit_vector(3 downto 0);
        dig_dec1_o : out bit_vector(3 downto 0);
        dig_dec2_o : out bit_vector(3 downto 0)
    );
end;

architecture medicion_voltaje_arq of medicion_voltaje is

    component cont_ventana is
        port (
            clk_i     : in  bit;
            rst_i     : in  bit;
            ena_i     : in  bit;
            ena_reg_o : out bit;
            rst_bcd_o : out bit;
            q_o       : out bit_vector(15 downto 0)-- no los uso en este caso
        );
    end component;

    component bcd_5 is
        port (
            en    : in  bit;
            q_adc : in  bit;
            rst   : in  bit;
            clk   : in  bit;
            q2    : out bit_vector(3 downto 0);
            q3    : out bit_vector(3 downto 0);
            q4    : out bit_vector(3 downto 0)
        );
    end component;

    component reg_medicion is
        port (
            clk_i      : in  bit;
            rst_i      : in  bit;
            ena_reg_i  : in  bit;

            bcd4_i     : in  bit_vector(3 downto 0);
            bcd3_i     : in  bit_vector(3 downto 0);
            bcd2_i     : in  bit_vector(3 downto 0);

            dig_ent_o  : out bit_vector(3 downto 0);
            dig_dec1_o : out bit_vector(3 downto 0);
            dig_dec2_o : out bit_vector(3 downto 0)
        );
    end component;

    signal ena_reg_s       : bit;
    signal rst_bcd_s       : bit;
    signal en_bcd_s        : bit;
    signal rst_bcd_total_s : bit;

    signal bcd2_s          : bit_vector(3 downto 0);
    signal bcd3_s          : bit_vector(3 downto 0);
    signal bcd4_s          : bit_vector(3 downto 0);

    signal q_ventana_s     : bit_vector(15 downto 0);-- no lo uso

begin

    -- Contador de ventana:
    -- en 33000 activa ena_reg_s
    -- en 33001 activa rst_bcd_s
    CONTADOR_VENTANA : cont_ventana
        port map (
            clk_i     => clk_i,
            rst_i     => rst_i,
            ena_i     => '1',-- la ventana de medicion esta activa siempre
            ena_reg_o => ena_reg_s,
            rst_bcd_o => rst_bcd_s,
            q_o       => q_ventana_s-- no uso
        );

    -- El BCD no debe contar si esta hbaikitado el reg o si estoy reseteando
    en_bcd_s <= not ena_reg_s and not rst_bcd_s;

    -- Reset total del BCD: reset general (de afuera) o reset al final de la ventana.
    rst_bcd_total_s <= rst_i or rst_bcd_s;

    -- Contadores BCD de 5 dígitos. Solo salen q2, q3 y q4, q son los mas sig.
    CONTADOR_BCD : bcd_5
        port map (
            en    => en_bcd_s,
            q_adc => q_adc_i,
            rst   => rst_bcd_total_s,
            clk   => clk_i,
            q2    => bcd2_s,
            q3    => bcd3_s,
            q4    => bcd4_s
        );

    -- Registros de medición. q4 = entero, q3 = primer decimal, q2 = segundo decimal
    REGISTROS_MEDICION : reg_medicion
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            ena_reg_i  => ena_reg_s,

            bcd4_i     => bcd4_s,
            bcd3_i     => bcd3_s,
            bcd2_i     => bcd2_s,

            dig_ent_o  => dig_ent_o,
            dig_dec1_o => dig_dec1_o,
            dig_dec2_o => dig_dec2_o
        );

end;