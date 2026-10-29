
entity ff_adc is
    port (
        clk_i           : in  bit;
        rst_i           : in  bit;
        data_volt_in_i  : in  bit;
        q_adc_o         : out bit;
        data_volt_out_o : out bit
    );
end;

architecture ff_adc_arq of ff_adc is

    component ffd_en is
        port (
            d    : in  bit;
            clk  : in  bit;
            srst : in  bit;
            ena  : in  bit;
            q    : out bit
        );
    end component;

    signal q_aux : bit;

begin

    FFD_ADC : ffd_en
        port map (
            d    => data_volt_in_i,
            clk  => clk_i,
            srst => rst_i,
            ena  => '1',
            q    => q_aux
        );

    q_adc_o         <= q_aux;
    data_volt_out_o <= not q_aux;

end;

