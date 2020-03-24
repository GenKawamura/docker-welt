#!/bin/bash

create_spacetoken(){
    local vog=$1
    local desc=$2
    local gb_size=$3

    set -x
    ssh -c blowfish -p 22223 admin@localhost <<EOF
cd SrmSpaceManager
reserve -vog=$vog -vor=* -acclat=ONLINE -retpol=REPLICA -lg=atlas-link-group -desc=$desc ${gb_size}GB "-1"
..
logoff
EOF
    set +x

}

## show usage
usage="$0 [spacetoken_desc] [size]

   * example (create ATLASLOCALGROUPDISK spacetoken with 1GB)
   $0 ATLASLOCALGROUPDISK 1

   Report Bugs to <Gen.Kawamura@cern.ch>
"

[ $# -ne 2 ] && echo "$usage" && exit 0


## exec
create_spacetoken "/atlas" $1 $2
