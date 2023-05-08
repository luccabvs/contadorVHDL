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
tmp(2) := STA & "00" & '0' & x"00";	-- STA R0, @0  	-- LIMPA LUGAR DA MEMÓRIA 0
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
tmp(20) := STA & "00" & '0' & x"01";	-- STA R0, @1  	-- ARMAZENA O VALOR 1 NA POSICAO 1
tmp(21) := LDI & "00" & '0' & x"03";	-- LDI R0, $3 	--CARREGA O R0 COM O VALOR 3
tmp(22) := STA & "00" & '0' & x"03";	-- STA R0, @3  	-- ARMAZENA O VALOR 3 NA POSICAO 3
tmp(23) := LDI & "00" & '0' & x"04";	-- LDI R0, $4 	--CARREGA O R0 COM O VALOR 4
tmp(24) := STA & "00" & '0' & x"04";	-- STA R0, @4  	-- ARMAZENA O VALOR 4 NA POSICAO 4
tmp(25) := LDI & "00" & '0' & x"06";	-- LDI R0, $6 	--CARREGA O R0 COM O VALOR 6
tmp(26) := STA & "00" & '0' & x"06";	-- STA R0, @6  	-- ARMAZENA O VALOR 6 NA POSICAO 6
tmp(27) := LDI & "00" & '0' & x"0A";	-- LDI R0, $10 	--CARREGA O R0 COM O VALOR 10
tmp(28) := STA & "00" & '0' & x"0A";	-- STA R0, @10  	-- ARMAZENA O VALOR 10 NA POSICAO 10
tmp(29) := NOP & "00" & '0' & x"00";	-- !INICIO
tmp(30) := LDA & "01" & '1' & x"61";	-- LDA R1, @353 	--CARREGA O VALOR DE K1
tmp(31) := CEQ & "01" & '0' & x"00";	-- CEQ R1, @0 	--COMPARA COM 0  
tmp(32) := JEQ & "00" & '0' & x"22";	-- JEQ @LOOP
tmp(33) := JSR & "00" & '0' & x"29";	-- JSR @HORAS
tmp(34) := NOP & "00" & '0' & x"00";	-- !LOOP 
tmp(35) := LDA & "00" & '1' & x"7F";	-- LDA R0, @383 	--CARREGA O VALOR DE CLOCK 
tmp(36) := CEQ & "00" & '0' & x"00";	-- CEQ R0, @0 	--COMPARA COM 0
tmp(37) := JEQ & "00" & '0' & x"1D";	-- JEQ @INICIO
tmp(38) := JSR & "00" & '0' & x"2B";	-- JSR @AUMENTAUNISEG
tmp(39) := JSR & "00" & '0' & x"6F";	-- JSR @DISPLAY
tmp(40) := JMP & "00" & '0' & x"1D";	-- JMP @INICIO
tmp(41) := NOP & "00" & '0' & x"00";	-- !HORAS
tmp(42) := RET & "00" & '0' & x"00";	-- RET
tmp(43) := NOP & "00" & '0' & x"00";	-- !AUMENTAUNISEG
tmp(44) := STA & "00" & '1' & x"FC";	-- STA R0, @508
tmp(45) := LDA & "00" & '0' & x"3A";	-- LDA R0, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(46) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1 
tmp(47) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(48) := JEQ & "00" & '0' & x"33";	-- JEQ @AUMENTAMDEZSEG
tmp(49) := STA & "00" & '0' & x"3A";	-- STA R0, @58 	--COPIA PARA UNIDADE SEGUNDOS
tmp(50) := RET & "00" & '0' & x"00";	-- RET
tmp(51) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZSEG
tmp(52) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(53) := STA & "00" & '0' & x"3A";	-- STA R0, @58  
tmp(54) := LDA & "00" & '0' & x"3B";	-- LDA R0, @59 	--CARREGA DEZENA SEGUNDOS
tmp(55) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(56) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(57) := JEQ & "00" & '0' & x"3C";	-- JEQ @AUMENTAMUNIMIN
tmp(58) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--COPIA PARA DEZENA SEGUNDOS
tmp(59) := RET & "00" & '0' & x"00";	-- RET
tmp(60) := NOP & "00" & '0' & x"00";	-- !AUMENTAMUNIMIN
tmp(61) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(62) := STA & "00" & '0' & x"3B";	-- STA R0, @59 	--LIMPA DEZENA SEGUNDOS
tmp(63) := LDA & "00" & '0' & x"3C";	-- LDA R0, @60 	--CARREGA UNIDADE MINUTOS
tmp(64) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(65) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(66) := JEQ & "00" & '0' & x"45";	-- JEQ @AUMENTAMDEZMIN
tmp(67) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--COPIA PARA UNIDADE MINUTOS
tmp(68) := RET & "00" & '0' & x"00";	-- RET
tmp(69) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZMIN
tmp(70) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(71) := STA & "00" & '0' & x"3C";	-- STA R0, @60 	--LIMPA UNIDADE MINUTOS
tmp(72) := LDA & "00" & '0' & x"3D";	-- LDA R0, @61 	--CARREGA DEZENA MINUTOS
tmp(73) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(74) := CEQ & "00" & '0' & x"06";	-- CEQ R0, @6 	--COMPARA COM 6
tmp(75) := JEQ & "00" & '0' & x"4E";	-- JEQ @AUMENTAMUNIHOR
tmp(76) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--COPIA PARA DEZENA MINUTOS
tmp(77) := RET & "00" & '0' & x"00";	-- RET
tmp(78) := NOP & "00" & '0' & x"00";	-- !AUMENTAMUNIHOR
tmp(79) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(80) := STA & "00" & '0' & x"3D";	-- STA R0, @61 	--LIMPA DEZENA MINUTOS
tmp(81) := LDA & "00" & '0' & x"3E";	-- LDA R0, @62 	--CARREGA UNIDADE HORAS
tmp(82) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(83) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(84) := CEQ & "10" & '0' & x"02";	-- CEQ R2, @2 	--COMPARA COM 2
tmp(85) := JEQ & "00" & '0' & x"5A";	-- JEQ @CHECK2
tmp(86) := CEQ & "00" & '0' & x"0A";	-- CEQ R0, @10 	--COMPARA COM 10
tmp(87) := JEQ & "00" & '0' & x"61";	-- JEQ @AUMENTAMDEZHOR
tmp(88) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--COPIA PARA UNIDADE HORAS
tmp(89) := RET & "00" & '0' & x"00";	-- RET
tmp(90) := NOP & "00" & '0' & x"00";	-- !CHECK2
tmp(91) := LDI & "01" & '0' & x"01";	-- LDI R1, $1
tmp(92) := STA & "01" & '1' & x"02";	-- STA R1, @258
tmp(93) := CEQ & "00" & '0' & x"04";	-- CEQ R0, @4 	--COMPARA COM 4
tmp(94) := JEQ & "00" & '0' & x"68";	-- JEQ @NEWDAY
tmp(95) := STA & "00" & '0' & x"3E";	-- STA R0, @62
tmp(96) := RET & "00" & '0' & x"00";	-- RET
tmp(97) := NOP & "00" & '0' & x"00";	-- !AUMENTAMDEZHOR
tmp(98) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(99) := STA & "00" & '0' & x"3E";	-- STA R0, @62 	--LIMPA UNIDADE HORAS
tmp(100) := LDA & "00" & '0' & x"3F";	-- LDA R0, @63 	--CARREGA DEZENA HORAS
tmp(101) := SOMA & "00" & '0' & x"01";	-- SOMA R0, @1 	--SOMA 1
tmp(102) := CEQ & "00" & '0' & x"03";	-- CEQ R0, @3 	--COMPARA COM 3
tmp(103) := JEQ & "00" & '0' & x"68";	-- JEQ @NEWDAY
tmp(104) := NOP & "00" & '0' & x"00";	-- !NEWDAY 
tmp(105) := LDA & "00" & '0' & x"00";	-- LDA R0, @0 	--CARREGA O R0 COM O VALOR 0
tmp(106) := STA & "00" & '0' & x"3F";	-- STA R0, @63 	--LIMPA DEZENA HORAS
tmp(107) := RET  & "00" & '0' & x"00";	-- RET 
tmp(108) := NOP & "00" & '0' & x"00";	-- 
tmp(109) := NOP & "00" & '0' & x"00";	-- 
tmp(110) := NOP & "00" & '0' & x"00";	-- 
tmp(111) := NOP & "00" & '0' & x"00";	-- !DISPLAY 
tmp(112) := LDA & "10" & '0' & x"3A";	-- LDA R2, @58 	--CARREGA UNIDADE SEGUNDOS
tmp(113) := STA & "10" & '1' & x"20";	-- STA R2, @288 	--COPIA PARA H0
tmp(114) := LDA & "10" & '0' & x"3B";	-- LDA R2, @59 	--CARREGA DEZENA SEGUNDOS
tmp(115) := STA & "10" & '1' & x"21";	-- STA R2, @289 	--COPIA PARA H1
tmp(116) := LDA & "10" & '0' & x"3C";	-- LDA R2, @60 	--CARREGA UNIDADE MINUTOS
tmp(117) := STA & "10" & '1' & x"22";	-- STA R2, @290 	--COPIA PARA H2
tmp(118) := LDA & "10" & '0' & x"3D";	-- LDA R2, @61 	--CARREGA DEZENA MINUTOS
tmp(119) := STA & "10" & '1' & x"23";	-- STA R2, @291 	--COPIA PARA H3
tmp(120) := LDA & "10" & '0' & x"3E";	-- LDA R2, @62 	--CARREGA UNIDADE HORAS
tmp(121) := STA & "10" & '1' & x"24";	-- STA R2, @292 	--COPIA PARA H4
tmp(122) := LDA & "10" & '0' & x"3F";	-- LDA R2, @63 	--CARREGA DEZENA HORAS
tmp(123) := STA & "10" & '1' & x"25";	-- STA R2, @293 	--COPIA PARA H5
tmp(124) := RET & "00" & '0' & x"00";	-- RET



        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;