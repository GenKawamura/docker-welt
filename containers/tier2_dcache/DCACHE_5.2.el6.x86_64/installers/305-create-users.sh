read_siteinfo_def +x

## install yaim
yum --nogpgcheck -y install glite-yaim-core


## set yaim config_users
export alias mv='mv -f'
yaimlog(){
    echo $*
}
export -f yaimlog

. /opt/glite/yaim/functions/config_users
. /opt/glite/yaim/functions/utils/vo_param
. /opt/glite/yaim/functions/utils/check_users_conf_format


## start yaim config users
set +x
export CONFIG_USERS=yes
config_users
