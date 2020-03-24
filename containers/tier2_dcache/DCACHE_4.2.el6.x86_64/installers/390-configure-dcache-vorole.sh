#---------------------------------
# Installation
#---------------------------------
yum --nogpgcheck -y install edg-mkgridmap
cp -v dcache_template/dcacheVoms2Gplasma.conf.template /etc/dcache/dcacheVoms2Gplasma.conf


#---------------------------------
# Generate maps
#---------------------------------
## create grid-mapfile
/usr/sbin/edg-mkgridmap --output=/etc/grid-security/grid-mapfile --safe

## create authzdb and vorolemap
/usr/sbin/dcacheVoms2Gplasma.py -r -a -c /etc/dcache/dcacheVoms2Gplasma.conf -q


#---------------------------------
# Cron
#---------------------------------
## cron grid-mapfile
echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin
54 0,6,12,18 * * * root (date; /usr/sbin/edg-mkgridmap --output=/etc/grid-security/grid-mapfile --safe) >> /var/log/edg-mkgridmap.cron.log 2>&1" > /etc/cron.d/edg-mkgridmap.cron

## cron gplasma
echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin
16 5,11,17,23 * * * root /usr/sbin/dcacheVoms2Gplasma.py -r -a -c /etc/dcache/dcacheVoms2Gplasma.conf -q >> /var/log/dcacheVoms2GPlasma.cron.log 2>&1" > /etc/cron.d/dcacheVoms2Gplasma.cron

