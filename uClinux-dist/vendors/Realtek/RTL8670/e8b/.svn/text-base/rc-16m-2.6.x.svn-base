mount -t proc proc /proc
mount -t ramfs ramfs  /var
mkdir /var/tmp
mkdir /var/log
touch /var/log/bftpd.log
mkdir /var/run
mkdir /var/run/bftpd
ln -s /var/run/bftpd /var/wget_path
mkdir /var/lock
mkdir /var/ppp
mkdir /var/config
mkdir /var/udhcpd
mkdir /var/udhcpc
mkdir /var/mnt
mkdir /var/ct
mkdir /var/ct/tmp

mount -t jffs2 /dev/mtdblock7 /usr/local/ct

ifconfig lo 127.0.0.1
route add -net 127.0.0.0 netmask 255.255.255.0 lo

PATH=.:$PATH
cd /etc/scripts
# init.sh
/bin/watchdog timeout 60
/bin/watchdog start 2 &
configd&
startup&

