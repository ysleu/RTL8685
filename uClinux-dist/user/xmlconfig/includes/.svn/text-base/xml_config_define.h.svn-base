#include <stdio.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>
//#include <errno.h>

//FIXME TYPE:     WDS_ARRAY_T
//FIXED: IA_T IA6_T BYTE5_T BYTE6_T BYTE13_T BYTE_ARRAY_T

#define IPADDR_EMPTY 0xffffffff
#define IP6ADDR_EMPTY 0x0

#define XML_ENTRY( \
	dn, \
	n, \
	d, \
	xml_set, \
	xml_mcp_set, \
	xml_get, \
	xml_mcp_get, \
	init_idx, \
	Id	\
	)\
	extern dir_t d##_dir; \
	entry_t d##_##n##_ent \
	= { \
		.name=#n, \
		.matchname=dn, \
		.dir=&d##_dir, \
		.set=xml_set, \
		.mcp_set=xml_mcp_set, \
		.get=xml_get, \
		.mcp_get=xml_mcp_get, \
		.init_index=init_idx,  \
		.id=Id\
	},  *d##_##n##_ent_p \
	__attribute__((aligned(4), unused, __section__(".entry_list")))	\
	=&d##_##n##_ent

#define XML_ENTRY_STRING( \
	dn,\
    n, \
    d, \
    maxlen, \
    position,  \
    Id	\
    )\
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
        strncpy((char *)(position), src, maxlen); return XML_OK; }\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
       (*bc)+=sprintf(buf, "%s", (position)); return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_set, d##_##n##_xml_get, d##_##n##_xml_get, NULL, Id)

#define XML_ENTRY_STRING2(dn, n, d, position, Id) XML_ENTRY_STRING(dn, n, d, sizeof(position)-1, position, Id)

#define XML_ENTRY_PRIMITIVE( \
	dn,\
    n, \
    d, \
    pt, \
	gt, \
    position,  \
    Id	\
    ) \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
		sscanf(src, gt, &(position)); return XML_OK; }\
    XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
        memcpy(&(position), src, sizeof((position))); return XML_OK; }\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	(*bc)+=sprintf(buf, pt, (position));\
		return XML_OK;}\
    XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
    	memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position);\
		return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_PRIMITIVE2(dn, n, d, ty, pos, Id) 	XML_ENTRY_PRIMITIVE(dn, n, d, ty, ty, pos, Id)

#define XML_ENTRY_PRIMITIVE_ARRAY( \
	dn,\
    n, \
    d, \
	gt, \
    pt, \
    position, \
    idx, \
    idx_max, \
    Id	\
    ) \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
        if ((idx)>=(idx_max)) return XML_OUT_OF_RANGE;\
        sscanf(src, gt, (position)+((idx)++)); return XML_OK; }\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	*bc+=sprintf(buf, pt, (position[(idx)++]));\
        return ((idx)>=(idx_max))? XML_REACH_MAX : XML_OK ;}\
    void d##_##n##_xml_idx_init(void) {(idx)=0;} \
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_set, d##_##n##_xml_get, d##_##n##_xml_get, d##_##n##_xml_idx_init, Id)

#define XML_ENTRY_PRIMITIVE_ARRAY2(dn,n,d,gt,position,idx,idx_max,Id) \
    XML_ENTRY_PRIMITIVE_ARRAY(dn,n,d,gt,gt,position,idx,idx_max,Id)

#define XML_ENTRY_ADDR(	\
    dn, \
    n, \
    d, \
    position, \
    Id	\
    )	\
	XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
		if(strchr(src, '.')!=NULL) {\
	        unsigned long addr = inet_addr(src);\
			memcpy((position), &addr, 4);}\
		if(0 == src[0]){\
			memset((position), IPADDR_EMPTY, sizeof(position));}\
        return XML_OK;} \
	XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
			memcpy((position), src, sizeof((position))); \
			return XML_OK;} \
	XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
			if(((struct in_addr *)(position))->s_addr != INADDR_NONE)\
            *bc+=sprintf(buf, "%s", inet_ntoa(*((struct in_addr *)(position))));\
	    return XML_OK; }\
	XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position);\
		return XML_OK;}\
	XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_ADDR6(	\
	dn, \
	n, \
    d, \
    position, \
    Id  \
    )   \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
    	if(strchr(src, ':')!=NULL) inet_pton(PF_INET6, src, (position));\
        else memcpy((position), src, sizeof((position))); \
		if(0 == src[0]){\
			memset((position), IP6ADDR_EMPTY, sizeof(position));}\
        return XML_OK;} \
    XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
		memcpy((position), src, sizeof((position))); \
		return XML_OK;} \
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
		if (!memcmp(((struct in6_addr *)(&(position)))->s6_addr, in6addr_any.s6_addr,16)){\
	        *bc+=sprintf(buf, "");	return XML_OK; }\
		char addr[INET6_ADDRSTRLEN];\
        if(inet_ntop(PF_INET6, (void *)(position), addr, INET6_ADDRSTRLEN)==NULL){\
            printf("Error\n"); return XML_FAIL;}\
        *bc+=sprintf(buf, "%s", addr);\
        return XML_OK; }\
    XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position);\
		return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)


