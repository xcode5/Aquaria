#if defined(_MSC_VER) && !defined(_CRT_SECURE_NO_WARNINGS)
#    define _CRT_SECURE_NO_WARNINGS
#endif

#include "VFSDefines.h"

// this is for POSIX - define before including any stdio headers
#ifdef VFS_LARGEFILE_SUPPORT
#    ifndef _MSC_VER
#        define _FILE_OFFSET_BITS 64
#    endif
#endif

#include "VFSFileFuncs.h"
#include "VFSInternal.h"

#include <cstdio>

// Compile time assertion to make sure things work as expected
#if defined(VFS_LARGEFILE_SUPPORT) && !defined(_MSC_VER)
static void _dummy_() { switch(0) { case 4: case sizeof(off_t): ; } }
#endif

VFS_NAMESPACE_START

void *real_fopen(const char *name, const char *mode)
{
    return fopen(name, mode);
}

int real_fclose(void *fh)
{
    return fclose((FILE*)fh);
}

int real_fseek(void *fh, vfspos offset, int origin)
{
#ifdef VFS_LARGEFILE_SUPPORT
#  ifdef _MSC_VER
    return _fseeki64((FILE*)fh, offset, origin);
#  else
    return fseeko((FILE*)fh, offset, origin);
#  endif
#else
    return fseek((FILE*)fh, offset, origin);
#endif
}

vfspos real_ftell(void *fh)
{
#ifdef VFS_LARGEFILE_SUPPORT
#  ifdef _MSC_VER
    return _ftelli64((FILE*)fh);
#  else
    return ftello((FILE*)fh);
#  endif
#else
    return ftell((FILE*)fh);
#endif
}

size_t real_fread(void *ptr, size_t size, size_t count, void *fh)
{
    return fread(ptr, size, count, (FILE*)fh);
}

size_t real_fwrite(const void *ptr, size_t size, size_t count, void *fh)
{
    return fwrite(ptr, size, count, (FILE*)fh);
}

int real_feof(void *fh)
{
    return feof((FILE*)fh);
}

int real_fflush(void *fh)
{
    return fflush((FILE*)fh);
}


VFS_NAMESPACE_END
