/* Use new style mmap for mips */
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/syscall.h>

_syscall4 (int, sysmips, int, cmd, int, arg1, int, arg2, int, arg3);
