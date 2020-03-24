read_siteinfo_def +x

## HEAD or POOL
[ "$DCACHE_ADMIN" != "$(hostname -f)" ] && exit 0

DSA_KEY=$(cat /root/.ssh/id_dsa.pub  | sed "s/\(.*\)/\1 admin@localhost/")
echo "$DSA_KEY" > /etc/dcache/admin/authorized_keys2

