import re

def process_line(line):
    #return [word.replace(',', '') for word in line.strip().split()]
    # Remove everything after #
    string = re.sub(r'#.*', '', line)

    # Split by space or comma
    result = re.split(r'[,\s]+', string)
    return result

def hex_to_bin(hexdec):
    # Initialize an empty string to store the binary value
    binary = ""
    # Iterate over each character in the hexadecimal string
    for _hex in hexdec:
        # Convert the hexadecimal character to a decimal value
        dec = int(_hex, 16)
        # Convert the decimal value to binary and remove the '0b' prefix
        # Pad the binary value with zeros if needed to reach 4 bits
        binary += bin(dec)[2:].rjust(4,"0")
    # Pad the binary value with zeros if needed to reach 16 bits
    return binary.zfill(16)

def int_to_bin(integer):
    return bin(integer)[2:].zfill(16)

def line_to_command(line, counter):
    
    opcode = '00000_'
    dest = '000_'
    src1 = '000_'
    src2 = '000_'
    imm_Value = '0000000000000000_'
    uselessbits = '00' # total size will be 32 + 5 for '_'
    
    opcode_dict = { 'NOP' : '00000_',
                'SETC' : '00001_',
                'CLRC' : '00010_',
                'NOT' : '00011_',
                'INC' : '00100_',
                'DEC' : '00101_',
                'MOV' : '00110_',
                'ADD' : '00111_',
                'IADD' : '01000_',
                'SUB' : '01001_',
                'AND' : '01010_',
                'OR' : '01011_',
                'IN' : '01100_',
                'OUT' : '01101_',
                'PUSH' : '01110_',
                'POP' : '01111_',
                'LDM' : '10000_',
                'LDD' : '10001_',
                'STD' : '10010_',
                'JZ' : '10011_',
                'JC' : '10100_',
                'JMP' : '10101_',
                'CALL' : '10110_',
                'RET' : '10111_',
                'RTI' : '11000_'}
    
    register_dict = {   'R0' : '000_',
                        'R1' : '001_',
                        'R2' : '010_',
                        'R3' : '011_',
                        'R4' : '100_',
                        'R5' : '101_',
                        'R6' : '110_',
                        'R7' : '111_'
                    }
    
    #out, push have OPCODE AND src1 only 
    if line[0] == 'OUT' or line[0] == 'PUSH': 
        opcode = opcode_dict[line[0]] 
        src1 = register_dict[line[1]]
        
    #ldm has OPCODE AND dest and immediate only 
    elif line[0] == 'LDM': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        imm_Value = hex_to_bin(line[2]) + '_'
    
    #ldm has OPCODE AND dest and src1 and immediate only 
    elif line[0] == 'IADD': 
        opcode = opcode_dict[line[0]] 
        dest = register_dict[line[1]]
        src1 = register_dict[line[2]]
        imm_Value = hex_to_bin(line[3]) + '_'
        
    #RTI AND RET AND NOP AND SETC AND CLRC HAVE OPCODE ONLY
    elif line[0] == 'RTI' or line[0] == 'RET' or line[0] == 'NOP' or line[0] == 'SETC' or line[0] == 'CLRC':
        opcode = opcode_dict[line[0]]
    #STD HAS OPCODE AND SRC1 AND SRC2 ONLY
    elif line[0] == 'STD':
        opcode = opcode_dict[line[0]]
        src1 = register_dict[line[1]]
        src2 = register_dict[line[2]]
        
    #IN AND JMP AND INC AND CALL AND JC AND JZ AND POP HAVE OPCODE AND DEST ONLY
    elif line[0] == 'IN' or line[0] == 'JMP'  or line[0] == 'CALL' or line[0] == 'JC' or line[0] == 'JZ' or line[0] == 'POP':
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        
    #NOT AND DEC AND MOV AND LDD HAVE OPCODE AND DEST AND SRC1 ONLY
    elif line[0] == 'NOT' or line[0] == 'DEC' or line[0] == 'INC' or line[0] == 'MOV' or line[0] == 'LDD':
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        try:
            src1 = register_dict[line[2]]
        except: src1 = register_dict[line[1]]
    
    #ADD AND SUB AND AND AND OR HAVE OPCODE AND DEST AND SRC1 AND SRC2 ONLY
    elif line[0] == 'ADD' or line[0] == 'SUB' or line[0] == 'AND' or line[0] == 'OR':
        opcode = opcode_dict[line[0]]
        dest = register_dict[line[1]]
        src1 = register_dict[line[2]]
        src2 = register_dict[line[3]]
    
    else:
        print('instruction transalation error', counter, opcode, dest, src1, src2, imm_Value)
        for x in line:
            print(x)
        
    return str(counter) + ": " + opcode + dest + src1 + src2 + imm_Value + uselessbits
    
    
def work(inputfile, outputfile, memfile):
    instruction_write_dict = {}
    mem_write_dict = {}
    
    with open(inputfile) as f, open(outputfile, 'w') as out:
        counter = 0
        for line in f:
            
            if len(line.strip()) == 0 or line.strip()[0] == '#': continue
            
            result = process_line(line)
            #print('result', result)
            
            if ( result[0].isdigit() or all(c in '0123456789abcdefABCDEF' for c in result[0]) ):
                mem_write_dict[counter] =  hex_to_bin( result[0] ) 
            elif result[0].lower() == '.org': 
                counter = int(result[1])
            else:    
                result = line_to_command(result, hex(counter)[2:])
                instruction_write_dict[counter] = result
                counter +=1
                
        
        # print('dict printing')
        # for key,val in instruction_write_dict.items():
        #     print( key,val)
                
        for x in range(2**16):
            if x in instruction_write_dict.keys():
                out.write(''.join(instruction_write_dict[x]) + '\n')
            else: 
                result = process_line('NOP')
                result = line_to_command(result, hex(x)[2:])
                out.write(''.join(result) + '\n')
                
                
    with open(memfile, 'w') as out:    
        for x in range(2**16):
            if x in mem_write_dict.keys():
                out.write(''.join(hex(x)[2:] + ': ' + str(mem_write_dict[x])) + '\n')
            else: 
                out.write(''.join(hex(x)[2:] + ': 0000000000000000') + '\n')    

            
if __name__ == '__main__':
    work('D:\\projects\\Pipelined-Processor\\interpreter\\file.txt', 
         'D:\\projects\\Pipelined-Processor\\interpreter\\anotherfile.txt', 'D:\\projects\\Pipelined-Processor\\interpreter\\placeholdermem.txt')
    print('done')
    work('D:\\projects\\Pipelined-Processor\\interpreter\\orgtest.txt', 
         'D:\\projects\\Pipelined-Processor\\interpreter\\orgtestoutput.txt', 'D:\\projects\\Pipelined-Processor\\interpreter\\placeholdermem.txt')
    print('done')
    work('D:\\projects\\Pipelined-Processor\\interpreter\\codepart2.txt', 
         'D:\\projects\\Pipelined-Processor\\interpreter\\codepart2translation.txt', 'D:\\projects\\Pipelined-Processor\\interpreter\\codepart2mem.txt')
    print('done')
    
    #testing funcs
    #print(hex_to_bin('a1'))
    #print(process_line('inc ax, bx, cx'))
    #print(line_to_command( ['PUSH', 'R1']  ))
    #print(line_to_command( ['OUT', 'R7']  ))
    #print(len(line_to_command( ['OUT R2']  )))