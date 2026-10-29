entity bloque_vga is
    port (
        clk_i      : in  bit;
        rst_i      : in  bit;

        dig_ent_i  : in  bit_vector(3 downto 0);
        dig_dec1_i : in  bit_vector(3 downto 0);
        dig_dec2_i : in  bit_vector(3 downto 0);

        hs_o       : out bit;
        vs_o       : out bit;
        red_o      : out bit;
        grn_o      : out bit;
        blu_o      : out bit;
		
		sel_mux_canales: out bit_vector (1 downto 0)
    );
end;

architecture bloque_vga_arq of bloque_vga is

    component gen_sinc is
        port (
            en       : in  bit;
            rst      : in  bit;
            clk      : in  bit;
            video_on : out bit;
            h_sync   : out bit;
            v_sync   : out bit;
            pixel_x  : out bit_vector(9 downto 0);
            pixel_y  : out bit_vector(9 downto 0);
			sel_canal_s: out bit_vector(1 downto 0)
        );
    end component;

    component gen_pixeles is
        port (
		    clk_i      : in  bit;
            video_on_i : in  bit;
            pixel_x_i  : in  bit_vector(9 downto 0);
            pixel_y_i  : in  bit_vector(9 downto 0);

            dig_ent_i  : in  bit_vector(3 downto 0);
            dig_dec1_i : in  bit_vector(3 downto 0);
            dig_dec2_i : in  bit_vector(3 downto 0);

            red_o      : out bit;
            grn_o      : out bit;
            blu_o      : out bit
        );
    end component;

    signal video_on_s : bit; -- conecta video_on de gen_sinc con gen_pixeles
    signal pixel_x_s  : bit_vector(9 downto 0); -- coordenada horizontal; sale de gen_sinc y entra a gen_pixeles
    signal pixel_y_s  : bit_vector(9 downto 0); -- coordenada vertical; sale de gen_sinc y entra a gen_pixeles
	
	signal sel_canal_s : bit_vector(1 downto 0); -- SEÑAL DE SELECOTRA MUX 3a1
	

begin

    GEN_SINC_INST : gen_sinc
        port map (
            en       => '1',
            rst      => rst_i,
            clk      => clk_i,
            video_on => video_on_s,
            h_sync   => hs_o,
            v_sync   => vs_o,
            pixel_x  => pixel_x_s,
            pixel_y  => pixel_y_s,
			sel_canal_s => sel_canal_s
        );

    GEN_PIXELES_INST : gen_pixeles
        port map (
		    clk_i      => clk_i,
            video_on_i => video_on_s,
            pixel_x_i  => pixel_x_s,
            pixel_y_i  => pixel_y_s,

            dig_ent_i  => dig_ent_i,
            dig_dec1_i => dig_dec1_i,
            dig_dec2_i => dig_dec2_i,

            red_o      => red_o,
            grn_o      => grn_o,
            blu_o      => blu_o
        );
		
		
		--asigno la señal de mux
		sel_mux_canales <= sel_canal_s;

end;