#ifndef __srslte_execinfo_h_
#define __srslte_execinfo_h_

#include <stdlib.h>
#include <string.h>
#define backtrace(array, size)   1
static char **backtrace_symbols(void **X, int SIZE) {
    char data[] = "[WARNING] Android backtrace is not supported";
    char *datamem = (char *)malloc(strlen(data)+16);
    char **ret = (char **)datamem;
    ret[0] = datamem + (int)sizeof(char *);
    strcpy(ret[0], data);
    return ret;
}

#endif //__srslte_execinfo_h_



