#----------------------------------------------------------------------------------
#
# Ref: http://www.dcache.org/manuals/Book-1.9.12/start/in-install.shtml
#
# @author Gen Kawamura
# @date   06.05.2014
#----------------------------------------------------------------------------------

read_siteinfo_def +x

## HEAD or POOL
[ "$DCACHE_ADMIN" == "$(hostname -f)" ] && exit 0


#-----------------------------------
# configuratoin of dCache user
#-----------------------------------
uid=50520
gid=50520

groupadd dcache -g $gid
useradd dcache -u $uid -G dcache

useradd edginfo


## configure dcache.conf
cp -v dcache_template/dcache.conf.template /etc/dcache/dcache.conf
sed -e "s/^broker.host=.*/broker.host=$DCACHE_ADMIN/" -i /etc/dcache/dcache.conf


## configure layout file
cp -v dcache_template/pool_layout.conf /etc/dcache/layouts/$(hostname -s).conf
ln -s /etc/dcache/layouts/$(hostname -s).conf /etc/dcache/layouts/localhost.conf


## configure pools
for dpool in $DCACHE_POOLS
do
    pool_node=$(echo $dpool | cut -f 1 -d :)
    pool_size=$(echo $dpool | cut -f 2 -d :)
    pool_dir=$(echo $dpool | cut -f 3 -d :)
    pool_domain="${gnode_lname}Domain"
    pool_name="${pool_node}_`echo $pool_dir | perl -pe 's/\//_/g'`"
    
    if [ "$gnode_hostname" == "$pool_node" ]; then
	/usr/bin/dcache pool create --lfs=precious --size=${pool_size}000000000 $pool_dir/${pool_name} $pool_name $pool_domain 
    fi
done


## configure /pnfs mount point
mkdir -v /pnfs

## dcache init script
chkconfig dcache-server on

