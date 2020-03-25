[ "$DCACHE_MODE" == "pool" ] && exit 0

## Configure
rpm -q nfs-utils-lib || yum -y --nogpgcheck install nfs-utils-lib
cp -v dcache_template/idmapd.conf.template /etc/idmapd.conf

grep "^/pnfs " /etc/exports || echo "/pnfs 127.0.0.1(rw,root_squash)" >> /etc/exports
[ $? -eq 0 ] && exportfs -ar 

chkconfig rpcidmapd on
#service rpcidmapd restart
