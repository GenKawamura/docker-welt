#----------------------------------------------------------------------------------
#
# Ref: http://www.dcache.org/manuals/Book-2.2/start/intouch-client-fhs.shtml
#
# @author Gen Kawamura
# @date   05.04.2014
#----------------------------------------------------------------------------------

[ "$DCACHE_MODE" == "pool" ] && exit 0

POSTGRES_VER=9.4

echo "making configurations for postgresql"
/etc/init.d/postgresql-${POSTGRES_VER} stop
/etc/init.d/postgresql-${POSTGRES_VER} initdb


## dCache postgres configuration (keyword = "dCache")
cp -v postgresql-${POSTGRES_VER}/pg_hba.conf /var/lib/pgsql/${POSTGRES_VER}/data/pg_hba.conf


## postgres tuning
python postgresql-${POSTGRES_VER}/pgtune.py > /var/lib/pgsql/${POSTGRES_VER}/data/postgresql.conf

## Set huge shared memory for postgres service during installation
sysctl -w kernel.shmmax=68719476736

## postgresql start
/etc/init.d/postgresql-${POSTGRES_VER} restart
sleep 10

## create dcache database
su - postgres -c "createuser -U postgres --no-superuser --no-createrole --createdb chimera"
su - postgres -c "createuser -U postgres --no-superuser --no-createrole --createdb dcache"
su - postgres -c "createdb -U postgres chimera"
su - postgres -c "createdb -U dcache dcache"
su - postgres -c "createdb -O dcache -U postgres billing"
su - postgres -c "createdb -O dcache -U postgres pinmanager"
su - postgres -c "createdb -O dcache -U postgres spacemanager"


## Generate PostgreSQL tables
dcache database update

# auto startup
chkconfig postgresql-${POSTGRES_VER} on
