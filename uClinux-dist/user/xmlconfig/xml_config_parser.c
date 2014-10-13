#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

#include "xml_config.h"
#include "xml_config_gramma.h"

static inline ssize_t
get_file_length(int fd) {
    struct stat fdstat;
    fstat(fd, &fdstat);
    ssize_t flen=fdstat.st_size;
    return flen;
}
extern char current_filename[MAX_NAME_STRING];
extern unsigned int linenum;
int
config_parser(const char *filename) {
    int fd, count=0;
    ssize_t sz=0;
    if(filename!=NULL) {
	    if ((fd=open(filename, O_RDONLY))<0) {
	        return -1;
	    }
	    strcpy(current_filename, filename);
        sz=get_file_length(fd);
        g_config=(char*)malloc(sz+3);
        if (read(fd, g_config, sz)!=sz) {
            printf("read file failed.\n");
            close(fd);
            return -1;
        }
        close(fd);
        g_config[sz]='\0';
    } else {
		fd = fileno(stdin);
        sz = 2048;
        g_config=(char*)malloc(sz+3);
        if ((count=read(fd, g_config, sz))<=0) {
            printf("read stdin failed.\n");
            return -1;
        }
        g_config[count]='\0';
    }

    stoken_init();
	Index_cnt_init();

    if(g_program()!=CFG_OK){
        fprintf(stderr, "Error occurs in %s:%d\n",
            current_filename, linenum);
		return CFG_SYNTAX_ERROR;
    }
    return 0;
}


#define ascii_hex(a) ((((a)>='0')&&((a)<='9'))?((a)-'0'):(((a)>='a')&&((a)<='f'))?((a)-'a'+10):(((a)>='A')&&((a)<='F'))?((a)-'A'+10):0)

XML_OPR_t string_to_hex(unsigned char *dst, const char *src) {
    while (*src!='\0') {
        unsigned char b0=*(src++);
        if (*src=='\0') return XML_FAIL;
        unsigned char b1=*(src++);
        unsigned char d0=ascii_hex(b0);
        unsigned char d1=ascii_hex(b1);
        *(dst++) = (d0<<4)+d1;
// 		XML_DBG("%02x ", dst[-1]);
        if (*src==',') ++src;
    }
    return XML_OK;
}


#if 0
int
config_parser_init(void) {
    gramma_init();
    return 0;
}

extern dir_t root_dir;


int
config_entry_paramter(const char *dir, const char *ent, const char *value){
	return 0;
}
#endif
