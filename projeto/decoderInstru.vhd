library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
         saida : out std_logic_vector(11 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI : std_logic_vector(3 downto 0) := "0100";
  constant STA : std_logic_vector(3 downto 0) := "0101";
  constant JMP : std_logic_vector(3 downto 0) := "0110";
  constant JEQ : std_logic_vector(3 downto 0) := "0111";
  constant CEQ : std_logic_vector(3 downto 0) := "1000";
  constant RET : std_logic_vector(3 downto 0) := "1010";
  constant JSR : std_logic_vector(3 downto 0) := "1001";

  alias HabEscritaMEM : std_logic is saida(0);
  alias HabLeituraMEM : std_logic is saida(1);
  alias HabFlagIgual : std_logic is saida(2);
  alias OpULA : std_logic_vector is saida(4 downto 3);
  alias HabilitaA : std_logic is saida(5);
  alias SelMux : std_logic is saida(6);
  alias JEQ_Controle : std_logic is saida(7);
  alias JSR_Controle : std_logic is saida(8);
  alias RET_Controle : std_logic is saida(9);
  alias JMP_Controle : std_logic is saida(10);
  alias habEscritaRetorno : std_logic is saida(11);
  

  begin
--saida <= 	"000000000000" when opcode = NOP else
--         	"000000110010" when opcode = LDA else
--         	"000000101010" when opcode = SOMA else
--         	"000000100010" when opcode = SUB else
--         	"000001110000" when opcode = LDI else
--				"000000000001" when opcode = STA else
--				"010000000000" when opcode = JMP else
--				"000010000000" when opcode = JEQ else
--				"000000000110" when opcode = CEQ else
--				"100100000000" when opcode = JSR else
--				"001000000000" when opcode = RET else
--         	"000000000000";  -- NOP para os opcodes Indefinidos 
			
HabEscritaMEM <= '1' when (opcode = STA) else '0';
HabLeituraMEM <= '1' when (opcode = LDA) or (opcode = SOMA) or (opcode = SUB) or (opcode = CEQ) else '0';
HabFlagIgual <= '1' when (opcode = CEQ) else '0';
OpULA <= "01" when (opcode = SOMA) else
				"00" when (opcode = SUB) or (opcode = CEQ) else
				"10";
HabilitaA <= '1' when (opcode = LDI) or (opcode = LDA) or (opcode = SOMA) or (opcode = SUB) else '0';
SelMux <= '1' when (opcode = LDI) else '0';
JEQ_Controle <= '1' when (opcode = JEQ) else '0';
JSR_Controle <= '1' when (opcode = JSR) else '0';
RET_Controle <= '1' when (opcode = RET) else '0';
JMP_Controle <= '1' when (opcode = JMP) else '0';
habEscritaRetorno <= '1' when (opcode = JSR) else '0'; 

			
end architecture;