[ "$DCACHE_UPGRADE" == "" ] && exit 0


read_siteinfo_def +x

## HEAD or POOL
[ "$DCACHE_ADMIN" != "$(hostname -f)" ] && exit 0


## Removing old package
yum -y remove dcache

## Downloading v3.2 package
RPM0=http://quattor.web.lal.in2p3.fr/packages/umd/4.0/el7/x86_64/updates/dcache-3.2.21-1.noarch.rpm
wget $RPM0 -O /root/$(basename $RPM0)

RPM1=https://www.dcache.org/downloads/1.9/repo/4.2/dcache-4.2.51-1.noarch.rpm
wget $RPM1 -O /root/$(basename $RPM1)


## Install v3.2 and alter role before updating the database schema
yum -y install /root/$(basename $RPM0)
echo "alter user dcache with Superuser;" | psql -U postgres
dcache database update


## Install v4.2 and updating ddache schema
yum -y remove dcache
yum -y install /root/$(basename $RPM1)
dcache database update



echo "alter user dcache with Nosuperuser;" | psql -U postgres