#define XML_ENTRY_BYTE5(	\
    dn, \
    n, \
    d, \
    position, \
    Id  \
    )   \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
	    sscanf(src, "%02hhx%02hhx%02hhx%02hhx%02hhx", &(position)[0], &(position)[1], &(position)[2],&(position)[3], &(position)[4]);\
		return XML_OK; }\
    XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
        memcpy((position), src, sizeof((position))); return XML_OK;}\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	(*bc)+=sprintf(buf, "%02x%02x%02x%02x%02x", (position)[0],\
    	(position)[1], (position)[2], (position)[3], (position)[4]); return XML_OK;}\
   	XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))*2); (*bc)+=sizeof(position); return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_BYTE6(	\
    dn, \
    n, \
    d, \
    position, \
    Id  \
    )   \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
        sscanf(src, "%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx", &(position)[0],\
			&(position)[1], &(position)[2],&(position)[3], &(position)[4], &(position)[5]);\
		return XML_OK; }\
    XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
        memcpy((position), src, sizeof((position))); return XML_OK;}\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	(*bc)+=sprintf(buf, "%02x%02x%02x%02x%02x%02x", (position)[0],\
    	(position)[1], (position)[2], (position)[3], (position)[4], (position)[5]);\
  	return XML_OK;}\
  	XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position); return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_BYTE13(	\
    dn, \
    n, \
    d, \
    position, \
    Id  \
    )   \
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
	sscanf(src, "%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx", \
		&(position)[0], &(position)[1], &(position)[2],&(position)[3], &(position)[4],\
		&(position)[5], &(position)[6], &(position)[7],&(position)[8], &(position)[9],\
		&(position)[10], &(position)[11], &(position)[12]);\
		return XML_OK; }\
    XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
        memcpy((position), src, sizeof((position))); return XML_OK;}\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	(*bc)+=sprintf(buf, "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",\
    	(position)[0], (position)[1], (position)[2], (position)[3], (position)[4],\
		(position)[5], (position)[6], (position)[7], (position)[8], (position)[9],\
    	(position)[10],(position)[11],(position)[12]); 	return XML_OK;}\
    XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position); return XML_OK;}\
	XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_TYPE_ARRAY(\
    dn,\
    n,\
    d,\
    gt,\
    position, \
    Id\
    )\
    XML_OPR_t d##_##n##_xml_set(entry_t *self, const char *src) {\
	    return string_to_hex(position, src); }\
	XML_OPR_t d##_##n##_xml_mcp_set(entry_t *self, const char *src) {\
		memcpy((position), src, sizeof((position))); return XML_OK;}\
    XML_OPR_t d##_##n##_xml_get(entry_t *self, char *buf, unsigned int *bc) {\
    	int i=0, size=0;\
		for(i=0;i<sizeof((position));i++){\
			if(i!=0) size+=sprintf(buf+size, ",", (position)[i]);\
    	size+=sprintf(buf+size, gt, (position)[i]);}\
    	(*bc)+=size;\
		return XML_OK;}\
	XML_OPR_t d##_##n##_xml_mcp_get(entry_t *self, char *buf, unsigned int *bc) {\
		memcpy(buf, &(position), sizeof((position))); (*bc)+=sizeof(position); return XML_OK;}\
    XML_ENTRY(dn, n, d, d##_##n##_xml_set, d##_##n##_xml_mcp_set, d##_##n##_xml_get, d##_##n##_xml_mcp_get, NULL, Id)

#define XML_ENTRY_BYTE_ARRAY(dn,n,d,position,Id)	\
    XML_ENTRY_TYPE_ARRAY(dn,n,d,"%02x",position,Id)

#define XML_ENTRY_INT_ARRAY(dn,n,d,position,Id)	\
    XML_ENTRY_TYPE_ARRAY(dn,n,d,"%d",position,Id)

#define XML_DIR( \
    dn, \
	n, \
	p, \
	idx, \
	max, \
	Id	\
	) \
	extern dir_t p##_dir; \
	dir_t n##_dir \
	= { \
		.name=#n, \
		.matchname=dn, \
		.parent=&p##_dir, \
		.index=idx, \
		.index_max=max, \
		.id=Id \
    	},	\
	*n##_dir_p	\
	__attribute__((aligned(4), unused, __section__(".dir_list")))	\
	= &n##_dir


#define XML_DIR_SINGLE(dn, n, p, Id) XML_DIR(dn, n, p, NULL, 1, Id)

#define XML_DIR_ARRAY(dn, n, p, idx, max, Id)  XML_DIR(dn, n, p, &idx, max, Id)


