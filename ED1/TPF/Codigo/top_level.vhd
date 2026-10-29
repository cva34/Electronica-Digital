entity top_level is
    port (
        clk_i           : in  bit;
        rst_i           : in  bit;

	-- agrego los 3 pines fisicos de entrada
        data_volt_in_0_i  : in  bit; 
		data_volt_in_1_i  : in bit;
		data_volt_in_2_i  : in bit;
		
		-- agrego los 3 pines fisicos de salida
		data_volt_out_0_o  : out bit;
		data_volt_out_1_o  : out bit;
        data_volt_out_2_o  : out bit;

        hs_o            : out bit;
        vs_o            : out bit;
        red_o           : out bit;
        grn_o           : out bit;
        blu_o           : out bit
    );
end;

architecture top_level_arq of top_level is

    component ff_adc is
        port (
            clk_i           : in  bit;
            rst_i           : in  bit;
            data_volt_in_i  : in  bit;
            q_adc_o         : out bit;
            data_volt_out_o : out bit
        );
    end component;

    component bloque_procesamiento is
        port (
            clk_i   : in  bit;
            rst_i   : in  bit;
            q_adc_i_0 : in  bit;
			q_adc_i_1 : in  bit;
			q_adc_i_2 : in  bit;

            hs_o    : out bit;
            vs_o    : out bit;
            red_o   : out bit;
            grn_o   : out bit;
            blu_o   : out bit
        );
    end component;
	
	component ffd_en is 
		port (
			d    : in  bit;
			clk  : in  bit;
			srst : in  bit;
			ena  : in  bit;
			q    : out bit
		);
		end component;

    --signal clk_25_s : bit; -- clock de 25 MHz, sale de clock_final y entra al ADC y procesamiento
   -- signal q_adc_s  : bit; -- salida del FF del ADC: entra al bloque de procesamiento
	
	--clk 
	signal clk25MHz, clk25MHz_n	: bit;
	
	--problema rst 
	signal rst_inv: bit;
	
	-- nuevas signal para conectar cada ADC
	signal q_adc_0_s  : bit;
	signal q_adc_1_s  : bit;
	signal q_adc_2_s  : bit;
	

begin

rst_inv <= not rst_i;


   -- Generador del reloj lento
    ffd_i: ffd_en
        port map(
            clk => clk_i,     -- reloj del sistema (50 MHz)
            srst => '0',
            ena  => '1',
            d   => clk25MHz_n,
            q   => clk25MHz   -- reloj generado (25 MHz)
        );

    clk25MHz_n <= not clk25MHz;

    ADC_INST_0 : ff_adc
        port map (
            clk_i           => clk25MHz,
            rst_i           => rst_inv,
            data_volt_in_i  => data_volt_in_0_i,
            q_adc_o			=> q_adc_0_s,
            data_volt_out_o => data_volt_out_0_o
        );
		
	ADC_INST_1 : ff_adc
        port map (
            clk_i           => clk25MHz,
            rst_i           => rst_inv,
            data_volt_in_i  => data_volt_in_1_i,
            q_adc_o			=> q_adc_1_s,
            data_volt_out_o => data_volt_out_1_o
        );
		
	ADC_INST_2 : ff_adc
        port map (
            clk_i           => clk25MHz,
            rst_i           => rst_inv,
            data_volt_in_i  => data_volt_in_2_i,
            q_adc_o			=> q_adc_2_s,
            data_volt_out_o => data_volt_out_2_o
        );
		
		

    PROCESAMIENTO_INST : bloque_procesamiento
        port map (
            clk_i   => clk25MHz,
            rst_i   => rst_inv,
			
            q_adc_i_0 => q_adc_0_s,
			q_adc_i_1 => q_adc_1_s,
			q_adc_i_2 => q_adc_2_s,
			
            hs_o    => hs_o,
            vs_o    => vs_o,
			
            red_o   => red_o,
            grn_o   => grn_o,
            blu_o   => blu_o
        );


end;