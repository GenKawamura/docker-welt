#----------------------------------------------------------------------------------
#
# Ref: http://www.dcache.org/manuals/Book-2.2/start/intouch-client-fhs.shtml
#
# @author Gen Kawamura
# @date   05.04.2014
#----------------------------------------------------------------------------------

[ "$DCACHE_MODE" == "pool" ] && exit 0

#-----------------------------------
# configuratoin of dCache user
#-----------------------------------
uid=50520
gid=50520

groupadd dcache -g $gid
useradd dcache -u $uid -g $gid

useradd edginfo


## configure dcache.conf
cp -v dcache_template/dcache.conf.template /etc/dcache/dcache.conf


## configure layout file
cp -v dcache_template/head_layout.conf /etc/dcache/layouts/head_layout.conf

## configuration for info provider
grep Info-Provider /etc/dcache/dcache.conf || echo "
# For new Info-Provider
info-provider.site-unique-id=$SITE_NAME
info-provider.se-unique-id=$(hostname -f)
info-provider.se-name=dcache@$(hostname -f)" >> /etc/dcache/dcache.conf
ln -s /usr/sbin/dcache-info-provider /var/lib/bdii/gip/provider/dcache-info-provider


## configuration for pool manager
cp -v dcache_template/poolmanager.conf /var/lib/dcache/config/poolmanager.conf


## configuration for VO group
cp -v dcache_template/LinkGroupAuthorization.conf.template /etc/dcache/LinkGroupAuthorization.conf


## configure /pnfs mount point
mkdir -v /pnfs

# auto startup
chkconfig dcache-server on
chkconfig bdii on
