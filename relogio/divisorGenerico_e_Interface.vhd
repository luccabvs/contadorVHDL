LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
	
   port(clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
		SelMux : in std_logic; 
      leituraUmSegundo :   out std_logic_vector (7 downto 0)
		
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg: std_logic; 
  signal saidaclk_fast: std_logic; 
  signal tempo  : std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => 25000000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_reg1seg);
			  
			  
baseFast: entity work.divisorGenerico
           generic map (divisor => 25000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_fast);	
	
fastMUX :  entity work.muxFast  generic map (larguraDados => 1)
        port map( entradaA_MUX => saidaclk_reg1seg,
                 entradaB_MUX =>  saidaclk_fast,
                 seletor_MUX => SelMux,
                 saida_MUX => tempo);
				

registraUmSegundo: entity work.flipFlop
   port map (DIN => '1', 
				DOUT => sinalUmSegundo,
				ENABLE => '1', 
				CLK => tempo,
				RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= "0000000" & sinalUmSegundo when habilitaLeitura = '1' else "ZZZZZZZZ";

end architecture interface;