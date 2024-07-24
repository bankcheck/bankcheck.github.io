#include <stdio.h>
#include <string.h>
#include "labsrv.h"

int PutLine(int no, char *buf)
{
    int n;
    BOOL b;

_TRY_EXCEPTION_BLOCK_BEGIN()

    if (g_Client == NULL) return 0;
    b = g_Client[no].bCheck;
    g_Client[no].bCheck = FALSE;
    g_Client[no].tick = GetTickCount();
    g_Client[no].bCheck = b;
    if (g_Client[no].s == SOCKET_ERROR) return 0;
    n = send(g_Client[no].s, buf, strlen(buf), 0);
    if (n == 0 || n == SOCKET_ERROR)
        return 0;

_TRY_EXCEPTION_BLOCK_END(1)

    return n;
}

int GetLine(int no, char *buf, int bufsize)
{
    int n;
    char ch;
    int i;
    BOOL b;

_TRY_EXCEPTION_BLOCK_BEGIN()

    if (g_Client == NULL) return 0;
    if (g_Client[no].s == SOCKET_ERROR) return 0;
    i = 0;
    buf[0] = '\0';
    while (1) {
        b = g_Client[no].bCheck;
        g_Client[no].bCheck = FALSE;
        g_Client[no].tick = GetTickCount();
        g_Client[no].bCheck = b;
        n = recv(g_Client[no].s, &ch, 1, 0);
        if (n == 0 || n == SOCKET_ERROR)
	    return 0;
	buf[i++] = ch;
	if (ch == '\n' && buf[i-2] == '\r') {
	    buf[i-2] = '\0';
            break;
	}
	if (i >= bufsize) {
	    buf[i] = '\0';
            break;
	}
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return i;
}

int AddBslash(char *s)
{
    int len;

_TRY_EXCEPTION_BLOCK_BEGIN()

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}

int GetResult(char *s)
{
    char buf[260];
    char *p;
    int result;

_TRY_EXCEPTION_BLOCK_BEGIN()

    result = -1;
    p = &buf[0];
    while (*s >= '0' && *s <= '9')
        *p++ = *s++;
    *p ='\0';
    if (p == buf) return result;
    result = atoi(buf);

_TRY_EXCEPTION_BLOCK_END(1)

    return result;
}

