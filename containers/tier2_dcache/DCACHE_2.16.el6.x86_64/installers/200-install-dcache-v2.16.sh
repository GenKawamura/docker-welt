#---------------------------------------------------------------
# Ref: 
# 
#---------------------------------------------------------------

read_siteinfo_def +x

## HEAD or POOL
DCACHE_MODE=POOL
[ "$DCACHE_ADMIN" == "$(hostname -f)" ] && DCACHE_MODE=HEAD


#-----------------------------------
# configuratoin of postgres server
#-----------------------------------
## install required packages
yum -y install java-1.8.0-openjdk-devel ruby

## download v2.16
RPM=https://www.dcache.org/downloads/1.9/repo/2.16/dcache-2.16.50-1.noarch.rpm
wget -q $RPM -O /root/$(basename $RPM)

## Install dcache
case "$DCACHE_MODE" in
    POOL)
        ## install dcache package
	yum --nogpgcheck -y install /root/$(basename $RPM)
        ;;
    HEAD)
        ## install postgres
	yum -y --nogpgcheck install postgresql94-server postgresql94

        ## install dcache package
	yum --nogpgcheck -y install /root/$(basename $RPM)
	yum --nogpgcheck -y install bdii glue-schema

        ## install client package
	yum --nogpgcheck -y install dcache-srmclient dcap dcap-tunnel-gsi

        ;;
esac
