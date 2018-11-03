#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    pid_t pid = -42;
    int wstatus = -42;
    int ret = -1;
    int c;
    FILE *fd;
    char str[128];
    
    pid = fork();
    switch (pid) {
        case -1:
            perror("fork");
            return EXIT_FAILURE;
        case 0:
            sleep(1);
            printf("Noooooo!\n");
            exit(0);
        default:
            printf("Iamyourfather!\n");
            sprintf(str, "/proc/%d/maps", pid);
            fd = fopen(str, "r");
            if (!fd) {
                perror("fopen");
                break;
            }
            while ((c = fgetc(fd)) != EOF) {
                if (putchar(c) < 0) {
                    fclose(fd);
                    break;
                }
            }
            fclose(fd);
            break;
    }
    
    ret = waitpid(pid, &wstatus, 0);
    if (ret == -1) {
        perror("waitpid");
        return EXIT_FAILURE;
    }
    printf("Childexitstatus: %d\n",
           WEXITSTATUS(wstatus));
    return EXIT_SUCCESS;
}
