library ieee;
use ieee.std_logic_1164.all;

entity contador is
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


architecture arquitetura of contador is

-- Faltam alguns sinais:

begin


else generate			 

-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => Endereco_ROM, Dado => Instrucao);

processador : entity work.CPU generic map
			 
RAM : entity work.memoriaRAM
		generic map (dataWidth => 8, addrWidth => 8)
		port map (addr => Instrucao(7 downto 0), 
		we => habEscritaMEM, 
		re => habLeituraMEM, 
		habilita => Instrucao(8),
		clk => clk,
		dado_in => REG1_ULA_A,
		dado_out => saida_dados_RAM);
		
Buffer3State :  entity work.buffer_3_state_8portas
        port map(entrada => sinalLocal, habilita =>  sinalLocal, saida => sinalLocal);
		  
REG : entity work.registradorGenerico   generic map (larguraDados => VALOR_LOCAL)
          port map (DIN => sinalLocal, DOUT => sinalLocal, ENABLE => sinalLocal, CLK => sinalLocal, RST => sinalLocal);	

dec3x8 :  entity work.decoder3x8
        port map( entrada => sinalLocal,
                 saida => sinalLocal);
					  
display :  entity work.conversorHex7Seg
        port map(dadoHex => sinalLocal,
                 apaga =>  sinalLocal,
                 negativo => sinalLocal,
                 overFlow =>  sinalLocal,
                 saida7seg => sinalLocal);
					  
end architecture;