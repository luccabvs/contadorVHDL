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
tmp(0) := NOP & "00" & '0' & x"00";	-- !RESET
tmp(1) := LDI & "00" & '0' & x"00";	-- LDI R0, $0 	--CARREGA O R0 COM O VALOR 0
tmp(2) := STA & "00" & '0' & x"00";	-- STA R0, @0  	--LIMPA LUGAR DA MEMÓRIA 0
tmp(3) := STA & "00" & '0' & x"3A";	-- STA R0, @58  	--LIMPA UNIDADE SEGUNDOS
tmp(4) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(5) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(6) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(7) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(8) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(9) := STA & "00" & '1' & x"20";	-- STA R0, @288 	--LIMPA H0
tmp(10) := STA & "00" & '1' & x"21";	-- STA R0, @289 	--LIMPA H1
tmp(11) := STA & "00" & '1' & x"22";	-- STA R0, @290 	--LIMPA H2
tmp(12) := STA & "00" & '1' & x"23";	-- STA R0, @291 	--LIMPA H3
tmp(13) := STA & "00" & '1' & x"24";	-- STA R0, @292 	--LIMPA H4
tmp(14) := STA & "00" & '1' & x"25";	-- STA R0, @293 	--LIMPA H5
tmp(15) := STA & "00" & '1' & x"FF";	-- STA R0, @511 	--LIMPA K0
tmp(16) := STA & "00" & '1' & x"FE";	-- STA R0, @510 	--LIMPA K1
tmp(17) := STA & "00" & '1' & x"FC";	-- STA R0, @508 	--LIMPA TEMPO
tmp(18) := STA & "00" & '1' & x"FD";	-- STA R0, @509 	--LIMPA RESET
tmp(19) := LDI & "00" & '0' & x"01";	-- LDI R0, $1 	--CARREGA O R0 COM O VALOR 1
tmp(20) := STA & "00" & '0' & x"01";	-- STA R0, @1  	--ARMAZENA O VALOR 1 NA POSICAO 1
tmp(21) := LDI & "00" & '0' & x"02";	-- LDI R0, $2 	--CARREGA O R0 COM O VALOR 2
tmp(22) := STA & "00" & '0' & x"02";	-- STA R0, @2  	--ARMAZENA O VALOR 2 NA POSICAO 2
tmp(23) := LDI & "00" & '0' & x"03";	-- LDI R0, $3 	--CARREGA O R0 COM O VALOR 3
tmp(24) := STA & "00" & '0' & x"03";	-- STA R0, @3  	--ARMAZENA O VALOR 3 NA POSICAO 3
tmp(25) := LDI & "00" & '0' & x"04";	-- LDI R0, $4 	--CARREGA O R0 COM O VALOR 4
tmp(26) := STA & "00" & '0' & x"04";	-- STA R0, @4  	--ARMAZENA O VALOR 4 NA POSICAO 4
tmp(27) := LDI & "00" & '0' & x"06";	-- LDI R0, $6 	--CARREGA O R0 COM O VALOR 6
tmp(28) := STA & "00" & '0' & x"06";	-- STA R0, @6  	--ARMAZENA O VALOR 6 NA POSICAO 6
tmp(29) := LDI & "00" & '0' & x"0A";	-- LDI R0, $10 	--CARREGA O R0 COM O VALOR 10
tmp(30) := STA & "00" & '0' & x"0A";	-- STA R0, @10  	--ARMAZENA O VALOR 10 NA POSICAO 10
tmp(31) := NOP & "00" & '0' & x"00";	-- !INICIO
tmp(32) := LDA & "01" & '1' & x"42";	-- LDA R1, @322 	--CARREGA O VALOR DE SW9
tmp(33) := CEQ & "01" & '0' & x"00";	-- CEQ R1, @0 	--COMPARA COM 0  
tmp(34) := JEQ & "00" & '0' & x"24";	-- JEQ @LOOP
tmp(35) := JSR & "00" & '0' & x"A0";	-- JSR @SET
tmp(36) := NOP & "00" & '0' & x"00";	-- !LOOP 
tmp(37) := LDA & "01" & '0' & x"00";	-- LDA R1, @0 	--CARREGA O VALOR 0 NO R1
tmp(38) := STA & "01" & '1' & x"02";	-- STA R1, @258 	--DESLIGA O LEDR9
tmp(39) := LDA & "00" & '1' & x"7F";	-- LDA R0, @383 	--CARREGA O VALOR DE CLOCK 
tmp(40) := CEQ & "00" & '0' & x"00";	-- CEQ R0, @0 	--COMPARA COM 0
tmp(41) := JEQ & "00" & '0' & x"1F";	-- JEQ @INICIO
tmp(42) := JSR & "00" & '0' & x"2D";	-- JSR @AUMENTAUNISEG
tmp(43) := JSR & "00" & '0' & x"8F";	-- JSR @DISPLAY
tmp(44) := JMP & "00" & '0' & x"1F";	-- JMP @INICIO
tmp(45) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNISEG
tmp(46) := STA & "00" & '1' & x"FC";	-- STA R0, @508
tmp(47) := LDA & "00" & '0' & x"3A";	-- LDA R0, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(48) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1 
tmp(49) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(50) := JEQ & "00" & '0' & x"35";	-- JEQ @AUMENTAMDEZSEG
tmp(51) := STA & "00" & '0' & x"3A";	-- STA R0, @58 	--COPIA PARA UNIDADE SEGUNDOS
tmp(52) := RET & "00" & '0' & x"00";	-- RET
tmp(53) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZSEG
tmp(54) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(55) := STA & "00" & '0' & x"3A";	-- STA R0, @58  
tmp(56) := LDA & "00" & '0' & x"3B";	-- LDA R0, @59 	--CARREGA DEZENA SEGUNDOS
tmp(57) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(58) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(59) := JEQ & "00" & '0' & x"3E";	-- JEQ @AUMENTAUNIMIN
tmp(60) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--COPIA PARA DEZENA SEGUNDOS
tmp(61) := RET & "00" & '0' & x"00";	-- RET
tmp(62) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNIMIN
tmp(63) := LDA & "01" & '0' & x"01";	-- LDA R1, @1 	--CARREGA O VALOR 1 NO R1
tmp(64) := STA & "01" & '1' & x"00";	-- STA R1, @256 	--LIGA OS LED 1
tmp(65) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(66) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(67) := NOP & "00" & '0' & x"00";	-- !PULA2
tmp(68) := LDA & "00" & '0' & x"3C";	-- LDA R0, @60 	--CARREGA UNIDADE MINUTOS
tmp(69) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(70) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(71) := JEQ & "00" & '0' & x"4D";	-- JEQ @AUMENTAMDEZMIN
tmp(72) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--COPIA PARA UNIDADE MINUTOS
tmp(73) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(74) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(75) := JEQ & "00" & '0' & x"8F";	-- JEQ @DISPLAY
tmp(76) := RET & "00" & '0' & x"00";	-- RET
tmp(77) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZMIN
tmp(78) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(79) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(80) := LDA & "00" & '1' & x"61";	-- LDA R0, @353 	--CARREGA O R0 COM O VALOR K1
tmp(81) := CEQ & "00" & '0' & x"01";	-- CEQ R0, @1 	--COMPARA COM 1
tmp(82) := JEQ & "00" & '0' & x"43";	-- JEQ @PULA2
tmp(83) := LDA & "00" & '0' & x"3D";	-- LDA R0, @61 	--CARREGA DEZENA MINUTOS
tmp(84) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(85) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(86) := JEQ & "00" & '0' & x"5C";	-- JEQ @AUMENTAMUNIHOR
tmp(87) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--COPIA PARA DEZENA MINUTOS
tmp(88) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(89) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(90) := JEQ & "00" & '0' & x"8F";	-- JEQ @DISPLAY
tmp(91) := RET & "00" & '0' & x"00";	-- RET
tmp(92) := NOP & "00" & '0' & x"00";	-- !AUMENTAMUNIHOR
tmp(93) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(94) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(95) := JEQ & "00" & '0' & x"62";	-- JEQ @PULA
tmp(96) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(97) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(98) := NOP & "00" & '0' & x"00";	-- !PULA
tmp(99) := LDA & "00" & '0' & x"3E";	-- LDA R0, @62 	--CARREGA UNIDADE HORAS
tmp(100) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(101) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(102) := CEQ & "10" & '0' & x"02";	-- CEQ R2, @2 	--COMPARA COM 2
tmp(103) := JEQ & "00" & '0' & x"6F";	-- JEQ @CHECK2
tmp(104) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(105) := JEQ & "00" & '0' & x"77";	-- JEQ @AUMENTAMDEZHOR
tmp(106) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--COPIA PARA UNIDADE HORAS
tmp(107) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(108) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(109) := JEQ & "00" & '0' & x"8F";	-- JEQ @DISPLAY
tmp(110) := RET & "00" & '0' & x"00";	-- RET
tmp(111) := NOP & "00" & '0' & x"00";	-- !CHECK2
tmp(112) := CEQ & "00" & '0' & x"04";	-- CEQ R0, @4 	--COMPARA COM 4
tmp(113) := JEQ & "00" & '0' & x"83";	-- JEQ @NEWDAY
tmp(114) := STA & "00" & '0' & x"3E";	-- STA R0, @62
tmp(115) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(116) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(117) := JEQ & "00" & '0' & x"8F";	-- JEQ @DISPLAY
tmp(118) := RET & "00" & '0' & x"00";	-- RET
tmp(119) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZHOR
tmp(120) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(121) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(122) := LDA & "00" & '0' & x"3F";	-- LDA R0, @63 	--CARREGA DEZENA HORAS
tmp(123) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(124) := CEQ & "00" & '0' & x"03";	-- CEQ R0, @3 	--COMPARA COM 3
tmp(125) := JEQ & "00" & '0' & x"83";	-- JEQ @NEWDAY
tmp(126) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--COPIA PARA DEZENA HORAS
tmp(127) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(128) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(129) := JEQ & "00" & '0' & x"8F";	-- JEQ @DISPLAY
tmp(130) := RET & "00" & '0' & x"00";	-- RET
tmp(131) := NOP & "00" & '0' & x"00";	-- !NEWDAY 
tmp(132) := LDA & "10" & '1' & x"42";	-- LDA R2, @322 	--CARREGA O VALOR DE K0
tmp(133) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(134) := JEQ & "00" & '0' & x"A3";	-- JEQ @ZERAHORA
tmp(135) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(136) := STA & "00" & '0' & x"3A";	-- STA R0, @58  	--LIMPA UNIDADE SEGUNDOS
tmp(137) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(138) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(139) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(140) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(141) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(142) := RET  & "00" & '0' & x"00";	-- RET 
tmp(143) := NOP & "00" & '0' & x"00";	-- !DISPLAY 
tmp(144) := LDA & "10" & '0' & x"3A";	-- LDA R2, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(145) := STA & "10" & '1' & x"20";	-- STA R2, @288 	--COPIA PARA H0
tmp(146) := LDA & "10" & '0' & x"3B";	-- LDA R2, @59 	--CARREGA DEZENA SEGUNDOS
tmp(147) := STA & "10" & '1' & x"21";	-- STA R2, @289 	--COPIA PARA H1
tmp(148) := LDA & "10" & '0' & x"3C";	-- LDA R2, @60 	--CARREGA UNIDADE MINUTOS
tmp(149) := STA & "10" & '1' & x"22";	-- STA R2, @290 	--COPIA PARA H2
tmp(150) := LDA & "10" & '0' & x"3D";	-- LDA R2, @61 	--CARREGA DEZENA MINUTOS
tmp(151) := STA & "10" & '1' & x"23";	-- STA R2, @291 	--COPIA PARA H3
tmp(152) := LDA & "10" & '0' & x"3E";	-- LDA R2, @62 	--CARREGA UNIDADE HORAS
tmp(153) := STA & "10" & '1' & x"24";	-- STA R2, @292 	--COPIA PARA H4
tmp(154) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(155) := STA & "10" & '1' & x"25";	-- STA R2, @293 	--COPIA PARA H5
tmp(156) := LDA & "01" & '1' & x"42";	-- LDA R1, @322 	--CARREGA O VALOR DE SW9	
tmp(157) := CEQ & "01" & '0' & x"01";	-- CEQ R1, @1 	--COMPARA COM 1
tmp(158) := JEQ & "00" & '0' & x"A0";	-- JEQ @SET
tmp(159) := RET & "00" & '0' & x"00";	-- RET
tmp(160) := NOP & "00" & '0' & x"00";	-- !SET
tmp(161) := STA & "00" & '1' & x"FF";	-- STA R0, @511 	--LIMPA K0
tmp(162) := STA & "00" & '1' & x"FE";	-- STA R0, @510 	--LIMPA K1
tmp(163) := NOP & "00" & '0' & x"00";	-- !HORA
tmp(164) := LDA & "10" & '0' & x"01";	-- LDA R2, @1 	--CARREGA O R0 COM O VALOR 1
tmp(165) := STA & "10" & '1' & x"02";	-- STA R2, @258 	--ACENDE LED
tmp(166) := LDA & "01" & '1' & x"60";	-- LDA R1, @352 	--CARREGA O VALOR DE K0
tmp(167) := CEQ & "01" & '0' & x"01";	-- CEQ R1, @1 	--COMPARA COM 1
tmp(168) := JEQ & "00" & '0' & x"5C";	-- JEQ @AUMENTAMUNIHOR
tmp(169) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(170) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(171) := JEQ & "00" & '0' & x"3E";	-- JEQ @AUMENTAUNIMIN
tmp(172) := LDA & "11" & '1' & x"42";	-- LDA R3, @322 	--CARREGA O VALOR DE SW9
tmp(173) := CEQ & "11" & '0' & x"01";	-- CEQ R3, @1 	--COMPARA COM 1
tmp(174) := JEQ & "00" & '0' & x"A3";	-- JEQ @HORA
tmp(175) := RET & "00" & '0' & x"00";	-- RET
tmp(176) := NOP & "00" & '0' & x"00";	-- !ZERAHORA
tmp(177) := LDA & "01" & '0' & x"01";	-- LDA R1, @1 	--CARREGA O VALOR 0 NO R1
tmp(178) := STA & "01" & '1' & x"01";	-- STA R1, @257 	--LIGA O LEDR8
tmp(179) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(180) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(181) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(182) := JMP & "00" & '0' & x"8F";	-- JMP @DISPLAY





        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;