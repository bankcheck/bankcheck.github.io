#include <sys/types.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include <syslog.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <grp.h>
#include <pwd.h>
#include <stdarg.h>

#define DEFAULT_CFGFILE "/usr/instru/labout.cf"

static char     cfgfile[512];
char           *g_pRootDir = NULL;      /* system root directory */
int             g_nRunUserID = -1;      /* user id */
int		g_nRunGroupID = -1;	/* group id */
int             g_nLog = 0;             /* log */
short           g_nPort = 4921;         /* listen port */

int isalldigits(char *s)
{
    if (*s == '\0')
        return 0;
    while (isdigit((unsigned char)*s))
        s++;
    return (*s == '\0');
}

int mapgid(char *gnam)
{
    struct group    *gp;

    if (isalldigits(gnam))
        return atoi(gnam);
    gp = getgrnam(gnam);
    if (gp == NULL)
        return -1;
    return gp->gr_gid;
}

int mapuid(char *user)
{
    struct passwd   *pw;

    if (isalldigits(user) && user[0] != '\0')
        return atoi(user);
    pw = getpwnam(user);
    if (pw == NULL)
        return -1;
    return pw->pw_uid;
}

int RemoveSpace(char *str)
{
    char buf[1024];
    char *p;

    if (str == NULL)
        return 0;
    p = str;
    while (1) {
        if (*p != ' ')
            break;
        if (*p == '\0')
            break;
        p++;
    }
    strcpy(buf, p);
    strcpy(str, buf);
    return 1;
}

int RemoveEndSpace(char *str)
{
    int len;

    len = strlen(str);
    len--;
    while (1) {
        if (len < 0) break;
        if (str[len] != ' ')
            break;
        str[len] = '\0';
        len--;
    }
    return 0;
}

int TrimSpace(char *str)
{
    RemoveSpace(str);
    RemoveEndSpace(str);
    return 0;
}

static void load_config_file(char *fname, int reload)
{
    FILE *fp;
    char buf[1024];
    char *p;

    fp = fopen(fname, "rt");
    if (fp == NULL) {
        syslog(LOG_NOTICE, "Can't open configure file: %.512s", fname);
        exit(1);
    }
    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " =\t\r\n");
        if (p == NULL) continue;
        if (*p == ';') continue;    /* comment */
        if (reload == 0) {
            if (strcasecmp(p, "port") == 0) {           /* port */
                p = strtok(NULL, " \t\r\n");
                if (p == NULL) continue;
                g_nPort = atoi(p);
                continue;
            }
        }
        if (strcasecmp(p, "directory") == 0) {     /* directory */
            p = strtok(NULL, "\r\n");
            if (p == NULL) continue;
            TrimSpace(p);
            if (g_pRootDir != NULL)
                free(g_pRootDir);
            g_pRootDir = (char *)malloc(strlen(p)+1);
            if (g_pRootDir == NULL) {
                syslog(LOG_NOTICE, "Out of memory %m");
                exit(1);
            }
            strcpy(g_pRootDir, p);
            continue;
        }
        if (strcasecmp(p, "groupid") == 0) {        /* groupid */
            p = strtok(NULL, " \t\r\n");
            if (p == NULL) continue;
            g_nRunGroupID = mapgid(p);
            continue;
        }
        if (strcasecmp(p, "userid") == 0) {         /* userid */
            p = strtok(NULL, " \t\r\n");
            if (p == NULL) continue;
            g_nRunUserID = mapuid(p);
            continue;
        }
        if (strcasecmp(p, "log") == 0) {                /* log */
            p = strtok(NULL, " \t\r\n");
            if (p == NULL) continue;
            g_nLog = atoi(p);
            continue;
        }
    }
    fclose(fp);
    return;
}

static void reload_conf(void)
{
    syslog(LOG_NOTICE, "Reload %s", cfgfile);
    load_config_file(cfgfile, 1);
    return;
}

static void waitwaitwait(void)
{
    int cstat;

    while (waitpid(-1, &cstat, WNOHANG) > 0)
        ;
    return;
}

int getline(int s, char *buf, int siz)
{
    char    *p;
    char    ch;
    int     n;

    p = buf;
    n = 0;
    while (n < siz) {
        if (read(s, &ch, 1) < 0)
            return -1;
        n++;
        if (ch == '\n') {
            if (p > buf && *(p - 1) == '\r')
                p--;
            break;
        }
        *p++ = ch;
    }
    *p = '\0';
    return n;
}

int putline(int s, char *buf)
{
    return write(s, buf, strlen(buf));
}

