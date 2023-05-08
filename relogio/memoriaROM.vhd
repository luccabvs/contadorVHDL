library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
		  
		  
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";

		  
		  
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:
tmp(0) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(1) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	#Limpa leitura KEY1
tmp(2) := x"5" & "00" & '1' & x"FC";	-- STA @508                        	#Limpa leitura KEY0
tmp(3) := x"5" & "00" & '1' & x"FD";	-- STA @509                        	#Limpa leitura Reset 
tmp(4) := x"4" & "00" & '0' & x"00";	-- LDI R0, $0                      	#Carrega 0 no acumulador
tmp(5) := x"5" & "00" & '0' & x"00";	-- STA R0, @0   
tmp(6) := x"4" & "00" & '0' & x"01";	-- LDI R0, $1                      	#Carrega 1 no acumulador
tmp(7) := x"5" & "00" & '0' & x"01";	-- STA R0, @1                     	#Salva 1 no endereço 63 da RAM
tmp(8) := x"4" & "00" & '0' & x"02";	-- LDI R0, $2                     	#Salva 1 no endereço 63 da RAM
tmp(9) := x"5" & "00" & '0' & x"02";	-- STA R0, @2                     	#Salva 1 no endereço 63 da RAM
tmp(10) := x"4" & "00" & '0' & x"03";	-- LDI R0, $3                     	#Salva 1 no endereço 63 da RAM
tmp(11) := x"5" & "00" & '0' & x"03";	-- STA R0, @3                     	#Salva 1 no endereço 63 da RAM
tmp(12) := x"4" & "00" & '0' & x"04";	-- LDI R0, $4                     	#Salva 1 no endereço 63 da RAM
tmp(13) := x"5" & "00" & '0' & x"04";	-- STA R0, @4
tmp(14) := x"4" & "00" & '0' & x"05";	-- LDI R0, $5                     	#Salva 1 no endereço 63 da RAM
tmp(15) := x"5" & "00" & '0' & x"05";	-- STA R0, @5
tmp(16) := x"4" & "00" & '0' & x"06";	-- LDI R0, $6                     	#Salva 1 no endereço 63 da RAM
tmp(17) := x"5" & "00" & '0' & x"06";	-- STA R0, @6
tmp(18) := x"4" & "00" & '0' & x"07";	-- LDI R0, $7                     	#Salva 1 no endereço 63 da RAM
tmp(19) := x"5" & "00" & '0' & x"07";	-- STA R0, @7
tmp(20) := x"4" & "00" & '0' & x"08";	-- LDI R0, $8                     	#Salva 1 no endereço 63 da RAM
tmp(21) := x"5" & "00" & '0' & x"08";	-- STA R0, @8
tmp(22) := x"4" & "00" & '0' & x"09";	-- LDI R0, $9                     	#Salva 1 no endereço 63 da RAM
tmp(23) := x"5" & "00" & '0' & x"09";	-- STA R0, @9
tmp(24) := x"4" & "00" & '0' & x"0A";	-- LDI R0, $10                     	#Salva 1 no endereço 63 da RAM
tmp(25) := x"5" & "00" & '0' & x"0A";	-- STA R0, @10
tmp(26) := x"4" & "00" & '0' & x"0B";	-- LDI R0, $11                     	#Salva 1 no endereço 63 da RAM
tmp(27) := x"5" & "00" & '0' & x"0B";	-- STA R0, @11
tmp(28) := x"4" & "00" & '0' & x"0C";	-- LDI R0, $12                     	#Salva 1 no endereço 63 da RAM
tmp(29) := x"5" & "00" & '0' & x"0C";	-- STA R0, @12
tmp(30) := x"4" & "00" & '0' & x"0D";	-- LDI R0, $13                     	#Salva 1 no endereço 63 da RAM
tmp(31) := x"5" & "00" & '0' & x"0D";	-- STA R0, @13
tmp(32) := x"4" & "00" & '0' & x"0E";	-- LDI R0, $14                     	#Salva 1 no endereço 63 da RAM
tmp(33) := x"5" & "00" & '0' & x"0E";	-- STA R0, @14
tmp(34) := x"4" & "00" & '0' & x"0F";	-- LDI R0, $15                     	#Salva 1 no endereço 63 da RAM
tmp(35) := x"5" & "00" & '0' & x"0F";	-- STA R0, @15
tmp(36) := x"1" & "00" & '0' & x"00";	-- LDA R0, @0                      	#Carrega o valor do endereço 0 da RAM no acumulador
tmp(37) := x"5" & "00" & '1' & x"02";	-- STA R0, @258                    	#Apaga o LED 9
tmp(38) := x"5" & "00" & '1' & x"01";	-- STA R0, @257                    	#Apaga o LED 8
tmp(39) := x"5" & "00" & '1' & x"00";	-- STA R0, @256                    	#Apaga o LED 7 a 0 
tmp(40) := x"5" & "00" & '1' & x"20";	-- STA R0, @288                    	#Zera o HEX 0
tmp(41) := x"5" & "00" & '1' & x"21";	-- STA R0, @289                    	#Zera o HEX 1
tmp(42) := x"5" & "00" & '1' & x"22";	-- STA R0, @290                    	#Zera o HEX 2
tmp(43) := x"5" & "00" & '1' & x"23";	-- STA R0, @291                    	#Zera o HEX 3
tmp(44) := x"5" & "00" & '1' & x"24";	-- STA R0, @292                    	#Zera o HEX 4
tmp(45) := x"5" & "00" & '1' & x"25";	-- STA R0, @293                    	#Zera o HEX 5
tmp(46) := x"5" & "00" & '0' & x"10";	-- STA R0, @16                     	#Zera o endereço 0 da RAM (Limite das unidades)
tmp(47) := x"5" & "00" & '0' & x"11";	-- STA R0, @17                     	#Zera o endereço 1 da RAM (Limite das dezenas)
tmp(48) := x"5" & "00" & '0' & x"12";	-- STA R0, @18                     	#Zera o endereço 2 da RAM (Limite das centenas) 
tmp(49) := x"5" & "00" & '0' & x"13";	-- STA R0, @19                     	#Zera o endereço 3 da RAM (Limite dos milhares) 
tmp(50) := x"5" & "00" & '0' & x"14";	-- STA R0, @20                     	#Zera o endereço 4 da RAM (Limite das dezenas de milhares)
tmp(51) := x"5" & "00" & '0' & x"15";	-- STA R0, @21                     	#Zera o endereço 5 da RAM (Limite das centenas de milhares) 
tmp(52) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(53) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353
tmp(54) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0
tmp(55) := x"7" & "00" & '0' & x"39";	-- JEQ @57
tmp(56) := x"9" & "00" & '0' & x"BA";	-- JSR @186
tmp(57) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(58) := x"1" & "00" & '1' & x"7F";	-- LDA @383                   	#Carrega o valor do CLOCK no acumulador
tmp(59) := x"8" & "00" & '0' & x"00";	-- CEQ @0                     	#Compara o valor do CLOCK com 63 (0)
tmp(60) := x"7" & "00" & '0' & x"4A";	-- JEQ @74           	#Se o valor da
tmp(61) := x"9" & "00" & '0' & x"4F";	-- JSR @79           	#Se o valor do KEY0 for 1, vai para o label Incremento (Incrementar)
tmp(62) := x"1" & "00" & '0' & x"10";	-- LDA @16                     	#Carrega o valor do endereço 10 da RAM no acumulador (valor atual das unidades)
tmp(63) := x"5" & "00" & '1' & x"20";	-- STA @288                    	#Salva o valor do acumulador no HEX 0
tmp(64) := x"1" & "00" & '0' & x"11";	-- LDA @17                     	#Carrega o valor do endereço 11 da RAM no acumulador (valor atual das dezenas)
tmp(65) := x"5" & "00" & '1' & x"21";	-- STA @289                    	#Salva o valor do acumulador no HEX 1
tmp(66) := x"1" & "00" & '0' & x"12";	-- LDA @18                     	#Carrega o valor do endereço 12 da RAM no acumulador (valor atual das centenas)
tmp(67) := x"5" & "00" & '1' & x"22";	-- STA @290                    	#Salva o valor do acumulador no HEX 2
tmp(68) := x"1" & "00" & '0' & x"13";	-- LDA @19                     	#Carrega o valor do endereço 13 da RAM no acumulador (valor atual dos milhares)
tmp(69) := x"5" & "00" & '1' & x"23";	-- STA @291                    	#Salva o valor do acumulador no HEX 3
tmp(70) := x"1" & "00" & '0' & x"14";	-- LDA @20                     	#Carrega o valor do endereço 14 da RAM no acumulador (valor atual das dezenas de milhares)
tmp(71) := x"5" & "00" & '1' & x"24";	-- STA @292                    	#Salva o valor do acumulador no HEX 4
tmp(72) := x"1" & "00" & '0' & x"15";	-- LDA @21                     	#Carrega o valor do endereço 15 da RAM no acumulador (valor atual das centenas de milhares)
tmp(73) := x"5" & "00" & '1' & x"25";	-- STA @293                    	#Salva o valor do acumulador no HEX 5
tmp(74) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(75) := x"1" & "00" & '1' & x"64";	-- LDA @356                    	#Carrega o valor do Reset no acumulador
tmp(76) := x"8" & "00" & '0' & x"01";	-- CEQ @1                     	#Compara o valor do Reset com 63 (1)
tmp(77) := x"7" & "00" & '0' & x"00";	-- JEQ @0           	#Se o valor do Reset for 1, vai para o label Reset (Reseta o programa)
tmp(78) := x"6" & "00" & '0' & x"34";	-- JMP @52           	#Se nenhum dos botoes forem clicados, vai para o label Start (Laco principal)
tmp(79) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(80) := x"5" & "00" & '1' & x"FC";	-- STA @508
tmp(81) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(82) := x"1" & "01" & '0' & x"10";	-- LDA R1, @16
tmp(83) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                	#Soma o valor do acumulador com 63 (1)
tmp(84) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10                 	#Compara o valor do acumulador com o endereco 20 da RAM (10)
tmp(85) := x"7" & "00" & '0' & x"5B";	-- JEQ @91           	#Se o valor do acumulador for 10, vai para o label IncDez (Incremento das dezenas)
tmp(86) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                 	#Se o valor do acumulador nao for 10, salva o valor do acumulador no endereço 10 da RAM (valor atual das unidades)
tmp(87) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(88) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(89) := x"7" & "00" & '0' & x"D8";	-- JEQ @216
tmp(90) := x"A" & "00" & '0' & x"00";	-- RET
tmp(91) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(92) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                 	#Carrega o valor 62 (0) no acumulador
tmp(93) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                 	#Zera o valor atual das unidades
tmp(94) := x"1" & "01" & '0' & x"11";	-- LDA R1, @17                 	#Carrega o valor do endereço 11 da RAM no acumulador (valor atual das dezenas)
tmp(95) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                    	#Soma o valor do acumulador com 63 (1)
tmp(96) := x"8" & "01" & '0' & x"06";	-- CEQ R1, @6                     	#Compara o valor do acumulador com o endereco 20 da RAM (10)
tmp(97) := x"7" & "00" & '0' & x"B2";	-- JEQ @178           	#Se o valor do acumulador for 10, vai para o label IncCen (Incremento das centenas)
tmp(98) := x"5" & "01" & '0' & x"11";	-- STA R1, @17                     	#Se o valor do acumulador nao for 10, salva o valor do acumulador no endereço 11 da RAM (valor atual das dezenas)
tmp(99) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(100) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(101) := x"7" & "00" & '0' & x"D8";	-- JEQ @216
tmp(102) := x"A" & "00" & '0' & x"00";	-- RET
tmp(103) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(104) := x"1" & "01" & '0' & x"12";	-- LDA R1, @18
tmp(105) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1
tmp(106) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10
tmp(107) := x"7" & "00" & '0' & x"71";	-- JEQ @113
tmp(108) := x"5" & "01" & '0' & x"12";	-- STA R1, @18
tmp(109) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(110) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(111) := x"7" & "00" & '0' & x"C9";	-- JEQ @201
tmp(112) := x"A" & "00" & '0' & x"00";	-- RET
tmp(113) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(114) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0
tmp(115) := x"5" & "01" & '0' & x"12";	-- STA R1, @18
tmp(116) := x"1" & "01" & '0' & x"13";	-- LDA R1, @19
tmp(117) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1
tmp(118) := x"8" & "01" & '0' & x"06";	-- CEQ R1, @6
tmp(119) := x"7" & "00" & '0' & x"AA";	-- JEQ @170
tmp(120) := x"5" & "01" & '0' & x"13";	-- STA R1, @19
tmp(121) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(122) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(123) := x"7" & "00" & '0' & x"C9";	-- JEQ @201
tmp(124) := x"A" & "00" & '0' & x"00";	-- RET
tmp(125) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(126) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21
tmp(127) := x"8" & "01" & '0' & x"02";	-- CEQ R1, @2
tmp(128) := x"7" & "00" & '0' & x"8A";	-- JEQ @138
tmp(129) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20
tmp(130) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1     
tmp(131) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10
tmp(132) := x"7" & "00" & '0' & x"94";	-- JEQ @148
tmp(133) := x"5" & "01" & '0' & x"14";	-- STA R1, @20
tmp(134) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(135) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(136) := x"7" & "00" & '0' & x"BA";	-- JEQ @186
tmp(137) := x"A" & "00" & '0' & x"00";	-- RET
tmp(138) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(139) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20
tmp(140) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1
tmp(141) := x"8" & "01" & '0' & x"04";	-- CEQ R1, @4
tmp(142) := x"7" & "00" & '0' & x"9E";	-- JEQ @158
tmp(143) := x"5" & "01" & '0' & x"14";	-- STA R1, @20
tmp(144) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(145) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(146) := x"7" & "00" & '0' & x"BA";	-- JEQ @186
tmp(147) := x"A" & "00" & '0' & x"00";	-- RET
tmp(148) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(149) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0
tmp(150) := x"5" & "01" & '0' & x"14";	-- STA R1, @20
tmp(151) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21
tmp(152) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1
tmp(153) := x"5" & "01" & '0' & x"15";	-- STA R1, @21
tmp(154) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(155) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(156) := x"7" & "00" & '0' & x"BA";	-- JEQ @186
tmp(157) := x"A" & "00" & '0' & x"00";	-- RET
tmp(158) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(159) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0
tmp(160) := x"5" & "01" & '0' & x"15";	-- STA R1, @21
tmp(161) := x"5" & "01" & '0' & x"14";	-- STA R1, @20
tmp(162) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(163) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(164) := x"7" & "00" & '0' & x"BA";	-- JEQ @186
tmp(165) := x"5" & "01" & '0' & x"13";	-- STA R1, @19
tmp(166) := x"5" & "01" & '0' & x"12";	-- STA R1, @18
tmp(167) := x"5" & "01" & '0' & x"11";	-- STA R1, @17
tmp(168) := x"5" & "01" & '0' & x"10";	-- STA R1, @16
tmp(169) := x"A" & "00" & '0' & x"00";	-- RET
tmp(170) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(171) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0
tmp(172) := x"5" & "01" & '0' & x"13";	-- STA R1, @19
tmp(173) := x"5" & "01" & '0' & x"12";	-- STA R1, @18
tmp(174) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(175) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(176) := x"7" & "00" & '0' & x"C9";	-- JEQ @201
tmp(177) := x"6" & "00" & '0' & x"7D";	-- JMP @125
tmp(178) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(179) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0
tmp(180) := x"5" & "01" & '0' & x"11";	-- STA R1, @17
tmp(181) := x"5" & "01" & '0' & x"10";	-- STA R1, @16
tmp(182) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(183) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(184) := x"7" & "00" & '0' & x"D8";	-- JEQ @216
tmp(185) := x"6" & "00" & '0' & x"67";	-- JMP @103
tmp(186) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(187) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(188) := x"5" & "00" & '1' & x"FF";	-- STA @511
tmp(189) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20
tmp(190) := x"5" & "01" & '1' & x"24";	-- STA R1, @292
tmp(191) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21
tmp(192) := x"5" & "01" & '1' & x"25";	-- STA R1, @293
tmp(193) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(194) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(195) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(196) := x"7" & "00" & '0' & x"7D";	-- JEQ @125
tmp(197) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353
tmp(198) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0
tmp(199) := x"7" & "00" & '0' & x"C1";	-- JEQ @193
tmp(200) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(201) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(202) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(203) := x"5" & "00" & '1' & x"FF";	-- STA @511
tmp(204) := x"1" & "01" & '0' & x"12";	-- LDA R1, @18
tmp(205) := x"5" & "01" & '1' & x"22";	-- STA R1, @290
tmp(206) := x"1" & "01" & '0' & x"13";	-- LDA R1, @19
tmp(207) := x"5" & "01" & '1' & x"23";	-- STA R1, @291
tmp(208) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(209) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(210) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(211) := x"7" & "00" & '0' & x"67";	-- JEQ @103
tmp(212) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353
tmp(213) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0
tmp(214) := x"7" & "00" & '0' & x"D0";	-- JEQ @208
tmp(215) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(216) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(217) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(218) := x"5" & "00" & '1' & x"FF";	-- STA @511
tmp(219) := x"1" & "01" & '0' & x"10";	-- LDA R1, @16
tmp(220) := x"5" & "01" & '1' & x"20";	-- STA R1, @288
tmp(221) := x"1" & "01" & '0' & x"11";	-- LDA R1, @17
tmp(222) := x"5" & "01" & '1' & x"21";	-- STA R1, @289
tmp(223) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(224) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352
tmp(225) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1
tmp(226) := x"7" & "00" & '0' & x"51";	-- JEQ @81
tmp(227) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353
tmp(228) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0
tmp(229) := x"7" & "00" & '0' & x"DF";	-- JEQ @223
tmp(230) := x"5" & "00" & '1' & x"FE";	-- STA @510
tmp(231) := x"A" & "00" & '0' & x"00";	-- RET













        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;