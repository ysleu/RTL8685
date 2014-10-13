/* 
USB Mount Handler
andrew 2008/02/21

handles linux 2.6 hotplug event
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <config/autoconf.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <signal.h>
#ifndef CONFIG_ARCH_LUNA_SLAVE
#include <rtk/options.h>
#endif
#include <libgen.h>
#include <assert.h>
#include <err.h>

/*
Environment Variables:
DEVPATH
ACTION
*/

#define MNT_ROOT "/mnt"
#define BUFFER_SIZE 32
/* #define USBMOUNT_DEBUG */
#define PROC_MOUNTS "/proc/mounts"

struct action_table {
	char *action_str;
	int	(*action_func)(int, char **, char *);
};


static int scan_target_ismounted(char * target_path)
{
	char scan_target_buf[20];
	char proc_mount_buf[500];

	FILE *file;

	file = fopen(PROC_MOUNTS,"r");
	if (!file)
		return 0;

	fread(proc_mount_buf,sizeof(proc_mount_buf), 1, file);
	fclose(file);

	if (target_path) {
		warn(">>>>>>>> start to check %s ismounted\n", target_path);
		sprintf(scan_target_buf,"%s ",target_path);
		if(strstr(proc_mount_buf,scan_target_buf)) {
			warn(" %s ismounted\n", target_path);
			return 1;
		}
	}
	warn(" %s is not mounted!\n", target_path);
	return 0;
}

static int gen_source_target(char *source_buffer, char *target_buffer, char *bname)
{
#ifdef CONFIG_E8B
	unsigned int i, j;
#endif

	if (strlen(bname) < 3) {
		return 1;
	}

	snprintf(source_buffer, BUFFER_SIZE, "/dev/%s", bname);

#ifdef CONFIG_E8B
	/* takes sdb1 as a example */

	/* i = 'b' - 'a' + 1, so that i == 2*/
	i = bname[2] - 'a' + 1;

	/* j = '1' - '0', so that j == 1*/
	j = strtoul(bname + 3, NULL, 10);

	/* for name without partition number such as "sdb".
       There is only 1 partition in this case */
	if(j == 0)
		j = 1;
	snprintf(target_buffer, BUFFER_SIZE, MNT_ROOT"/usb%u_%u", i, j);
#else
	snprintf(target_buffer, BUFFER_SIZE, MNT_ROOT"/%s", bname);
#endif

	return 0;
}

static int action_add(int argc, char **argv, char *devpath) 
{
	int ret, retry_count = 0;
	char source_buffer[BUFFER_SIZE], target_buffer[BUFFER_SIZE];

	if (gen_source_target(source_buffer, target_buffer, basename(devpath))) {
		return 1;
	}

#ifdef USBMOUNT_DEBUG
	warnx("action add: %s", devpath);
#endif

	ret = mkdir(target_buffer, 0755);
	if (ret && errno != EEXIST) {
#ifdef USBMOUNT_DEBUG
		warn("%s:%d", __FUNCTION__, __LINE__);
#endif
		return ret;
	}

retry:

#ifdef CONFIG_USER_NTFS_NTFS3G
	ret = va_cmd("/bin/ntfs-3g", 4, 1, "-o", "noatime", 
			source_buffer, target_buffer);
#else
	ret = 1;
#endif

	if (ret) {
#ifndef CONFIG_ARCH_LUNA_SLAVE
		ret = va_cmd("/bin/mount", 4, 1, "-o", "noatime,utf8", 
				source_buffer, target_buffer);
#else
		char buf[128];
		sprintf(buf, "/bin/mount -o noatime,utf8 %s %s", source_buffer, target_buffer);
		system(buf);
#endif
	}

	if (ret && retry_count++ < 3) {
#ifdef USBMOUNT_DEBUG
		warn("%s:%d ret %d, errno %d", __FUNCTION__, __LINE__, ret, errno);
#endif
		sleep(1 << retry_count);
		goto retry;
	}

	if (ret) {
#ifdef USBMOUNT_DEBUG
		warn("%s:%d", __FUNCTION__, __LINE__);
#endif
		rmdir(target_buffer);
	}

	return ret;
}

static int action_remove(int argc, char **argv, char *devpath) 
{
	int ret, retry_count = 0;;
	char source_buffer[BUFFER_SIZE], target_buffer[BUFFER_SIZE];

	if (gen_source_target(source_buffer, target_buffer, basename(devpath))) {
		return 1;
	}

#ifdef USBMOUNT_DEBUG
	warnx("action remove: %s\n", devpath);
#endif
	if ((ret = access(target_buffer, F_OK)))
		return ret;

	/* use fuser to kill the processes using files or directories in the mount point */

	/* Before using fuser, check if target is mounted, if not ,no need to check */
	/* because in some device, will detected two device /dev/sda and /dev/sda1  */
	/* and this will cause fuser detect some processes is using /dev/sda.		*/	
	if(scan_target_ismounted(target_buffer) == 0)
		return 1;
	
#ifndef CONFIG_ARCH_LUNA_SLAVE
	va_cmd("/bin/fuser", 3, 1, "-m", "-k", target_buffer);
	va_cmd("/bin/fuser", 4, 1, "-m", "-k", "-SIGKILL", target_buffer);
#else
	char buf[128];
	sprintf(buf, "/bin/fuser -m -k %s", target_buffer);
	system(buf);
	memset(buf,0,128);
	sprintf(buf, "/bin/fuser -m -k -SIGKILL %s", target_buffer);
	system(buf);
#endif

retry:

	ret = umount(target_buffer);
	ret |= rmdir(target_buffer);

	if (ret && retry_count++ < 3) {
#ifdef USBMOUNT_DEBUG
		warn("%s:%d ret %d, errno %d", __FUNCTION__, __LINE__, ret, errno);
#endif
		sleep(1 << retry_count);
		goto retry;
	}

	return ret;
}

static const struct action_table hotplug_table[] = {
	{ "add", action_add },
	{ "remove", action_remove },	
	{ NULL, NULL },
};

int main(int argc, char **argv)
{
	char *devpath;
	char *action;
	const struct action_table *p;
#ifdef USBMOUNT_DEBUG
	int fd;

	fd = open("/dev/console", O_WRONLY);
	dup2(fd, STDERR_FILENO);
	close(fd);
#endif

	devpath = getenv("DEVPATH");
	assert(devpath != NULL);
	
	action = getenv("ACTION");
	assert(action != NULL);

	for (p = &hotplug_table[0]; p->action_str; p++) {
		if (strcmp(action, p->action_str) == 0) {
			return p->action_func(argc - 1, &argv[1], devpath);
		}
	}

	return 0;
}

