library ieee;
use ieee.std_logic_1164.all;

entity contador is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
        simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
	 SW: in std_logic_vector(9 downto 0);
    LEDR  : out std_logic_vector(9 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of contador is

	signal Entrada_ROM : std_logic_vector(8 downto 0);
	signal Saida_ROM : std_logic_vector(12 downto 0);
	signal CLK : std_logic;
	signal Dado_Lido : std_logic_vector(7 downto 0);
	signal habEscritaMEM : std_logic;
	signal habLeituraMEM : std_logic;
	signal Data_Address : std_logic_vector(8 downto 0);
	signal Dado_Escrito : std_logic_vector(7 downto 0);
	signal saidaREG8 : std_logic_vector(7 downto 0);
	signal saidaREG4_0: std_logic_vector(3 downto 0);
	signal saidaREG4_1: std_logic_vector(3 downto 0);
	signal saidaREG4_2: std_logic_vector(3 downto 0);
	signal saidaREG4_3: std_logic_vector(3 downto 0);
	signal saidaREG4_4: std_logic_vector(3 downto 0);
	signal saidaREG4_5: std_logic_vector(3 downto 0);
	signal habReg8 : std_logic;
	signal habReg4_0: std_logic;
	signal habReg4_1: std_logic;
	signal habReg4_2: std_logic;
	signal habReg4_3: std_logic;
	signal habReg4_4: std_logic;
	signal habReg4_5: std_logic;
	signal Saida_FF1 : std_logic;
	signal habFF1 : std_logic;
	signal Saida_FF2 : std_logic;
	signal habFF2 : std_logic;
	signal Saida_Decoder1 :  std_logic_vector(7 downto 0);
	signal Saida_Decoder2 :  std_logic_vector(7 downto 0);
	signal pcTeste: std_logic_vector(6 downto 0);
	signal display_0: std_logic_vector(6 downto 0);
	signal display_1: std_logic_vector(6 downto 0);
	signal display_2: std_logic_vector(6 downto 0);
	signal display_3: std_logic_vector(6 downto 0);
	signal display_4: std_logic_vector(6 downto 0);
	signal display_5: std_logic_vector(6 downto 0);


begin
gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (CLK => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;			 


ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => Entrada_ROM, Dado => Saida_ROM);

processador : entity work.CPU port map (
					CLOCK => CLK,
					Data_IN => Dado_Lido,
					Instrucao_IN => Saida_ROM,
					wr => habEscritaMEM,
					rd => habLeituraMEM,
					ROM_Address => Entrada_ROM,
					Data_Address => Data_Address,
					Data_OUT => Dado_Escrito
					);
										
RAM : entity work.memoriaRAM
		generic map (dataWidth => 8, addrWidth => 6)
		port map (addr => Data_Address(5 downto 0), 
		we => habEscritaMEM, 
		re => habLeituraMEM, 
		habilita => Saida_Decoder1(0),
		CLK => CLK,
		dado_in => Dado_Lido,
		dado_out => Dado_Escrito
		);
		
--Buffer3State :  entity work.buffer_3_state_8portas
--        port map(entrada => sinalLocal, habilita =>  sinalLocal, saida => sinalLocal);
		  
REG8 : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (
			 DIN => Dado_Escrito, 
			 DOUT => saidaREG8, 
			 ENABLE => habReg8, 
			 CLK => CLK, 
			 RST => '0'
			 );	
			 
REG4_0 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0),
			 DOUT => saidaREG4_0, 
			 ENABLE => habReg4_0,
			 CLK => CLK, 
			 RST => '0');
	
REG4_1 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0),
			 DOUT => saidaREG4_1,
			 ENABLE => habReg4_1,
			 CLK => CLK,
			 RST => '0');

REG4_2 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0),
			 DOUT => saidaREG4_2,
			 ENABLE => habReg4_2,
			 CLK => CLK,
			 RST => '0');
			 
REG4_3 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0),
			 DOUT => saidaREG4_3,
			 ENABLE => habReg4_3,
			 CLK => CLK,
			 RST => '0');

REG4_4 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0),
			 DOUT => saidaREG4_4,
			 ENABLE => habReg4_4,
			 CLK => CLK,
			 RST => '0');
			 
REG4_5 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Dado_Escrito(3 downto 0), 
			 DOUT => saidaREG4_5, 
			 ENABLE => habReg4_5, 
			 CLK => CLK, 
			 RST => '0');
		
FF1: entity work.FlipFlop port map (
				DIN => Dado_Escrito(0),
				DOUT => Saida_FF1,
				ENABLE => habFF1,
				CLK => CLK,
				RST => '0');
				
FF2: entity work.FlipFlop port map (
				DIN => Dado_Escrito(0),
				DOUT => Saida_FF2,
				ENABLE => habFF2,
				CLK => CLK,
				RST => '0');


DEC1 :  entity work.decoder3x8
        port map( entrada => Data_Address(8 downto 6),
                 saida => Saida_Decoder1);
					  
DEC2 :  entity work.decoder3x8
        port map( entrada => Data_Address(2 downto 0),
                 saida => Saida_Decoder2);
					  
display0 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_0,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_0);
					  
display1 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_1,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_1);
				
display2 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_2,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_2);
				
display3 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_3,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_3);
				
display4 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_4,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_4);
				
display5 :  entity work.conversorHex7Seg
        port map(dadoHex => saidaREG4_5,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => display_5);



habReg8 <= saida_decoder1(4) and habEscritaMEM and saida_decoder2(0) and (not Data_Address(5));		
habFF1  <= saida_decoder1(4) and habEscritaMEM and saida_decoder2(2) and (not Data_Address(5));	 
habFF2  <= saida_decoder1(4) and habEscritaMEM and saida_decoder2(1) and (not Data_Address(5));			 

HEX0 <= display_0;
HEX1 <= display_1;
HEX2 <= display_2;
HEX3 <= display_3;
HEX4 <= display_4;
HEX5 <= display_5;

habReg4_0 <= saida_decoder2(0) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
habReg4_1 <= saida_decoder2(1) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
habReg4_2 <= saida_decoder2(2) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
habReg4_3 <= saida_decoder2(3) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
habReg4_4 <= saida_decoder2(4) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
habReg4_5 <= saida_decoder2(5) and Data_Address(5) and saida_decoder1(4) and habEscritaMEM;
			 
LEDR (9) <= saida_FF1;
LEDR (8) <= saida_FF2;
LEDR (7 downto 0) <= saidaREG8;			 
  
end architecture;