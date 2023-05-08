inputASM = 'ASM.txt' #Arquivo de entrada de contém o assembly
outputBIN = 'BIN.txt' #Arquivo de saída que contém o binário formatado para VHDL
outputMIF = 'initROM.mif' #Arquivo de saída que contém o binário formatado para .mif

#definição dos mnemônicos e seus
#respectivo OPCODEs (em Hexadecimal)
registradores =	{ 
       "R0":   ' & "00"',
       "R1":   ' & "01"',
       "R2":   ' & "02"',
       "R3":   ' & "03"',
}

#Converte o valor após o caractere arroba '@'
#em um valor hexadecimal de 2 dígitos (9 bits) e...
#concatena com o bit de habilita 
def trataRegistrador(line):
    line = line.split(',')
    registrador = line[0][-2:]
    line[0] = line[0][:-3] + registradores[registrador]
    line = ''.join(line)
    return line
    
def transformaLabel(line):
    line = line.split('@')
    for label in labels.keys():
        if label in line[1]:
            line[1] = labels[label]
    line = '@'.join(line)
    return line

def  converteArroba9bits(line):
    line = line.split('@')
    if(int(line[1]) > 255 ):
        line[1] = str(int(line[1]) - 256)
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = "& '1' & x\"" + line[1] + '"'
    else:
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = "& '0' & x\"" + line[1] + '"'
    line = ''.join(line)
    return line

def  converteArroba9bitsDesvio(line):
    line = line.split('@')
    if(int(line[1]) > 255 ):
        line[1] = str(int(line[1]) - 256)
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = '& "00" & ' + "'1' & x\"" + line[1] + '"'
    else:
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = '& "00" & ' + "'0' & x\"" + line[1] + '"'
    line = ''.join(line)
    return line
 
 
#Converte o valor após o caractere cifrão'$'
#em um valor hexadecimal de 2 dígitos (9 bits) 
def converteCifrao9bits(line):
    line = line.split('$')
    if(int(line[1]) > 255 ):
        line[1] = str(int(line[1]) - 256)
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = "& '1' & x\"" + line[1] + '"'
    else:
        line[1] = hex(int(line[1]))[2:].upper().zfill(2)
        line[1] = "& '0' & x\"" + line[1] + '"'
    line = ''.join(line)
    return line
        
#Define a string que representa o comentário
#a partir do caractere cerquilha '#'
def defineComentario(line):
    if '--' in line:
        line = line.split('--')
        line = line[0] + "\t--" + line[1]
        return line
    else:
        return line

#Remove o comentário a partir do caractere '--',
#deixando apenas a instrução
def defineInstrucao(line):
    line = line.split('--')
    line = line[0]
    return line
    
#Consulta o dicionário e "converte" o mnemônico em
#seu respectivo valor em hexadecimal
'''def trataMnemonico(line):
    line = line.replace("\n", "") #Remove o caracter de final de linha
    line = line.replace("\t", "") #Remove o caracter de tabulacao
    line = line.split(' ')
    line[0] = mne[line[0]]
    line = "".join(line)
    return line'''

def labelDict(line):
    labels_dict = {}
    for id, line in enumerate(lines):
        if '!' in line:
            label = line.strip()[1:]
            labels_dict[label] = str(id)
    return labels_dict

with open(inputASM, "r") as f: #Abre o arquivo ASM
    lines = f.readlines() #Verifica a quantidade de linhas
    
    
with open(outputBIN, "w+") as f:  #Abre o destino BIN

    cont = 0 #Cria uma variável para contagem
    
    for line in lines:        
        
        #Exemplo de linha => 1. JSR @14 #comentario1
        comentarioLine = defineComentario(line).replace("\n","") #Define o comentário da linha. Ex: #comentario1
        instrucaoLine = defineInstrucao(line).replace("\n","") #Define a instrução. Ex: JSR @14
        labels = labelDict(line)

        # if '!' in line:
        #     labels_dict = gotoLabel(line)
        #     continue
        if ',' in line:
            instrucaoLine = trataRegistrador(instrucaoLine)
        if '!' in line or line == '\n':
            instrucaoLine = "NOP" + ' & "00" & ' + "\'0\' & " + "x\"00" + '"'
        elif '@' in instrucaoLine: #Se encontrar o caractere arroba '@' 
            instrucaoLine = transformaLabel(instrucaoLine)
            if line[:3] == 'JEQ' or line[:3] == 'JSR' or line[:3] == 'JMP':  
                instrucaoLine = converteArroba9bitsDesvio(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"   
            else:
                instrucaoLine = converteArroba9bits(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"
        elif '$' in instrucaoLine: #Se encontrar o caractere cifrao '$'
            instrucaoLine = converteCifrao9bits(instrucaoLine) #converte o número após o caractere Ex(LDI $5): x"4" x"05"
        else: #Senão, se a instrução nao possuir nenhum imediato, ou seja, nao conter '@' ou '$'
            instrucaoLine = instrucaoLine.replace("\n", "") #Remove a quebra de linha
            instrucaoLine = instrucaoLine + ' & "00" & ' + "\'0\' & " + "x\"00" + '"' #Acrescenta o valor x"00". Ex(RET): x"A" x"00"
        
        line = 'tmp(' + str(cont) + ') := ' + instrucaoLine + ';\t-- ' + comentarioLine + '\n'  #Formata para o arquivo BIN
                                                                                                    #Entrada => 1. JSR @14 #comentario1
                                                                                                    #Saída =>   1. tmp(0) := x"90E";	-- JSR @14 	#comentario1
        cont+=1 #Incrementa a variável de contagem, utilizada para incrementar as posições de memória no VHDL
        f.write(line) #Escreve no arquivo BIN.txt           

            
############################             
############################            
#Conversão para arquivo .mif
############################             
############################
            
with open(outputMIF, "r") as f: #Abre o arquivo de MIF
    headerMIF = f.readlines() #Faz a leitura das linhas do arquivo,
                              #para fazer a aquisição do header
    
    
with open(outputBIN, "r") as f: #Abre o arquivo BIN
    lines = f.readlines() #Faz a leitura das linhas do arquivo
    
    
with open(outputMIF, "w") as f:  #Abre o destino MIF

    cont = 0 #Cria uma variável para contagem
    
    for lineHeader in headerMIF:       
        if cont < 21:           #Contagem das linhas de cabeçalho
            f.write(lineHeader) #Escreve no arquivo se saída .mif o cabeçalho (21 linhas)
        cont = cont + 1         #Incrementa varíavel de contagem
        
    for line in lines:
        
            # f.write.replace('!' + label, 'NOP') #Substitui o label por NOP
            # f.write.replace('@' + label, Labels[label]) #Substitui o label pela Instrucao

        replacements = [('t', ''), ('m', ''), ('p', ''), ('(', ''), (')', ''), ('=', ''), ('x', ''), ('"', '')] #Define os caracteres que serão excluídos

        for char, replacement in replacements:
            if char in line:
                line = line.replace(char, replacement) #Remove os caracteres que foram definidos
                
        line = line.split('#') #Remove o comentário da linha
        
        if "\n" in line[0]:
            line = line[0] 
        else:
            line = line[0] + '\n' #Insere a quebra de linha ('\n') caso não tenha

        f.write(line) #Escreve no arquivo initROM.mif
    f.write("END;") #Acrescente o indicador de finalização da memória.