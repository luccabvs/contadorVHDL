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
tmp(35) := JSR & "00" & '0' & x"A4";	-- JSR @SET
tmp(36) := NOP & "00" & '0' & x"00";	-- !LOOP
tmp(37) := LDA & "01" & '0' & x"00";	-- LDA R1, @0 	--CARREGA O VALOR 0 NO R1
tmp(38) := STA & "01" & '1' & x"02";	-- STA R1, @258 	--DESLIGA O LEDR9
tmp(39) := LDA & "00" & '1' & x"7F";	-- LDA R0, @383 	--CARREGA O VALOR DE CLOCK 
tmp(40) := CEQ & "00" & '0' & x"00";	-- CEQ R0, @0 	--COMPARA COM 0
tmp(41) := JEQ & "00" & '0' & x"1F";	-- JEQ @INICIO
tmp(42) := JSR & "00" & '0' & x"30";	-- JSR @AUMENTAUNISEG
tmp(43) := JSR & "00" & '0' & x"93";	-- JSR @DISPLAY
tmp(44) := LDA & "11" & '1' & x"64";	-- LDA R3, @356 	--CARREGA O VALOR DE FPGA_RESET
tmp(45) := CEQ & "11" & '0' & x"01";	-- CEQ R3, @1 	--COMPARA COM 1
tmp(46) := JEQ & "00" & '0' & x"00";	-- JEQ @RESET
tmp(47) := JMP & "00" & '0' & x"1F";	-- JMP @INICIO
tmp(48) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNISEG
tmp(49) := STA & "00" & '1' & x"FC";	-- STA R0, @508
tmp(50) := LDA & "00" & '0' & x"3A";	-- LDA R0, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(51) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1 
tmp(52) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(53) := JEQ & "00" & '0' & x"38";	-- JEQ @AUMENTAMDEZSEG
tmp(54) := STA & "00" & '0' & x"3A";	-- STA R0, @58 	--COPIA PARA UNIDADE SEGUNDOS
tmp(55) := RET & "00" & '0' & x"00";	-- RET
tmp(56) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZSEG
tmp(57) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(58) := STA & "00" & '0' & x"3A";	-- STA R0, @58  
tmp(59) := LDA & "00" & '0' & x"3B";	-- LDA R0, @59 	--CARREGA DEZENA SEGUNDOS
tmp(60) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(61) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(62) := JEQ & "00" & '0' & x"41";	-- JEQ @AUMENTAUNIMIN
tmp(63) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--COPIA PARA DEZENA SEGUNDOS
tmp(64) := RET & "00" & '0' & x"00";	-- RET
tmp(65) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNIMIN
tmp(66) := LDA & "00" & '1' & x"61";	-- LDA R0, @353 	--CARREGA O R0 COM O VALOR K1
tmp(67) := CEQ & "00" & '0' & x"01";	-- CEQ R0, @1 	--COMPARA COM 1
tmp(68) := JEQ & "00" & '0' & x"47";	-- JEQ @PULA2
tmp(69) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(70) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(71) := NOP & "00" & '0' & x"00";	-- !PULA2
tmp(72) := LDA & "00" & '0' & x"3C";	-- LDA R0, @60 	--CARREGA UNIDADE MINUTOS
tmp(73) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(74) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(75) := JEQ & "00" & '0' & x"51";	-- JEQ @AUMENTAMDEZMIN
tmp(76) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--COPIA PARA UNIDADE MINUTOS
tmp(77) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(78) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(79) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(80) := RET & "00" & '0' & x"00";	-- RET
tmp(81) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZMIN
tmp(82) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(83) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(84) := LDA & "00" & '0' & x"3D";	-- LDA R0, @61 	--CARREGA DEZENA MINUTOS
tmp(85) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(86) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(87) := JEQ & "00" & '0' & x"5D";	-- JEQ @AUMENTAUNIHOR
tmp(88) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--COPIA PARA DEZENA MINUTOS
tmp(89) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(90) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(91) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(92) := RET & "00" & '0' & x"00";	-- RET
tmp(93) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNIHOR
tmp(94) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(95) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(96) := JEQ & "00" & '0' & x"66";	-- JEQ @PULA
tmp(97) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(98) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(99) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(100) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(101) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(102) := NOP & "00" & '0' & x"00";	-- !PULA
tmp(103) := LDA & "00" & '0' & x"3E";	-- LDA R0, @62 	--CARREGA UNIDADE HORAS
tmp(104) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(105) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(106) := CEQ & "10" & '0' & x"02";	-- CEQ R2, @2 	--COMPARA COM 2
tmp(107) := JEQ & "00" & '0' & x"73";	-- JEQ @CHECK2
tmp(108) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(109) := JEQ & "00" & '0' & x"7B";	-- JEQ @AUMENTAMDEZHOR
tmp(110) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--COPIA PARA UNIDADE HORAS
tmp(111) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(112) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(113) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(114) := RET & "00" & '0' & x"00";	-- RET
tmp(115) := NOP & "00" & '0' & x"00";	-- !CHECK2
tmp(116) := CEQ & "00" & '0' & x"04";	-- CEQ R0, @4 	--COMPARA COM 4
tmp(117) := JEQ & "00" & '0' & x"87";	-- JEQ @NEWDAY
tmp(118) := STA & "00" & '0' & x"3E";	-- STA R0, @62
tmp(119) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(120) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(121) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(122) := RET & "00" & '0' & x"00";	-- RET
tmp(123) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZHOR
tmp(124) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(125) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(126) := LDA & "00" & '0' & x"3F";	-- LDA R0, @63 	--CARREGA DEZENA HORAS
tmp(127) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(128) := CEQ & "00" & '0' & x"03";	-- CEQ R0, @3 	--COMPARA COM 3
tmp(129) := JEQ & "00" & '0' & x"87";	-- JEQ @NEWDAY
tmp(130) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--COPIA PARA DEZENA HORAS
tmp(131) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(132) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(133) := JEQ & "00" & '0' & x"93";	-- JEQ @DISPLAY
tmp(134) := RET & "00" & '0' & x"00";	-- RET
tmp(135) := NOP & "00" & '0' & x"00";	-- !NEWDAY 
tmp(136) := LDA & "10" & '1' & x"60";	-- LDA R2, @352 	--CARREGA O VALOR DE K0
tmp(137) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(138) := JEQ & "00" & '0' & x"B9";	-- JEQ @ZERA
tmp(139) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(140) := STA & "00" & '0' & x"3A";	-- STA R0, @58  	--LIMPA UNIDADE SEGUNDOS
tmp(141) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(142) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(143) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(144) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(145) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(146) := RET  & "00" & '0' & x"00";	-- RET 
tmp(147) := NOP & "00" & '0' & x"00";	-- !DISPLAY 
tmp(148) := LDA & "10" & '0' & x"3A";	-- LDA R2, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(149) := STA & "10" & '1' & x"20";	-- STA R2, @288 	--COPIA PARA H0
tmp(150) := LDA & "10" & '0' & x"3B";	-- LDA R2, @59 	--CARREGA DEZENA SEGUNDOS
tmp(151) := STA & "10" & '1' & x"21";	-- STA R2, @289 	--COPIA PARA H1
tmp(152) := LDA & "10" & '0' & x"3C";	-- LDA R2, @60 	--CARREGA UNIDADE MINUTOS
tmp(153) := STA & "10" & '1' & x"22";	-- STA R2, @290 	--COPIA PARA H2
tmp(154) := LDA & "10" & '0' & x"3D";	-- LDA R2, @61 	--CARREGA DEZENA MINUTOS
tmp(155) := STA & "10" & '1' & x"23";	-- STA R2, @291 	--COPIA PARA H3
tmp(156) := LDA & "10" & '0' & x"3E";	-- LDA R2, @62 	--CARREGA UNIDADE HORAS
tmp(157) := STA & "10" & '1' & x"24";	-- STA R2, @292 	--COPIA PARA H4
tmp(158) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(159) := STA & "10" & '1' & x"25";	-- STA R2, @293 	--COPIA PARA H5
tmp(160) := LDA & "01" & '1' & x"42";	-- LDA R1, @322 	--CARREGA O VALOR DE SW9	
tmp(161) := CEQ & "01" & '0' & x"01";	-- CEQ R1, @1 	--COMPARA COM 1
tmp(162) := JEQ & "00" & '0' & x"A4";	-- JEQ @SET
tmp(163) := RET & "00" & '0' & x"00";	-- RET
tmp(164) := NOP & "00" & '0' & x"00";	-- !SET
tmp(165) := STA & "00" & '1' & x"FF";	-- STA R0, @511 	--LIMPA K0
tmp(166) := STA & "00" & '1' & x"FE";	-- STA R0, @510 	--LIMPA K1
tmp(167) := LDA & "00" & '0' & x"00";	-- LDA R0, @0
tmp(168) := STA & "00" & '0' & x"3A";	-- STA R0, @58  	--LIMPA UNIDADE SEGUNDOS
tmp(169) := STA & "00" & '1' & x"20";	-- STA R0, @288 	--COPIA PARA H0
tmp(170) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(171) := STA & "00" & '1' & x"21";	-- STA R0, @289 	--COPIA PARA H1
tmp(172) := NOP & "00" & '0' & x"00";	-- !HORA
tmp(173) := LDA & "10" & '0' & x"01";	-- LDA R2, @1 	--CARREGA O R0 COM O VALOR 1
tmp(174) := STA & "10" & '1' & x"02";	-- STA R2, @258 	--ACENDE LED
tmp(175) := LDA & "01" & '1' & x"60";	-- LDA R1, @352 	--CARREGA O VALOR DE K0
tmp(176) := CEQ & "01" & '0' & x"01";	-- CEQ R1, @1 	--COMPARA COM 1
tmp(177) := JEQ & "00" & '0' & x"5D";	-- JEQ @AUMENTAUNIHOR
tmp(178) := LDA & "10" & '1' & x"61";	-- LDA R2, @353 	--CARREGA O VALOR DE K1
tmp(179) := CEQ & "10" & '0' & x"01";	-- CEQ R2, @1 	--COMPARA COM 1
tmp(180) := JEQ & "00" & '0' & x"41";	-- JEQ @AUMENTAUNIMIN
tmp(181) := LDA & "11" & '1' & x"42";	-- LDA R3, @322 	--CARREGA O VALOR DE SW9
tmp(182) := CEQ & "11" & '0' & x"01";	-- CEQ R3, @1 	--COMPARA COM 1
tmp(183) := JEQ & "00" & '0' & x"AC";	-- JEQ @HORA
tmp(184) := RET & "00" & '0' & x"00";	-- RET
tmp(185) := NOP & "00" & '0' & x"00";	-- !ZERA
tmp(186) := LDA & "01" & '0' & x"01";	-- LDA R1, @1 	--CARREGA O VALOR 1 NO R1
tmp(187) := STA & "01" & '1' & x"01";	-- STA R1, @257 	--LIGA O LEDR8
tmp(188) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(189) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(190) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(191) := JMP & "00" & '0' & x"93";	-- JMP @DISPLAY

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;