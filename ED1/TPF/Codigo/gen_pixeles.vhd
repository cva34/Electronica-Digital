entity gen_pixeles is
    port (
		clk_i      : in  bit;--lo agregue x cambio de placa
		
        video_on_i : in  bit;
        pixel_x_i  : in  bit_vector(9 downto 0);-- los q salen de vga
        pixel_y_i  : in  bit_vector(9 downto 0);

        dig_ent_i  : in  bit_vector(3 downto 0);-- los que salen del bloque de medicion, de los registros
        dig_dec1_i : in  bit_vector(3 downto 0);
        dig_dec2_i : in  bit_vector(3 downto 0);

        red_o      : out bit;
        grn_o      : out bit;
        blu_o      : out bit
    );
end;

architecture gen_pixeles_arq of gen_pixeles is

    component mux_char_address is
        port (
            dig_ent_i      : in  bit_vector(3 downto 0);
            dig_dec1_i     : in  bit_vector(3 downto 0);
            dig_dec2_i     : in  bit_vector(3 downto 0);
            sel_i          : in  bit_vector(2 downto 0);
            char_address_o : out bit_vector(3 downto 0)
        );
    end component;

    component ROM is
        port (
			clk          : in  bit;--agregado x cambio de placa
            char_address : in  bit_vector(3 downto 0);
            font_col     : in  bit_vector(2 downto 0);
            font_row     : in  bit_vector(2 downto 0);
            data_out     : out bit
        );
    end component;

    signal x_text_on_s    : bit; -- detecta si pixel_x está entre 256 y 319
    signal y_text_on_s    : bit; -- detecta si pixel_y está entre 232 y 239
    signal text_on_s      : bit; -- habilita el rectángulo donde se dibuja el texto

    signal sel_s          : bit_vector(2 downto 0); -- va al mux, selecciona el carácter 
    signal font_col_s     : bit_vector(2 downto 0); -- va a la ROM, columna interna 
    signal font_row_s     : bit_vector(2 downto 0); -- va a la ROM, fila interna 

    signal char_address_s : bit_vector(3 downto 0); -- salida del mux, entra a la ROM
    signal rom_out_s      : bit; -- salida de la ROM, indica si ese pixel del carácter está prendido
    signal pixel_on_s     : bit; -- pixel final, va a RGB
	
	
	--Bandas de escritura para eje y
	signal banda_1_s : bit;---_vector(6 downto 0); EN PRINCICPIO SON BITS UNICAMENTE, YA QUE EL ERESULTADO DE UNA OPERACION LOGICA ES UN UNICO BIT
	signal banda_2_s : bit;--_vector ( 6 downto 0);
	signal banda_3_s : bit;--_vector (6 downto 0);

begin

    ------------------
	--DEF. BANDAS
		-- 128(00 1000 0000) a 135(00 1000 0111)
		--256() a 263()  
		-- 384() a 391() 

		-- Cambio bandas  para escalar
-- Canal 1: y = 0 a 127
	banda_1_s <= not pixel_y_i(9) and
             not pixel_y_i(8) and
             not pixel_y_i(7);

-- Canal 2: y = 128 a 255
	banda_2_s <= not pixel_y_i(9) and
             not pixel_y_i(8) and
                 pixel_y_i(7);

-- Canal 3: y = 256 a 383
	banda_3_s <= not pixel_y_i(9) and
                 pixel_y_i(8) and
             not pixel_y_i(7);
	
	
	
    -- Elijo que la zona del texto sea el medio de la pantalla : x = 256 a 319 | y = 3 rangos de Bandas


    -- x = todo
    x_text_on_s <= '1'; -- porque uso los 640 

    -- y = a 3 rangos de Bandas
    y_text_on_s <= banda_1_s or banda_2_s or banda_3_s;

    text_on_s <= x_text_on_s and y_text_on_s;

    -------------
    -- coordenadas internas del carácter y selector de carácter
   
    font_col_s <= pixel_x_i(6 downto 4); -- Cambiamos a 6 downto 4  en ambos font

    font_row_s <= pixel_y_i(6 downto 4);

    sel_s <= pixel_x_i(9 downto 7);-- cambiamos sel_s de 9 down to 7

    -------------
    -- mux: selecciona qué carácter mandar a la ROM
 
    MUX_CHAR_INST : mux_char_address
        port map (
            dig_ent_i      => dig_ent_i,
            dig_dec1_i     => dig_dec1_i,
            dig_dec2_i     => dig_dec2_i,
            sel_i          => sel_s,
            char_address_o => char_address_s
        );

    ---------------
    -- ROM: dice si el pixel interno del carácter está prendido

    ROM_INST : ROM
        port map (
			clk          => clk_i,--cambio de placa
            char_address => char_address_s,
            font_col     => font_col_s,
            font_row     => font_row_s,
            data_out     => rom_out_s
        );

    ---------------
    -- Salida RGB
    pixel_on_s <= video_on_i and text_on_s and rom_out_s;

    red_o <= pixel_on_s;
    grn_o <= video_on_i and not pixel_on_s;
    blu_o <= pixel_on_s;

end;