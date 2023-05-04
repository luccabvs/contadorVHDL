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
  constant ADD : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI : std_logic_vector(3 downto 0) := "0100";
  constant STA : std_logic_vector(3 downto 0) := "0101";
  constant JMP : std_logic_vector(3 downto 0) := "0110";
  constant JEQ : std_logic_vector(3 downto 0) := "0111";
  constant CEQ : std_logic_vector(3 downto 0) := "1000";
  constant JSR : std_logic_vector(3 downto 0) := "1001";
  constant RET : std_logic_vector(3 downto 0) := "1010";
  constant ADDI : std_logic_vector(3 downto 0) := "1011";
  constant SUBI : std_logic_vector(3 downto 0) := "1100";

  alias wr : std_logic is saida(0);
  alias rd : std_logic is saida(1);
  alias habFlag : std_logic is saida(2);
  alias opULA : std_logic_vector is saida(4 downto 3);
  alias habWrRegs : std_logic is saida(5);
  alias selMux : std_logic is saida(6);
  alias JEQ_Controle : std_logic is saida(7);
  alias JSR_Controle : std_logic is saida(8);
  alias RET_Controle : std_logic is saida(9);
  alias JMP_Controle : std_logic is saida(10);
  alias habEscritaRetorno : std_logic is saida(11);
  

  begin
			
wr <= '1' when (opcode = STA) else '0';

rd <= '1' when (opcode = LDA) or (opcode = ADD) or (opcode = SUB) or (opcode = CEQ) else '0';

habFlag <= '1' when (opcode = CEQ) else '0';

OpULA <= "01" when (opcode = ADD) else
				"00" when (opcode = SUB) or (opcode = CEQ) else
				"10";

habWrRegs <= '1' when (opcode = LDI) or (opcode = LDA) or (opcode = ADD) or (opcode = ADDI) or (opcode = SUB) or (opcode = SUBI) else '0';

SelMux <= '1' when (opcode = LDI) or (opcode = ADDI) or (opcode = SUBI) else '0';

JEQ_Controle <= '1' when (opcode = JEQ) else '0';

JSR_Controle <= '1' when (opcode = JSR) else '0';

RET_Controle <= '1' when (opcode = RET) else '0';

JMP_Controle <= '1' when (opcode = JMP) else '0';

habEscritaRetorno <= '1' when (opcode = JSR) else '0'; 

			
end architecture;

