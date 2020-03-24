[ "$DCACHE_MODE" == "pool" ] && exit 0

## install new postgres
cp -v postgresql-9.4/pgdg-94-sl.repo /etc/yum.repos.d/
yum clean all