void writelog(char *fmt, ...)
{
    char buf[1024];
    va_list marker;
    char fname[260];
    FILE *fp;
    time_t t;
    struct tm *tp;
    char *p;

    if (g_nLog == 0)
        return;

    va_start(marker, fmt);
    vsprintf(buf, fmt, marker);
    va_end(marker);
    p = strtok(buf, "\r\n");

    time(&t);
    tp = localtime(&t);
    if (tp != NULL) {
        sprintf(fname, "log/out%02d%02d.log", tp->tm_mon+1, tp->tm_mday);
        fp = fopen(fname, "at");
        if (fp != NULL) {
            fprintf(fp, "%02d:%02d:%02d [%d] %s\n",
                         tp->tm_hour, tp->tm_min, tp->tm_sec,
                         getpid(), p);
            fclose(fp);
        }
    }
    return;
}

int main(int argc, char *argv[])
{
    static char     optstring[] = "c:";
    int             optch;
    char            *p;
    char            buf[1024];
    char            fname[1024];
    char            cmd[1024];
    int sock, sockl;
    struct sockaddr_in sa;
    int pid;
    int fd;
    char prog[40];
    int sec, cup, sno, seq;
    FILE    *fp;
    int     handle;
    char    xuf[512];
    int n;

    openlog("labout", LOG_PID|LOG_NDELAY, LOG_DAEMON);
    strcpy(cfgfile, DEFAULT_CFGFILE);
    while (1) {
        optch = getopt(argc, argv, optstring);
        if (optch == -1) break;
        switch (optch) {
            case 'c':
                strcpy(cfgfile, optarg);
                break;

            default:
                syslog(LOG_NOTICE, "Unknown option!");
                exit(1);
        }
    }

    load_config_file(cfgfile, 0);
    signal(SIGHUP, reload_conf);

    pid = fork();
    if (pid < 0) {
        syslog(LOG_NOTICE, "Fork failed: %m");
        exit(1);
    }
    if (pid != 0) {     /* exit for parent */
        printf("labout running in daemon mode:\n");
        printf(" pid = %d\n", pid);
        if (g_pRootDir != NULL)
            printf(" directory = %s\n", g_pRootDir);
        printf(" userid = %d\n", g_nRunUserID);
        printf(" groupid = %d\n", g_nRunGroupID);
        printf(" log = %d\n", g_nLog);
        exit(0);
    }

    signal(SIGINT, SIG_IGN);
    signal(SIGQUIT, SIG_IGN);

    if (freopen("/dev/null", "r", stdin) == NULL) {
        syslog(LOG_NOTICE, "Can't freopen.");
        exit(1);
    }
    fd = open("/dev/null", O_WRONLY, 0666);
    if (fd == -1) {
        syslog(LOG_NOTICE, "Can't open /dev/null.");
        exit(1);
    }
    fflush(stdout);
    dup2(fd, STDOUT_FILENO);
    dup2(fd, STDERR_FILENO);
    close(fd);
    setsid();
    umask(0);

    sa.sin_family = AF_INET;
    bzero((char *)&sa.sin_addr, sizeof(sa.sin_addr));
    sa.sin_port = htons(g_nPort);
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        syslog(LOG_NOTICE, "Failed to create socket: %m");
        exit(1);
    }
    if (bind(sock, (struct sockaddr *)&sa, sizeof(sa))) {
        syslog(LOG_NOTICE, "Failed to bind port %d: %m", g_nPort);
        exit(1);
    }
    if (listen(sock, 5) < 0) {
        syslog(LOG_NOTICE, "Failed to listen: %m");
        exit(1);
    }
    while (1) {
        int cstat;

        signal(SIGCHLD, waitwaitwait);
        sockl = accept(sock, NULL, NULL);
        if (sockl < 0) {
            if (errno == EINTR)
                continue;
            syslog(LOG_NOTICE, "Accept failed: %m");
            exit(1);
        }

        pid = fork();
        if (pid < 0) {
            syslog(LOG_NOTICE, "Fork failed: %m");
            exit(1);
        }
        if (pid == 0)
            break;  /* We are the child */
        close(sockl);
    }
    setsid();
    close(sock);

    if (g_pRootDir != NULL) {
        chdir("/");
        if ((chdir(g_pRootDir) || chroot(g_pRootDir))) {
            syslog(LOG_NOTICE, "Cannot chroot to %.512s: %m", g_pRootDir);
            exit(1);
        }
        chdir("/");
    }

    if (g_nRunGroupID != -1 && setgid(g_nRunGroupID)) {
        syslog(LOG_NOTICE, "Cannot set gid to %d: %m", g_nRunGroupID);
        exit(1);
    }

    if (g_nRunUserID != -1 && setuid(g_nRunUserID)) {
        syslog(LOG_NOTICE, "Cannot set uid to %d: %m", g_nRunUserID);
        exit(1);
    }

    putline(sockl, "OK\r\n");

    buf[0] = '\0';
    if ((n = getline(sockl, buf, 1024)) < 0) {
        putline(sockl, "ERR, getline\r\n");
        close(sockl);
        writelog("getline error!");
        return 1;
    }

    writelog("cmd (%d): %s", n, buf);

    p = strtok(buf, ",\r\n");
    if (p == NULL) {
        putline(sockl, "ERR, need LAB\r\n");
        close(sockl);
        writelog("need LAB");
        return 1;
    }

    if (strcmp(p, "LAB") != 0) {
        putline(sockl, "ERR, not LAB\r\n");
        close(sockl);
        writelog("not LAB");
        return 1;
    }

    p = strtok(NULL, ",\r\n");
    if (p == NULL) {
        putline(sockl, "ERR, need program\r\n");
        close(sockl);
        writelog("need program");
        return 1;
    }
    strcpy(prog, p);

    p = strtok(NULL, ",\r\n");
    if (p == NULL) {
        putline(sockl, "ERR, need sector\r\n");
        close(sockl);
        writelog("need sector");
        return 1;
    }
    sec = atoi(p);

    p = strtok(NULL, ",\r\n");
    if (p == NULL) {
        putline(sockl, "ERR, need cup\r\n");
        close(sockl);
        writelog("need cup");
        return 1;
    }
    cup = atoi(p);

    p = strtok(NULL, ",\r\n");
    if (p == NULL) {
        putline(sockl, "ERR, need seq\r\n");
        close(sockl);
        writelog("need cup");
        return 1;
    }
    seq = atoi(p);

    if (seq == 1) {
        sprintf(xuf, "%s/outbox/tmpXXXXXX", prog);
        handle = mkstemp(xuf);
        if (handle < 0) {
            putline(sockl, "ERR, can't open tmp file\r\n");
            close(sockl);
            writelog("can't open tmp file %s", xuf);
            return 1;
        }
        chmod(xuf, 0600);
        fp = fdopen(handle, "wb");
        if (fp == NULL) {
            close(handle);
            putline(sockl, "ERR, can't fdopen tmp file\r\n");
            close(sockl);
            writelog("can't fdopen tmp file %s", xuf);
            return 1;
        }
        lockf(handle, F_LOCK, 0);
        strcpy(fname, xuf);
    }
    else if (seq == 0) {
        sprintf(fname, "%s/outbox/%04d-%04d.001", prog, sec, cup);
        fp = fopen(fname, "ab");
        if (fp == NULL) {
            putline(sockl, "ERR, can't fopen file\r\n");
            close(sockl);
            writelog("can't fopen file %s", fname);
            return 1;
        }
        lockf(fileno(fp), F_LOCK, 0);
    }
    else {
        p = strtok(NULL, ",\r\n");
        if (p == NULL) {
            putline(sockl, "ERR, need no\r\n");
            close(sockl);
            writelog("need no");
            return 1;
        }
        sprintf(fname, "%s/outbox/%s", prog, p);
        fp = fopen(fname, "ab");
        if (fp == NULL) {
            sprintf(buf, "ERR, can't fopen file %s\r\n", fname);
            putline(sockl, buf);
            writelog("can't fopen file %s", fname);
            close(sockl);
            return 1;
        }
        lockf(fileno(fp), F_LOCK, 0);
    }
    putline(sockl, "OK\r\n");

    while (1) {
        if (getline(sockl, buf, 1024) < 0) {
            fclose(fp);
            if (seq)
                unlink(fname);
            putline(sockl, "ERR\r\n");
            close(sockl);
            return 1;
        }
        p = strtok(buf, ",\r\n");
        if (p == NULL) {
            putline(sockl, "ERR\r\n");
            continue;
        }
        if (strcmp(p, "END") == 0) break;
        if (strcmp(p, "DATA") != 0) continue;
        p = strtok(NULL, "\r\n");
        if (p == NULL)
            fprintf(fp, "\n");
        else
            fprintf(fp, "%s\n", p);
        putline(sockl, "OK\r\n");
    }

    lockf(fileno(fp), F_ULOCK, 0);
    fclose(fp);
    putline(sockl, "OK\r\n");
    close(sockl);
    writelog("done");

    if (seq == 1) {
        sno = 1;
        while (1) {
            sprintf(buf, "%s/outbox/%04d-%04d.%03d", prog, sec, cup, sno);
            if (access(buf, 0) == -1) {
                if (rename(fname, buf) == 0) break;
            }
            sno++;
        }
        chmod(buf, 0777);
    }
    else
        chmod(fname, 0777);

    return 0;
}
