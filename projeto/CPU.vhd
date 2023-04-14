library ieee;
use ieee.std_logic_1164.all;

entity Aula5 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 13;
        larguraEnderecos : natural := 9;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
	 PC_OUT: out std_logic_vector(larguraEnderecos-1 downto 0);
    LEDR  : out std_logic_vector(9 downto 0);
	 EntradaB_ULA: out std_logic_vector(7 downto 0);
	 Palavra_Controle: out std_logic_vector(11 downto 0)
  );
end entity;


architecture arquitetura of Aula5 is

-- Faltam alguns sinais:
  signal MUX_B_ULA : std_logic_vector (7 downto 0);
  signal saida_dados_RAM : std_logic_vector (7 downto 0);
  signal REG1_ULA_A : std_logic_vector (7 downto 0);
  signal Saida_ULA : std_logic_vector (7 downto 0);
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal Endereco_ROM : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal Chave_Operacao_ULA : std_logic;
  signal CLK : std_logic;
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal Instrucao : std_logic_vector(12 downto 0);
  signal habEscritaMEM : std_logic;
  signal habLeituraMEM: std_logic;
  signal JMP: std_logic;
  signal JEQ: std_logic;
  signal JSR: std_logic;
  signal RET: std_logic;
  signal proxInstru: std_logic_vector(8 downto 0);
  signal ULA_flag: std_logic;
  signal flagZero: std_logic;
  signal habFlag: std_logic;
  signal sel_desvio: std_logic_vector(1 downto 0);
  signal linha_retorno: std_logic_vector(8 downto 0);
  signal habEscritaRetorno: std_logic;
  
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => 8)
        port map(entradaA_MUX => saida_dados_RAM,
                 entradaB_MUX =>  Instrucao(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => MUX_B_ULA);
					  
MUX_DESVIO :  entity work.muxGenericoNx1  generic map (larguraEntrada => 9, larguraSelecao => 2)
        port map( entradaA_MUX => proxPC,
						entradaB_MUX => Instrucao(8 downto 0),
						entradaC_MUX => linha_retorno,
						entradaD_MUX => "000000000",
                  seletor_MUX => sel_desvio,
                  saida_MUX => proxInstru);

-- O port map completo do Acumulador.
REGA : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK, RST => '0');

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => proxInstru, 
			 DOUT => Endereco_ROM, 
			 ENABLE => '1', 
			 CLK => CLK, 
			 RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Endereco_ROM, 
		  saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => 8)
          port map (entradaA => REG1_ULA_A,
			 entradaB => MUX_B_ULA, 
			 saida => Saida_ULA, 
			 saida_flipFlop => ULA_flag,
			 seletor => Operacao_ULA);

-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => Endereco_ROM, Dado => Instrucao);

DEC : entity work.decoderInstru
		port map (opcode => Instrucao(12 downto 9), saida => Sinais_Controle);
	
DESVIO : entity work.logicaDesvio
			port map (igual => flagZero, JMP => JMP, JEQ => JEQ, JSR => JSR, RET => RET, saida => sel_desvio);
	
REG_FLIPFLOP: entity work.flipFlop
				port map (DIN => ULA_flag, DOUT => flagZero, ENABLE => habFlag, CLK => CLK, RST => '0');					
				
END_RET : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => proxPC, DOUT => linha_retorno, ENABLE => habEscritaRetorno, CLK => CLK, RST => '0');
				
RAM : entity work.memoriaRAM
		generic map (dataWidth => 8, addrWidth => 8)
		port map (addr => Instrucao(7 downto 0), 
		we => habEscritaMEM, 
		re => habLeituraMEM, 
		habilita => Instrucao(8),
		clk => clk,
		dado_in => REG1_ULA_A,
		dado_out => saida_dados_RAM);

habEscritaRetorno <= Sinais_Controle(11);
JMP <= Sinais_Controle(10);
RET <= Sinais_Controle(9);
JSR <= Sinais_Controle(8);
JEQ <= Sinais_Controle(7);
selMUX <= Sinais_Controle(6);
Habilita_A <= Sinais_Controle(5);
Operacao_ULA <= Sinais_Controle(4 downto 3);
habFlag <= Sinais_Controle(2);
habLeituraMEM <= Sinais_Controle(1);
habEscritaMEM <= Sinais_Controle(0);


-- I/O
-- chavesY_MUX_A <= SW(3 downto 0);
-- chavesX_ULA_B <= SW(9 downto 6);

-- A ligacao dos LEDs:
-- LEDR (9) <= SelMUX;
-- LEDR (8) <= Habilita_A;
-- LEDR (7) <= Reset_A;
-- LEDR (6) <= Operacao_ULA;
-- LEDR (5) <= '0';    -- Apagado.
-- LEDR (4) <= '0';    -- Apagado.
-- LEDR (3 downto 0) <= REG1_ULA_A;

PC_OUT <= Endereco_ROM;
LEDR(7 downto 0) <= Saida_ULA;
LEDR(9 downto 8) <= Operacao_ULA;
EntradaB_ULA <= MUX_B_ULA;
Palavra_Controle <= Sinais_Controle;

end architecture;