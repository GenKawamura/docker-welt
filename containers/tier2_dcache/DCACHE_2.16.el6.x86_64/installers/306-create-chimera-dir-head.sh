[ "$DCACHE_MODE" == "pool" ] && exit 0

# chedk dcache_pnfs_vo_dir
[ -z "$DCACHE_PNFS_VO_DIR" ] && exit 0

# function
get_vo_user(){
    RET=""
    query_vo=$1
    grep "^.*:.*:.*:.*:$query_vo:.*$" $USERS_CONF &> /dev/null || return 1

    a_user_in_vo=$(grep "^.*:.*:.*:.*:$query_vo:.*$" $USERS_CONF | head -n 1)
    RET=$(echo $a_user_in_vo | perl -pe "s/^(.*?):.*?:(.*?):.*?:.*?:.*?$/\1 \2/")
    return 0
}


CHIMERA_CLI=chimera


## creation of general dir
$CHIMERA_CLI ls / | grep total
for subdir in $(echo $DCACHE_PNFS_VO_DIR | sed "s/\// /g")
do
    dir=$dir/$subdir
    $CHIMERA_CLI ls $dir | grep total &> /dev/null
    [ $? -eq 0 ] && continue
    $CHIMERA_CLI mkdir $dir
done


## creation of VO dir
for vo in $VOS
do
    ## create dir
    $CHIMERA_CLI ls $dir/$vo | grep total &> /dev/null
    [ $? -ne 0 ] && $CHIMERA_CLI mkdir $dir/$vo

    ## set vo user
    get_vo_user $vo || continue
    vo_user=($RET)

    ## set owner and permission
    $CHIMERA_CLI chown ${vo_user[0]} $dir/$vo
    $CHIMERA_CLI chgrp ${vo_user[1]} $dir/$vo
    $CHIMERA_CLI chmod 775 $dir/$vo

    ## set tag
    echo "STATIC" | $CHIMERA_CLI writetag $dir/$vo sGroup
    echo "StoreName $vo" | $CHIMERA_CLI writetag $dir/$vo OSMTemplate
    echo "ONLINE" | $CHIMERA_CLI writetag $dir/$vo AccessLatency
    echo "REPLICA" | $CHIMERA_CLI writetag $dir/$vo RetentionPolicy
done
