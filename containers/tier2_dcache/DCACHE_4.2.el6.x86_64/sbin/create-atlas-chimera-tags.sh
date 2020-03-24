#!/bin/bash

tokendirs=(atlaslocalgroupdisk atlasscratchdisk atlasproddisk atlasdatadisk)
vo=atlas
mapped_group=(atlas atlas atlas atlas)
GLITE_SITE_INFO_DEF=/root/conf/glite/site-info.def

export PATH=/opt/d-cache/bin:$PATH
CHIMERA_CLI=chimera-cli.sh


# function
get_vo_user(){
    RET=""
    query_vo=$1
    grep "^.*:.*:.*:.*:$query_vo:.*$" $USERS_CONF &> /dev/null || return 1

    a_user_in_vo=$(grep "^.*:.*:.*:.*:$query_vo:.*$" $USERS_CONF | head -n 1)
    RET=$(echo $a_user_in_vo | perl -pe "s/^(.*?):.*?:(.*?):.*?:.*?:.*?$/\1 \2/")
    return 0
}



usage="$0 [option]

  -d:  select a directory from [${tokendirs[*]}] 
  -i:  input spacetoken identifier

  -s:  a location of site-info.def [default:$GLITE_SITE_INFO_DEF]

 Report Bugs to <Gen.Kawamura@cern.ch>
"

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 0
fi


#--------------------------
# Getopt
#--------------------------
while getopts "d:i:s:hv" op
  do
  case $op in
      d) dir=$OPTARG
	  ;;
      i) spacetoken_id=$OPTARG
	  ;;
      s) GLITE_SITE_INFO_DEF=$OPTARG
	  ;;
      h) echo "$usage"
	  exit 0
	  ;;
      v) echo "$version"
	  exit 0
	  ;;
      ?) echo "$usage"
	  exit 0
	  ;;
  esac
done



#--------------------------
# Main
#--------------------------
if [ -e $GLITE_SITE_INFO_DEF ]; then
    . $GLITE_SITE_INFO_DEF
else
    echo "no $GLITE_SITE_INFO_DEF file!"
    exit -1
fi


i=0
for tokendir in ${tokendirs[*]}
do
    if [ "$tokendir" == "$dir" ]; then
	pnfsdir=$DCACHE_PNFS_VO_DIR/$vo/$tokendir

	## create dir
	echo "Making tags for [$pnfsdir] ..."
	$CHIMERA_CLI Ls $pnfsdir &> /dev/null
	[ $? -ne 0 ] && $CHIMERA_CLI Mkdir $pnfsdir

        ## set vo user
	get_vo_user ${mapped_group[$i]} || continue
	vo_user=($RET)
	
        ## set owner and permission
	$CHIMERA_CLI Chown $pnfsdir ${vo_user[0]}
	$CHIMERA_CLI Chgrp $pnfsdir ${vo_user[1]}
	$CHIMERA_CLI Chmod $pnfsdir 775
	
        ## set tag
	echo "STATIC" | $CHIMERA_CLI Writetag $pnfsdir sGroup
	echo "StoreName $vo" | $CHIMERA_CLI Writetag $pnfsdir OSMTemplate
	echo "ONLINE" | $CHIMERA_CLI Writetag $pnfsdir AccessLatency
	echo "REPLICA" | $CHIMERA_CLI Writetag $pnfsdir RetentionPolicy

	[ ! -z "$spacetoken_id" ] && echo "$spacetoken_id" | $CHIMERA_CLI Writetag $pnfsdir WriteToken

	## show tag
	$CHIMERA_CLI Ls $pnfsdir
	echo -n "sGroup          = "; $CHIMERA_CLI readtag $pnfsdir sGroup
	echo -n "OSMTemplate     = "; $CHIMERA_CLI readtag $pnfsdir OSMTemplate
	echo -n "AccessLatency   = "; $CHIMERA_CLI readtag $pnfsdir AccessLatency
	echo -n "RetentionPolicy = "; $CHIMERA_CLI readtag $pnfsdir RetentionPolicy

	if [ ! -z "$spacetoken_id" ]; then
	    echo -n "WriteToken      = "; $CHIMERA_CLI readtag $pnfsdir WriteToken
	fi

    fi
    i=$(expr $i + 1)
done
