LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity muxGenericoNx1 is
  generic ( larguraEntrada : natural := 9;
        larguraSelecao : natural := 2
		  );
  port (
    entradaA_MUX : in  std_logic_vector(larguraEntrada-1 downto 0);
    entradaB_MUX : in  std_logic_vector(larguraEntrada-1 downto 0);
    entradaC_MUX : in  std_logic_vector(larguraEntrada-1 downto 0);
    entradaD_MUX : in  std_logic_vector(larguraEntrada-1 downto 0);
    seletor_MUX : in  std_logic_vector(larguraSelecao-1 downto 0);
    saida_MUX   : out std_logic_vector(larguraEntrada-1 downto 0)
  );
end entity;

architecture Behavioral of muxGenericoNx1 is
begin
    saida_MUX <= entradaA_MUX when (seletor_MUX = "00") else
					  entradaB_MUX when (seletor_MUX = "01") else
					  entradaC_MUX when (seletor_MUX = "10") else
					  entradaD_MUX;
end architecture;