entity cont_ventana is
    port (
        clk_i     : in  bit;
        rst_i     : in  bit;
        ena_i     : in  bit;
        ena_reg_o : out bit;
        rst_bcd_o : out bit;
        q_o       : out bit_vector(15 downto 0)
    );
end;

architecture cont_ventana_arq of cont_ventana is

    component contNb is
        generic (
            N : positive := 4 -- si nadie aclara cuanto vale, vale 4
        );
        port (
            clk  : in  bit;
            srst : in  bit;
            ena  : in  bit;
            q    : out bit_vector(N-1 downto 0);
            co   : out bit
        );
    end component;

    signal q_aux       : bit_vector(15 downto 0);
	signal co_aux      : bit;
    signal max_33000   : bit;
    signal max_33001   : bit;
    signal rst_cont    : bit;

begin

    -- Reset del contador de ventana, se resetea por reset general o cuando llegó a 33001.
    rst_cont <= rst_i or max_33001;

    CONTADOR_16BITS : contNb
        generic map (
            N => 16-- aclaro cuanto vale 
        )
        port map (
            clk  => clk_i,
            srst => rst_cont,
            ena  => ena_i,
            q    => q_aux,
            co   => co_aux -- como el contador generico tenia esta salida y aca no la usamos le pongo co_aux pero no lo conecto a nada. No sirve xq no voy a contar jasta 65535 q es lo max
        );

    -- 33000 en decimal = 1000 0000 1110 1000 binario
    -- q(15 downto 0) = 1000000011101000

    max_33000 <= q_aux(15) and
                 not q_aux(14) and
                 not q_aux(13) and
                 not q_aux(12) and
                 not q_aux(11) and
                 not q_aux(10) and
                 not q_aux(9)  and
                 not q_aux(8)  and
                 q_aux(7)     and
                 q_aux(6)     and
                 q_aux(5)     and
                 not q_aux(4) and
                 q_aux(3)     and
                 not q_aux(2) and
                 not q_aux(1) and
                 not q_aux(0);

	
				 
				 

    -- 33001 decimal = 1000 0000 1110 1001 binario
    -- q(15 downto 0) = 1000000011101001

    max_33001 <= q_aux(15) and
                 not q_aux(14) and
                 not q_aux(13) and
                 not q_aux(12) and
                 not q_aux(11) and
                 not q_aux(10) and
                 not q_aux(9)  and
                 not q_aux(8)  and
                 q_aux(7)     and
                 q_aux(6)     and
                 q_aux(5)     and
                 not q_aux(4) and
                 q_aux(3)     and
                 not q_aux(2) and
                 not q_aux(1) and
                 q_aux(0);


    -- En 33000 se habilitan los registros. En 33001 se resetean los BCD.
    ena_reg_o <= max_33000;
    rst_bcd_o <= max_33001;

    -- Salida para simulación. no la necesitamos conectar a nada pero para ir chequeando
    q_o <= q_aux;

end;